import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fibali/fibali_core/algeria_location.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/post.dart';

import 'bloc.dart';

class VideoPostFactoryBloc extends Bloc<VideoPostFactoryEvent, VideoPostFactoryState> {
  final formKey = GlobalKey<FormState>();
  final pageController = PageController();

  final postCategories = [
    'fashion',
    'beauty',
    'travel',
    'food',
    'family',
    'health',
    'fitness',
    'music',
    'movies',
    'specialEvents',
    'hobbies',
    'technology',
    'homeDecor',
    'dIY',
    'gardening',
    'finance',
    'studentLife',
    'pets',
    'currentNews',
    'science',
  ];

  List<String> provinces = AlgeriaCities.getProvinces();
  List<String> subProvinces = [];
  List<String> subSubProvinces = [];
  String? country;
  String? privacy = 'public';
  String? province;
  String? subProvince;
  String? subSubProvince;
  final AppUser currentUser;
  late Post post;

  bool _isSubmitting = false;

  bool? isKeyValid;

  int currentImageIdx = 0;

  VideoPostFactoryBloc({required this.currentUser}) : super(PostFactoryInitial()) {
    on<LoadPost>((event, emit) async {
      if (event.postID is String) {
        emit(PostFactoryLoading());
        final itemDoc = await getPost(postID: event.postID!);
        if (itemDoc.exists) {
          post = itemDoc.data()!;
          emit(ExistingPost());
          return;
        }
      }

      post = await getCachePost();
      if (event.video != null) {
        emit(NewPost(file: event.video!));
      }
    });
  }

  Future<DocumentSnapshot<Post>> getPost({required String postID}) {
    final itemDoc = Post.ref.doc(postID).get();
    return itemDoc;
  }

  Future<Post> getCachePost() async {
    final prefs = await SharedPreferences.getInstance();

    return Post.fromPreferences(prefs: prefs);
  }

