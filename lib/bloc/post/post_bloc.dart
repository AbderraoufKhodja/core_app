import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/models/comment.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/fibali_core/models/d_l_params.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/favorite.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/view_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _db = FirebaseFirestore.instance;
  final likesRef = Like.ref;
  final postsRef = Post.ref;

  bool isSubmitting = false;

  PostBloc() : super(PostInitial()) {
    on<PostEvent>((event, emit) {
      if (event is LoadPost) {
        emit(PostLoading());

        final post = postsRef.doc(event.postID).snapshots();

        emit(PostLoaded(post: BehaviorSubject()..addStream(post)));
      }
    });
  }

  Future<void> addViewPost({required String? photo, required String postID, required String uid}) {
    FAC.logEvent(FAEvent.view_post);

    final writeBatch = FirebaseFirestore.instance.batch();

    final postRef = Post.ref.doc(postID);

    writeBatch
      ..set<ViewItem>(
          ViewItem.ref.doc('view_$uid$postID'),
          ViewItem(
            uid: uid,
            itemID: postID,
            photo: photo,
            type: VTypes.post.name,
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(postRef, {PoLabels.numViews.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleAddComment(
    context, {
    required AppUser currentUser,
    required Post post,
    required List<XFile>? photos,
    required String? commentText,
  }) async {
    FAC.logEvent(FAEvent.add_post_comment);

    if (isSubmitting) {
      return EasyLoading.showToast(
        RCCubit.instance.getText(R.alreadySubmitting),
        toastPosition: EasyLoadingToastPosition.bottom,
        duration: const Duration(seconds: 2),
      );
    }

    isSubmitting = true;
    EasyLoading.show(status: RCCubit.instance.getText(R.submittingComment), dismissOnTap: true);
    // Check if the post has text violation
    try {
      // if (commentText?.isNotEmpty == true) {
      //   if (await Utils.handleHasTextViolation(text: commentText!)) {
      //     isSubmitting = false;
      //     return;
      //   }
      // }

      final writeBatch = _db.batch();
      final postRef = Post.ref.doc(post.postID);
      final userNotifCollection = AppNotification.ref(userID: post.uid!).doc();
      final commentRef = Comment.ref(postID: post.postID!).doc();

      final photoUrls = photos?.isNotEmpty == true
          ? await Utils.uploadPhotos(
              ref: Comment.storageRef(commentPath: commentRef.path), files: photos!)
          : [];

      String type = '';

      if (photoUrls.isNotEmpty) type = 'photo';
      if (commentText != null) type = 'text';
      if (photoUrls.isNotEmpty && commentText != null) type = 'textPhoto';

      final comment = Comment(
        type: type,
        postID: post.postID,
        commentID: commentRef.id,
        commentRef: commentRef.path,
        authorID: post.uid,
        senderName: currentUser.name,
        senderPhoto: currentUser.photoUrl,
        senderID: currentUser.uid,
        numComments: 0,
        numLikes: 0,
        hasReplies: false,
        text: commentText,
        photoUrls: photoUrls,
        timestamp: FieldValue.serverTimestamp(),
      );

      writeBatch
        ..set(commentRef, comment)
        ..update(postRef, {ComLabels.numComments.name: FieldValue.increment(1)});

      if (post.uid != currentUser.uid) {
        writeBatch.set(
          userNotifCollection,
          AppNotification(
            notificationType: AppNotTypes.post.name,
            type: PostNotTypes.newPostComment.name,
            commentType: type,
            callStatus: null,
            callID: null,
            notificationID: userNotifCollection.id,
            chatID: null,
            messageID: null,
            postID: post.postID,
            orderID: null,
            storeID: null,
            order: null,
            item: null,
            senderItems: null,
            otherItems: null,
            location: null,
            senderName: currentUser.name,
            senderPhoto: currentUser.photoUrl,
            senderID: currentUser.uid,
            receiverID: post.uid,
            isSeen: {post.uid!: false},
            description: null,
            text: commentText,
            title: null,
            photoUrl: currentUser.photoUrl,
            timestamp: FieldValue.serverTimestamp(),
            itemID: null,
          ),
        );
      }

      return writeBatch.commit().then((value) {
        isSubmitting = false;
        EasyLoading.dismiss();
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        isSubmitting = false;
        EasyLoading.dismiss();
        EasyLoading.showError(RCCubit.instance.getText(R.failed));
      });
    } catch (error) {
      Logger().e(error.toString());
      isSubmitting = false;
      EasyLoading.showError(RCCubit.instance.getText(R.failed));
    }
  }

  Future<void> handleAddCommentReply(
    context, {
    required AppUser currentUser,
    required Comment comment,
    required DocumentReference documentRef,
    required List<XFile>? photos,
    required String? commentText,
  }) async {
    FAC.logEvent(FAEvent.add_post_comment_reply);

    isSubmitting = true;
    EasyLoading.show(
      status: RCCubit.instance.getText(R.submittingComment),
      dismissOnTap: true,
    );
    // Check if the post has text violation
    // if (comment.text?.isNotEmpty == true) {
    //   if (await Utils.handleHasTextViolation(text: comment.text!)) {
    //     isSubmitting = false;
    //     return;
    //   }
    // }

    final writeBatch = _db.batch();
    final commentRef = documentRef;
    final postRef = _db.collection(postsCollection).doc(comment.postID);
    final userNotifCollection = AppNotification.ref(userID: comment.authorID!).doc();

    final replyRef = commentRef.collection('comments').doc().withConverter<Comment>(
          fromFirestore: (snapshot, options) => Comment.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        );

    final photoUrls = photos?.isNotEmpty == true
        ? await Utils.uploadPhotos(
            ref: Comment.storageRef(commentPath: commentRef.path), files: photos!)
        : [];

    String type = '';

    if (photoUrls.isNotEmpty) type = 'photo';
    if (commentText != null) type = 'text';
    if (photoUrls.isNotEmpty && commentText != null) type = 'textPhoto';

    final reply = Comment(
      type: type,
      postID: comment.postID,
      authorID: comment.authorID,
      commentID: replyRef.id,
      commentRef: replyRef.path,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      senderID: currentUser.uid,
      numComments: 0,
      numLikes: 0,
      hasReplies: false,
      text: commentText,
      photoUrls: photoUrls,
      timestamp: FieldValue.serverTimestamp(),
    );

    writeBatch
      ..set(replyRef, reply)
      ..update(commentRef, {ComLabels.numComments.name: FieldValue.increment(1)})
      ..update(postRef, {ComLabels.numComments.name: FieldValue.increment(1)});

    if (comment.authorID != currentUser.uid) {
      writeBatch.set(
        userNotifCollection,
        AppNotification(
          notificationType: AppNotTypes.post.name,
          type: PostNotTypes.newCommentReply.name,
          commentType: type,
          callStatus: null,
          callID: null,
          notificationID: userNotifCollection.id,
          chatID: null,
          messageID: null,
          postID: comment.postID,
          itemID: null,
          orderID: null,
          storeID: null,
          order: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: comment.authorID,
          isSeen: {comment.authorID!: false},
          description: null,
          text: commentText,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
        ),
      );
    }

    return writeBatch.commit().then((value) {
      isSubmitting = false;
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      isSubmitting = false;
      EasyLoading.dismiss();
      EasyLoading.showError(RCCubit.instance.getText(R.failed));
    });
  }

  Future<void> handleLikePost(
    context, {
    required Post post,
    required AppUser currentUser,
  }) {
    FAC.logEvent(FAEvent.like_post);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _likePost(
        post: post,
        currentUser: currentUser,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _likePost({
    required Post post,
    required AppUser currentUser,
  }) {
    // TODO: adding friends and followers
    final postRef = _db.collection(postsCollection).doc(post.postID);

    final userNotifCollection = AppNotification.ref(userID: post.uid!).doc();

    final writeBatch = _db.batch();
    writeBatch
      ..set<Like>(
          likesRef.doc(currentUser.uid + post.postID!),
          Like(
            type: LiTypes.postItem.name,
            uid: currentUser.uid,
            itemID: post.postID,
            itemOwnerID: post.uid,
            followers: [],
            friends: [],
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(postRef, {ComLabels.numLikes.name: FieldValue.increment(1)});

    if (post.uid != currentUser.uid) {
      writeBatch.set(
        userNotifCollection,
        AppNotification(
          notificationType: AppNotTypes.post.name,
          type: PostNotTypes.newPostLike.name,
          commentType: null,
          callStatus: null,
          callID: null,
          notificationID: userNotifCollection.id,
          chatID: null,
          messageID: null,
          postID: post.postID,
          itemID: null,
          orderID: null,
          storeID: null,
          order: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: post.uid,
          isSeen: {post.uid!: false},
          description: null,
          text: null,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
        ),
      );
    }

    return writeBatch.commit();
  }

  Future<void> handleLikeComment(
    context, {
    required Comment comment,
    required DocumentReference documentRef,
    required AppUser currentUser,
  }) async {
    FAC.logEvent(FAEvent.like_post_comment);

    if (!isSubmitting) {
      isSubmitting = true;

      EasyLoading.show(dismissOnTap: true);
      // // Check if the post has text violation
      // if (comment.text?.isNotEmpty == true) {
      //   if (await Utils.handleHasTextViolation(text: comment.text!)) {
      //     isSubmitting = false;
      //     return;
      //   }
      // }
      return _likeComment(
        comment: comment,
        documentRef: documentRef,
        currentUser: currentUser,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _likeComment({
    required Comment comment,
    required DocumentReference documentRef,
    required AppUser currentUser,
  }) {
    // TODO: adding friends and followers
    final commentRef = documentRef;

    final writeBatch = _db.batch();
    writeBatch
      ..set<Like>(
          likesRef.doc(currentUser.uid + comment.commentID!),
          Like(
            type: LiTypes.commentItem.name,
            uid: currentUser.uid,
            itemID: comment.commentID,
            itemOwnerID: comment.authorID,
            followers: [],
            friends: [],
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(commentRef, {ComLabels.numLikes.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleRemoveLikePost(
    context, {
    required Post post,
    required String currentUserID,
  }) {
    FAC.logEvent(FAEvent.remove_post_like);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _removeLikePost(
        post: post,
        currentUserID: currentUserID,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _removeLikePost({
    required Post post,
    required String currentUserID,
  }) {
    final postRef = _db.collection(postsCollection).doc(post.postID);

    final writeBatch = _db.batch();
    writeBatch
      ..delete(likesRef.doc(currentUserID + post.postID!))
      ..update(postRef, {ComLabels.numLikes.name: FieldValue.increment(-1)});

    return writeBatch.commit();
  }

  Future<void> handleRemoveLikeComment(
    context, {
    required Comment comment,
    required DocumentReference documentRef,
    required String currentUserID,
  }) {
    FAC.logEvent(FAEvent.remove_post_comment_like);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _removeLikeComment(
        comment: comment,
        documentRef: documentRef,
        currentUserID: currentUserID,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _removeLikeComment({
    required Comment comment,
    required DocumentReference documentRef,
    required String currentUserID,
  }) {
    final commentRef = documentRef;

    final writeBatch = _db.batch();
    writeBatch
      ..delete(likesRef.doc(currentUserID + comment.commentID!))
      ..update(commentRef, {ComLabels.numLikes.name: FieldValue.increment(-1)});

    return writeBatch.commit();
  }

  Future<void> handleAddFavoritePost(
    context, {
    required Post post,
    required String currentUserID,
    required String photo,
  }) {
    FAC.logEvent(FAEvent.add_post_to_favorite);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _addFavoritePost(
        post: post,
        currentUserID: currentUserID,
        photo: photo,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _addFavoritePost({
    required Post post,
    required String currentUserID,
    required String photo,
  }) {
    final postRef = _db.collection('posts').doc(post.postID);
    final favorite = Favorite(
      uid: currentUserID,
      itemID: post.postID,
      timestamp: FieldValue.serverTimestamp(),
      photo: photo,
      type: 'shoppingItem',
    );

    final writeBatch = _db.batch();

    writeBatch
      ..set<Favorite>(Favorite.ref.doc(currentUserID + post.postID!), favorite)
      ..update(postRef, {'numFavorites': FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleRemoveFavoritePost(
    context, {
    required Post post,
    required String currentUserID,
  }) {
    FAC.logEvent(FAEvent.remove_post_from_favorite);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _removeFavoritePost(
        post: post,
        currentUserID: currentUserID,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _removeFavoritePost({
    required Post post,
    required String currentUserID,
  }) {
    final postRef = _db.collection(postsCollection).doc(post.postID);

    final writeBatch = _db.batch();
    writeBatch
      ..delete(Favorite.ref.doc(currentUserID + post.postID!))
      ..update(postRef, {'numFavorites': FieldValue.increment(-1)});

    return writeBatch.commit();
  }

  Future<void> _sharePost({
    required Post post,
    required String subject,
  }) async {
    final dynamicLinks = FirebaseDynamicLinks.instance;

    final parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://fibali.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri(
        scheme: 'https',
        host: 'mobile-fibali.web.app',
        path: DLTypes.post.name,
        queryParameters: post.toLinkJson(),
      ),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: "com.deepdev.fibali",
        minimumVersion: 1,
      ),

      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: "com.deepdev.fibali",
        minimumVersion: '1',
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
        title: post.authorName,
        description: post.description,
        imageUrl: Uri.parse(post.photoUrls![0]),
      ),
    );

    final uri = await dynamicLinks.buildShortLink(parameters);
    return Share.share(uri.shortUrl.toString());
  }

  Future<void> handleSharePost({required Post post}) {
    FirebaseAnalytics.instance.logShare(
      contentType: 'post',
      itemId: post.postID!,
      method: 'unknown',
    );

    //TODO: add share post message

    EasyLoading.show(dismissOnTap: true);
    return _sharePost(
      post: post,
      subject: RCCubit.instance.getText(R.checkOutThisPost),
    ).then((value) {
      EasyLoading.dismiss(animation: true);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }

  Future<void> handleRemovePost({required String postID}) {
    FAC.logEvent(FAEvent.remove_post);

    EasyLoading.show(dismissOnTap: true);
    return _deletePost(postID: postID).then((value) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showSuccess(RCCubit.instance.getText(R.deleting), dismissOnTap: true);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }

  Future<void> _deletePost({required String postID}) async {
    // delete post from firestore
    final postRef = Post.ref.doc(postID);
    await postRef.delete();
    // delete post images from storage
    // list all files in a common prefix, iterate the results, and delete each object individually.
    // TODO: need to be tested
    final ListResult result = await Post.photoStorageRef(postID: postID).parent!.listAll();
    for (final Reference ref in result.items) {
      await ref.delete();
    }
  }
}
