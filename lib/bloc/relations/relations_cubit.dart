import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class RelationsCubit extends Cubit<RelationsState> with HydratedMixin {
  RelationsCubit() : super(RelationsInitial());
  StreamSubscription<QuerySnapshot<Relation>>? relationsSubscription;
  Stream<QuerySnapshot<Relation>>? relationsStream;

  @override
  RelationsState? fromJson(Map<String, dynamic> json) {
    try {
      final relationsMap = json['relations'] as List<dynamic>?;
      final relations = relationsMap!.map((map) => Relation.fromJson(map)).toList();
      return RelationsLoaded(relations: relations);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(RelationsState state) {
    if (state is RelationsLoaded) return state.toJson();
    return null;
  }

  static List<Relation>? getBlockedRelations(
      {required RelationsLoaded state, required String currentUserID}) {
    return state.relations?.where((relation) {
      return relation.type == ReTypes.blocked.name || relation.type == ReTypes.blockedBy.name;
    }).toList();
  }

  void initStream({required String userID}) {
    relationsStream = BehaviorSubject()
      ..addStream(
        Relation.ref(userID: userID).where(ReLabels.type.name, whereIn: [
          // Excluding users that are following me
          ReTypes.friends.name,
          ReTypes.friendRequested.name,
          ReTypes.friendRequestedBy.name,
          ReTypes.followed.name,
          ReTypes.blocked.name,
          ReTypes.blockedBy.name,
        ]).snapshots(),
      );

    relationsSubscription = relationsStream!.listen(
      (querySnapshot) async {
        if (querySnapshot.docChanges.isEmpty && state is RelationsLoaded) {
          return;
        }

        emit(RelationsLoading());
        await Future.delayed(const Duration(milliseconds: 100));
        refreshFollowingUsersPosts(
          userID: userID,
          relationsChange: querySnapshot.docChanges,
          currentRelations: querySnapshot.docs,
        );
        final relations = querySnapshot.docs.map((relation) => relation.data()).toList();

        emit(RelationsLoaded(relations: relations));
      },
    );
  }

  void loadRelations({required String userID}) {
    emit(RelationsLoading());
    relationsSubscription?.cancel();
    final Stream<QuerySnapshot<Relation>> stream = BehaviorSubject()
      ..addStream(Relation.ref(userID: userID).where(ReLabels.type.name, whereIn: [
        // Excluding users that are following me
        ReTypes.friends.name,
        ReTypes.friendRequested.name,
        ReTypes.friendRequestedBy.name,
        ReTypes.followed.name,
        ReTypes.blocked.name,
        ReTypes.blockedBy.name,
      ]).snapshots());

    relationsSubscription = stream.listen(
      (querySnapshot) {
        emit(RelationsLoading());
        refreshFollowingUsersPosts(
          userID: userID,
          relationsChange: querySnapshot.docChanges,
          currentRelations: querySnapshot.docs,
        );
        final relations = querySnapshot.docs.map((relation) => relation.data()).toList();
        emit(RelationsLoaded(relations: relations));
      },
    );
  }

  Future<void> refreshFollowingUsersPosts({
    required String userID,
    required List<DocumentChange<Relation>> relationsChange,
    required List<QueryDocumentSnapshot<Relation>> currentRelations,
  }) async {
    // Careful when dealing with real time change: don't introduce a recurrent loop
    relationsChange.where((relationChange) {
      return relationChange.type == DocumentChangeType.added &&
          relationChange.doc.data()?.type == ReTypes.followed.name;
    }).forEach(
      (addedFollowChange) async {
        final followRelation = addedFollowChange.doc.data();
        if (followRelation != null) {
          if (followRelation.isValid() == true) {
            late Timestamp timestamp;
            if (followRelation.lastPostCheckTimestamp is Timestamp) {
              timestamp = followRelation.lastPostCheckTimestamp as Timestamp;
            } else {
              timestamp = Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 90)));
            }

            final isFriend = currentRelations.any((relation) =>
                relation.data().uid == followRelation.uid &&
                relation.data().type == ReTypes.friends.name);

            final query = await getPostBasedOnTimestamp(
              relation: followRelation,
              timestamp: timestamp,
              isFriend: isFriend,
            );

            await Future.wait(query.docs.map((doc) => recordFollowingUserPost(userID, doc)));

            updateLastPostsCheckTimestamp(addedFollowChange.doc);
          }
        }
      },
    );

    relationsChange
        .where((relationChange) =>
            relationChange.type == DocumentChangeType.removed &&
            relationChange.doc.data()?.type == ReTypes.followed.name)
        .forEach(
      (removedFollowChange) async {
        final unfollowRelation = removedFollowChange.doc.data();
        if (unfollowRelation != null) {
          if (unfollowRelation.isValid() == true) {
            final query = await getPostBasedOnID(
              userID: userID,
              relation: unfollowRelation,
            );

            // Remove unfollowed user posts records.
            await Future.wait(query.docs.map((doc) => doc.reference.delete()));
          }
        }
      },
    );
  }

  Future<QuerySnapshot<Post>> getPostBasedOnTimestamp({
    required Relation relation,
    required Timestamp timestamp,
    required bool isFriend,
  }) async {
    return Post.ref
        .where(PoLabels.uid.name, isEqualTo: relation.uid)
        .where(PoLabels.privacy.name, whereIn: [
          PostPrivacyType.public.name,
          PostPrivacyType.followers.name,
          if (isFriend) PostPrivacyType.friends.name,
        ])
        .where(PoLabels.timestamp.name, isGreaterThan: timestamp)
        .get();
  }

  Future<QuerySnapshot<Post>> getPostBasedOnID({
    required String userID,
    required Relation relation,
  }) async {
    return Post.followingRef(userID: userID)
        .where(PoLabels.uid.name, isEqualTo: relation.uid)
        .get();
  }

  Future<void> recordFollowingUserPost(String userID, QueryDocumentSnapshot<Post> doc) {
    return Post.followingRef(userID: userID).doc(doc.id).set(doc.data());
  }

  Future<void> updateLastPostsCheckTimestamp(DocumentSnapshot<Relation> relationDoc) {
    return relationDoc.reference
        .update({ReLabels.lastPostCheckTimestamp.name: FieldValue.serverTimestamp()});
  }

  Future<void> onSendFriendRequest({
    required AppUser currentUser,
    required AppUser otherUser,
    required String text,
  }) {
    EasyLoading.show(dismissOnTap: true);

    final batch = FirebaseFirestore.instance.batch();
    final currentUserRelationsRef = Relation.ref(userID: currentUser.uid)
        .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid));

    final userRelationsRef = Relation.ref(userID: otherUser.uid)
        .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid));

    final userNotificationsRef = AppNotification.ref(userID: otherUser.uid).doc();

    batch
      ..set(
        currentUserRelationsRef,
        Relation(
          type: ReTypes.friendRequested.name,
          uid: otherUser.uid,
          text: text,
          lastPostCheckTimestamp: FieldValue.serverTimestamp(),
          timestamp: FieldValue.serverTimestamp(),
        ),
        SetOptions(merge: true),
      )
      ..set(
        userRelationsRef,
        Relation(
          type: ReTypes.friendRequestedBy.name,
          uid: currentUser.uid,
          text: text,
          lastPostCheckTimestamp: FieldValue.serverTimestamp(),
          timestamp: FieldValue.serverTimestamp(),
        ),
      )
      ..set(
        userNotificationsRef,
        AppNotification(
          notificationType: AppNotTypes.relation.name,
          type: RelationNotTypes.friendRequest.name,
          notificationID: userNotificationsRef.id,
          commentType: null,
          callStatus: null,
          callID: null,
          chatID: null,
          messageID: null,
          orderID: null,
          order: null,
          postID: null,
          storeID: null,
          itemID: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: otherUser.uid,
          isSeen: {otherUser.uid: false},
          description: null,
          text: text,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
        ),
      );

    return batch.commit().then((value) {
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      EasyLoading.showError('');
    });
  }

  Future<void> onAcceptFriendRequest({
    required String otherUserID,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);

    final batch = FirebaseFirestore.instance.batch();
    final currentUserRelationsRef = Relation.ref(userID: currentUser.uid)
        .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUserID));
    final userRelationsRef = Relation.ref(userID: otherUserID)
        .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUserID));
    final userNotificationsRef = AppNotification.ref(userID: otherUserID).doc();

    batch
      ..set(
        currentUserRelationsRef,
        Relation(
          type: ReTypes.friends.name,
          uid: otherUserID,
          text: null,
          lastPostCheckTimestamp: FieldValue.serverTimestamp(),
          timestamp: FieldValue.serverTimestamp(),
        ),
        SetOptions(merge: true),
      )
      ..set(
        userRelationsRef,
        Relation(
          type: ReTypes.friends.name,
          uid: currentUser.uid,
          text: null,
          lastPostCheckTimestamp: FieldValue.serverTimestamp(),
          timestamp: FieldValue.serverTimestamp(),
        ),
      )
      ..set(
        userNotificationsRef,
        AppNotification(
          notificationType: AppNotTypes.relation.name,
          type: RelationNotTypes.friendRequestAccepted.name,
          notificationID: userNotificationsRef.id,
          commentType: null,
          callID: null,
          callStatus: null,
          chatID: null,
          messageID: null,
          orderID: null,
          storeID: null,
          order: null,
          postID: null,
          itemID: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: otherUserID,
          isSeen: {otherUserID: false},
          description: null,
          text: null,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
        ),
      );

    batch.commit().then((value) => EasyLoading.dismiss()).onError((error, stackTrace) {
      EasyLoading.showError('');
    });
  }

  Future<void> onUnblock({
    required String otherUserID,
    required String currentUserID,
  }) async {
    EasyLoading.show(dismissOnTap: true);

    return Future.wait([
      Relation.ref(userID: currentUserID)
          .doc(Utils.getUniqueID(firstID: currentUserID, secondID: otherUserID))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      }),
      Relation.ref(userID: otherUserID)
          .doc(Utils.getUniqueID(firstID: currentUserID, secondID: otherUserID))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      })
    ])
        .then((value) => EasyLoading.dismiss())
        .onError((error, stackTrace) => EasyLoading.showError(''));
  }

  Future<void> onBlock({
    required AppUser otherUser,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);
    final batch = FirebaseFirestore.instance.batch();
    // Unfollow the user
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('newPost_${otherUser.uid}');
    }

    final currentUserFollowRef =
        Relation.ref(userID: currentUser.uid).doc('follow_${currentUser.uid}_${otherUser.uid}');
    final currentUserFollowByRef =
        Relation.ref(userID: otherUser.uid).doc('follow_${currentUser.uid}_${otherUser.uid}');
    final otherUserFollowRef =
        Relation.ref(userID: currentUser.uid).doc('follow_${otherUser.uid}_${currentUser.uid}');
    final otherUserFollowByRef =
        Relation.ref(userID: otherUser.uid).doc('follow_${otherUser.uid}_${currentUser.uid}');

    final currentUserFollowDoc = await currentUserFollowRef.get();
    if (currentUserFollowDoc.exists) {
      batch.delete(currentUserFollowRef);
    }

    final currentUserFollowByDoc = await currentUserFollowByRef.get();
    if (currentUserFollowByDoc.exists) {
      batch.delete(currentUserFollowByRef);
    }

    final otherUserFollowDoc = await otherUserFollowRef.get();
    if (otherUserFollowDoc.exists) {
      batch.delete(otherUserFollowRef);
    }

    final otherUserFollowByDoc = await otherUserFollowByRef.get();
    if (otherUserFollowByDoc.exists) {
      batch.delete(otherUserFollowByRef);
    }

    // Block the user
    batch
      ..set(
          Relation.ref(userID: currentUser.uid)
              .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid)),
          Relation(
            type: ReTypes.blocked.name,
            uid: otherUser.uid,
            text: null,
            lastPostCheckTimestamp: FieldValue.serverTimestamp(),
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..set(
          Relation.ref(userID: otherUser.uid)
              .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid)),
          Relation(
            type: ReTypes.blockedBy.name,
            uid: currentUser.uid,
            text: null,
            lastPostCheckTimestamp: FieldValue.serverTimestamp(),
            timestamp: FieldValue.serverTimestamp(),
          ));

    return batch
        .commit()
        .then((value) => EasyLoading.dismiss())
        .onError((error, stackTrace) => EasyLoading.showError(''));
  }

  Future<void> onDeclineFriendRequest({
    required String otherUserID,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);

    return Future.wait([
      Relation.ref(userID: currentUser.uid)
          .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUserID))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      }),
      Relation.ref(userID: otherUserID)
          .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUserID))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      })
    ])
        .then((value) => EasyLoading.dismiss())
        .onError((error, stackTrace) => EasyLoading.showError(''));
  }

  Future<void> onCancelFriendRequest({
    required AppUser otherUser,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);

    return Future.wait([
      Relation.ref(userID: currentUser.uid)
          .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      }),
      Relation.ref(userID: otherUser.uid)
          .doc(Utils.getUniqueID(firstID: currentUser.uid, secondID: otherUser.uid))
          .get()
          .then((doc) {
        if (doc.exists) return doc.reference.delete();
      })
    ])
        .then((value) => EasyLoading.dismiss())
        .onError((error, stackTrace) => EasyLoading.showError(''));
  }

  Future<void> onUnfollow({
    required AppUser otherUser,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('newPost_${otherUser.uid}');
    }

    final batch = FirebaseFirestore.instance.batch();
    final currentUserRef =
        Relation.ref(userID: currentUser.uid).doc('follow_${currentUser.uid}_${otherUser.uid}');
    final otherUserRef =
        Relation.ref(userID: otherUser.uid).doc('follow_${currentUser.uid}_${otherUser.uid}');

    batch
      ..delete(currentUserRef)
      ..delete(otherUserRef);

    return batch
        .commit()
        .then((value) => EasyLoading.dismiss())
        .onError((error, stackTrace) => EasyLoading.showError(''));
  }

  Future<void> onFollow({
    required String otherUserID,
    required AppUser currentUser,
  }) async {
    EasyLoading.show(dismissOnTap: true);
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic('newPost_$otherUserID');
    }

    final batch = FirebaseFirestore.instance.batch();

    final currentUserRelationsRef =
        Relation.ref(userID: currentUser.uid).doc('follow_${currentUser.uid}_$otherUserID');
    final otherUserRelationsRef =
        Relation.ref(userID: otherUserID).doc('follow_${currentUser.uid}_$otherUserID');

    final userNotificationsRef = AppNotification.ref(userID: otherUserID).doc();

    batch
      ..set(
        currentUserRelationsRef,
        Relation(
          type: ReTypes.followed.name,
          uid: otherUserID,
          text: null,
          lastPostCheckTimestamp: null,
          timestamp: FieldValue.serverTimestamp(),
        ),
        SetOptions(merge: true),
      )
      ..set(
        otherUserRelationsRef,
        Relation(
          type: ReTypes.followedBy.name,
          uid: currentUser.uid,
          text: null,
          lastPostCheckTimestamp: null,
          timestamp: FieldValue.serverTimestamp(),
        ),
      )
      ..set(
        userNotificationsRef,
        AppNotification(
          notificationType: AppNotTypes.relation.name,
          type: RelationNotTypes.newFollow.name,
          notificationID: userNotificationsRef.id,
          commentType: null,
          callStatus: null,
          callID: null,
          chatID: null,
          messageID: null,
          orderID: null,
          storeID: null,
          order: null,
          postID: null,
          itemID: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: otherUserID,
          isSeen: {otherUserID: false},
          description: null,
          text: null,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
        ),
      );

    return batch.commit().then((value) => EasyLoading.dismiss()).onError((error, stackTrace) {
      EasyLoading.showError('');
    });
  }

  bool? isFriend(
    List<Relation>? relations,
    String? userID,
  ) {
    return relations?.any((doc) => doc.uid == userID && doc.type == ReTypes.friends.name);
  }

  bool? isFollowed(
    List<Relation>? relations,
    String? userID,
  ) {
    return relations?.any((doc) => doc.uid == userID && doc.type == ReTypes.followed.name);
  }

  bool? isBlockedBy(
    List<Relation>? relations,
    String? userID,
  ) {
    return relations?.any((doc) => doc.uid == userID && doc.type == ReTypes.blockedBy.name);
  }

  bool? isBlocked(
    List<Relation>? relations,
    String? userID,
  ) {
    return relations?.any((doc) => doc.uid == userID && doc.type == ReTypes.blocked.name);
  }
}