  Future<void> _createVideoPost({
    required Post post,
    required AppUser currentUser,
  }) async {
    final postRef = Post.ref.doc();
    final videoStorageRef = Post.videoStorageRef(postID: postRef.id);

    try {
      final geopoint = await SettingsCubit.determinePosition(userID: currentUser.uid);

      post.location = GeoFlutterFire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
          .dataForThreeHundredKm;
    } catch (e) {}

    await Utils.uploadPostVideo(
      postID: postRef.id,
      postPath: postRef.path,
      uid: currentUser.uid,
      videoID: videoStorageRef.name,
      ref: videoStorageRef,
      file: post.videoUrl,
    );

    final uploadPost = Post(
      postID: postRef.id,
      postType: PostTypes.video.name,
      uid: currentUser.uid,
      authorName: currentUser.name,
      authorPhoto: currentUser.photoUrl,
      numLikes: 0,
      numComments: 0,
      numViews: 0,
      photoUrls: post.photoUrls,
      thumbnailUrls100x100: post.thumbnailUrls100x100,
      thumbnailUrls250x375: post.thumbnailUrls250x375,
      thumbnailUrls500x500: post.thumbnailUrls500x500,
      videoUrl: null,
      firebaseVideoUrl: post.firebaseVideoUrl,
      channelName: post.channelName,
      token: post.token,
      location: post.location,
      country: currentUser.country,
      province: post.province,
      subProvince: post.subProvince,
      subSubProvince: post.subSubProvince,
      isActive: true,
      description: post.description,
      category: post.category,
      privacy: post.privacy,
      tags: post.tags,
      lastLiveEvent: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    return postRef.set(uploadPost);
  }

  Future<void> _updatePostInfo({required Post post, required AppUser currentUser}) async {
    final postRef = Post.ref.doc(post.postID);
    final videoStorageRef = Post.videoStorageRef(postID: postRef.id);

    await Utils.uploadPostVideo(
      postID: postRef.id,
      postPath: postRef.path,
      uid: currentUser.uid,
      videoID: videoStorageRef.name,
      ref: videoStorageRef,
      file: post.videoUrl!,
    );

    // await Future.delayed(const Duration(seconds: 2));

    // final videoThumbRef = videoStorageRef.parent!.child('thumbnail__9_16_mobile_socialMedia.png');
    // final videoThumbRef100x100 = videoStorageRef.parent!
    //     .child('thumbs')
    //     .child('thumbnail__9_16_mobile_socialMedia_100x100.png');
    // final videoThumbRef250x375 = videoStorageRef.parent!
    //     .child('thumbs')
    //     .child('thumbnail__9_16_mobile_socialMedia_250x375.png');
    // final videoThumbRef500x500 = videoStorageRef.parent!
    //     .child('thumbs')
    //     .child('thumbnail__9_16_mobile_socialMedia_500x500.png');

    // final urls = await Future.wait([
    //   videoStorageRef.getDownloadURL(),
    //   videoThumbRef.getDownloadURL(),
    //   videoThumbRef100x100.getDownloadURL(),
    //   videoThumbRef250x375.getDownloadURL(),
    //   videoThumbRef500x500.getDownloadURL(),
    // ]);

    // post.firebaseVideoUrl = urls[0];
    // post.photoUrls = [urls[1]];
    // post.thumbnailUrls100x100 = [urls[2]];
    // post.thumbnailUrls250x375 = [urls[3]];
    // post.thumbnailUrls500x500 = [urls[4]];

    final updatedPost = Post(
      postID: post.postID,
      postType: PostTypes.video.name,
      uid: currentUser.uid,
      authorName: currentUser.name,
      authorPhoto: currentUser.photoUrl,
      location: post.location,
      country: post.country,
      province: post.province,
      subProvince: post.subProvince,
      subSubProvince: post.subSubProvince,
      description: post.description,
      photoUrls: post.photoUrls,
      thumbnailUrls100x100: post.thumbnailUrls100x100,
      thumbnailUrls250x375: post.thumbnailUrls250x375,
      thumbnailUrls500x500: post.thumbnailUrls500x500,
      videoUrl: post.videoUrl,
      firebaseVideoUrl: post.videoUrl,
      channelName: post.channelName,
      token: post.token,
      numLikes: post.numLikes,
      numComments: post.numComments,
      numViews: post.numViews,
      isActive: post.isActive,
      category: post.category,
      privacy: post.privacy,
      tags: post.tags,
      lastLiveEvent: null,
      timestamp: post.timestamp,
    );

    return postRef.update(updatedPost.toFirestore());
  }

  Future<void> handleCreateVideoPost(
    context, {
    required Post post,
    required AppUser currentUser,
  }) async {
    FAC.logEvent(FAEvent.add_post);

    if (validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.show(status: RCCubit.instance.getText(R.uploadingPost), dismissOnTap: true);
        // // Check if the post has text violation
        // if (post.description?.isNotEmpty == true) {
        //   if (await Utils.handleHasTextViolation(text: post.description!)) {
        //     _isSubmitting = false;
        //     return;
        //   }
        // }
        _createVideoPost(
          post: post,
          currentUser: currentUser,
        ).then((value) {
          _isSubmitting = false;
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Get.back();
        }).onError((error, stackTrace) {
          debugPrint(stackTrace.toString());
          debugPrint(error.toString());

          _isSubmitting = false;
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
          if (error is LocationPermanentlyDeniedException) {
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDeniedPermanently),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
          if (error is LocationDeniedException) {
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDenied),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
          if (error is LocationDisabledException) {
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDisabled),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
        });
      } else {
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      }
    }
  }

  Future<void> handleUpdatePost(
    context, {
    required Post post,
    required AppUser currentUser,
  }) {
    FAC.logEvent(FAEvent.update_post);

    if (validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.show(status: RCCubit.instance.getText(R.updatingPost), dismissOnTap: true);
        return _updatePostInfo(
          post: post,
          currentUser: currentUser,
        ).then((value) {
          _isSubmitting = false;
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Get.back();
        }).onError((error, stackTrace) {
          _isSubmitting = false;
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
        });
      } else {
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      }
    }

    return Future.value();
  }

  Future<void> handleHidePost(
    context, {
    required String itemID,
  }) async {
    FAC.logEvent(FAEvent.hide_post);

    if (!_isSubmitting) {
      _isSubmitting = true;

      EasyLoading.show(dismissOnTap: true);
      return _hidePost(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadPost(postID: post.postID!, video: null));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _hidePost({required String itemID}) {
    final itemRef = FirebaseFirestore.instance.collection('posts').doc(itemID);

    return itemRef.update({"isActive": false});
  }

  Future<void> handleRestoreStorePost(
    context, {
    required String itemID,
  }) async {
    FAC.logEvent(FAEvent.restore_post);

    if (!_isSubmitting) {
      _isSubmitting = true;

      EasyLoading.show(dismissOnTap: true);
      return _restoreStorePost(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadPost(postID: post.postID!, video: null));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _restoreStorePost({required String itemID}) {
    final itemRef = FirebaseFirestore.instance.collection(postsCollection).doc(itemID);
    return itemRef.update({"isActive": true});
  }

  bool validate() {
    isKeyValid = formKey.currentState?.validate() == true;

    return formKey.currentState?.validate() == true;
  }
}
