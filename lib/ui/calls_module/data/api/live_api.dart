import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveApi {
  // StreamSubscription<QuerySnapshot<Post>> listenToInComingCall({
  //   required String currentUserID,
  // }) {
  //   return Post.ref
  //       .where(PoLabels.authorName.name, isEqualTo: currentUserID)
  //       .where(PoLabels.postType.name, isEqualTo: PostTypes.live.name)
  //       .where(PoLabels.timestamp.name, isGreaterThan: Timestamp.now())
  //       .orderBy(PoLabels.timestamp.name, descending: true)
  //       .limit(1)
  //       .snapshots()
  //       .listen((event) {});
  // }

  StreamSubscription<DocumentSnapshot<Post>> listenToLiveStatus({
    required String postID,
  }) {
    return Post.ref.doc(postID).snapshots().listen((event) {});
  }

  Future<void> addStartingLiveEvent({
    required Post post,
    required AppUser currentUser,
  }) {
    final postDoc = Post.ref.doc(post.postID!);
    final liveEventRef = LiveEvent.ref(postID: post.postID!).doc();

    final batch = FirebaseFirestore.instance.batch();
    final liveEvent = LiveEvent(
      postID: post.postID,
      liveEventID: liveEventRef.id,
      relatedItemRef: null,
      relatedItemType: null,
      channelName: post.channelName,
      token: post.token,
      type: LiveEventTypes.live.name,
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      status: LiveEventStatus.starting.name,
      createAt: post.timestamp,
      timestamp: FieldValue.serverTimestamp(),
      text: null,
      item: null,
      location: null,
      order: null,
      swap: null,
      otherItems: null,
      senderItems: null,
      photoUrls: null,
    );

    batch
      ..set<Post>(postDoc, post, SetOptions(merge: true))
      ..set<LiveEvent>(liveEventRef, liveEvent);
    return batch.commit();
  }

  Future<void> updateUserBusyStatusFirestore({
    required Post post,
    required bool busyCalling,
  }) async {
    if (busyCalling) {
      return SharedPreferences.getInstance()
          .then((prefs) => prefs.setString("currentLiveID", post.postID!));
    }

    if (!busyCalling) {
      return SharedPreferences.getInstance().then((prefs) => prefs.remove("currentLiveID"));
    }
  }

  //Sender
  Future<dynamic> generateCallToken({required Map<String, dynamic> queryMap}) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('createCallsWithToken');

      final response = await callable.call({
        'channelName': queryMap['channelName'],
        'uid': queryMap['uid'],
      });

      debugPrint('fireVideoCallResp: ${response.data}');

      return response.data;
    } catch (error) {
      debugPrint("fireVideoCallError: ${error.toString()}");
    }
  }

  Future<void> updateLiveStatus({
    required Post post,
    required String status,
  }) {
    final postDoc = Post.ref.doc(post.postID);
    final liveEventRef = LiveEvent.ref(postID: post.postID!).doc();
    final AppUser? currentUser = BlocProvider.of<AuthBloc>(Get.context!).currentUser;

    final batch = FirebaseFirestore.instance.batch();
    final liveEvent = LiveEvent(
      postID: post.postID,
      liveEventID: liveEventRef.id,
      type: LiveEventTypes.live.name,
      relatedItemType: null,
      relatedItemRef: null,
      token: post.token,
      channelName: post.channelName,
      senderID: currentUser!.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      status: status,
      createAt: post.timestamp,
      timestamp: FieldValue.serverTimestamp(),
      item: null,
      location: null,
      order: null,
      swap: null,
      otherItems: null,
      senderItems: null,
      text: null,
      photoUrls: null,
    );

    batch
      ..set<LiveEvent>(liveEventRef, liveEvent)
      ..update(postDoc, {PoLabels.lastLiveEvent.name: liveEvent.toFirestore()});

    return batch.commit();
  }

  Future<void> endCurrentLive({required Post post}) {
    return Post.ref.doc(post.postID).update(
        {'${PoLabels.lastLiveEvent.name}.${LELabels.status.name}': LiveEventStatus.ended.name});
  }
}
