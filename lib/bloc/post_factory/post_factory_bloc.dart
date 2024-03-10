import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/calls_module/data/api/live_api.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/screens/emitter_live_call_screen.dart';
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

class PostFactoryBloc extends Bloc<PostFactoryEvent, PostFactoryState> {
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
  late Post postFromBloc;
  final _liveApi = LiveApi();

  bool _isSubmitting = false;
  bool? isKeyValid;

  int currentImageIdx = 0;

  PostFactoryBloc({required this.currentUser}) : super(PostFactoryInitial()) {
    on<LoadPost>((event, emit) async {
      if (event.postID is String) {
        emit(LivePostFactoryLoading());
        final itemDoc = await getPost(postID: event.postID!);
        if (itemDoc.exists) {
          postFromBloc = itemDoc.data()!;
          emit(ExistingLivePost());
          return;
        }
      }

      postFromBloc = await getCachePost();
      if (event.images?.isNotEmpty == true) {
        emit(NewLivePost(images: event.images!));
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

  Future<Post> _startPublicLive({
    required Post post,
    required String token,
    required String channelName,
  }) async {
    final postRef = Post.ref.doc();
    List<String>? postPhotoUrls;

    try {
      final geopoint = await SettingsCubit.determinePosition(userID: currentUser.uid);

      post.location = GeoFlutterFire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
          .dataForThreeHundredKm;
    } catch (e) {}

    final photoUrls = await Utils.uploadPhotos(
      ref: Post.photoStorageRef(postID: postRef.id),
      files: post.photoUrls!,
    );

    postPhotoUrls = photoUrls.isNotEmpty ? photoUrls : null;

    final uploadPost = Post(
      postID: postRef.id,
      postType: PostTypes.live.name,
      uid: currentUser.uid,
      authorName: currentUser.name,
      authorPhoto: currentUser.photoUrl,
      numLikes: 0,
      numComments: 0,
      numViews: 0,
      photoUrls: postPhotoUrls,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      videoUrl: null,
      firebaseVideoUrl: null,
      channelName: channelName,
      token: token,
      location: null,
      country: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      isActive: true,
      description: post.description,
      category: post.category,
      privacy: post.privacy,
      tags: post.tags,
      timestamp: FieldValue.serverTimestamp(),
      lastLiveEvent: null,
    );

    await postRef.set(uploadPost);
    return uploadPost;
  }

  Future<void> _createPost({required Post post, required AppUser currentUser}) async {
    final postRef = Post.ref.doc();

    List<String>? postPhotoUrls;

    try {
      final geopoint = await SettingsCubit.determinePosition(userID: currentUser.uid);

      post.location = GeoFlutterFire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
          .dataForThreeHundredKm;
    } catch (e) {}

    final photoUrls = await Utils.uploadPhotos(
      ref: Post.photoStorageRef(postID: postRef.id),
      files: post.photoUrls!,
    );

    postPhotoUrls = photoUrls.isNotEmpty ? photoUrls : null;

    final uploadPost = Post(
      postID: postRef.id,
      postType: PostTypes.image.name,
      uid: currentUser.uid,
      authorName: currentUser.name,
      authorPhoto: currentUser.photoUrl,
      numLikes: 0,
      numComments: 0,
      numViews: 0,
      photoUrls: postPhotoUrls,
      thumbnailUrls100x100: post.thumbnailUrls100x100,
      thumbnailUrls250x375: post.thumbnailUrls250x375,
      thumbnailUrls500x500: post.thumbnailUrls500x500,
      videoUrl: post.videoUrl,
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

    List<String>? postPhotoUrls;

    final photoUrls = await Utils.uploadPhotos(
      ref: Post.photoStorageRef(postID: postRef.id),
      files: post.photoUrls!,
    );

    postPhotoUrls = photoUrls.isNotEmpty ? photoUrls : null;

    final updatedPost = Post(
      postID: post.postID,
      postType: PostTypes.image.name,
      uid: currentUser.uid,
      authorName: currentUser.name,
      authorPhoto: currentUser.photoUrl,
      location: post.location,
      country: post.country,
      province: post.province,
      subProvince: post.subProvince,
      subSubProvince: post.subSubProvince,
      description: post.description,
      photoUrls: postPhotoUrls,
      thumbnailUrls100x100: post.thumbnailUrls100x100,
      thumbnailUrls250x375: post.thumbnailUrls250x375,
      thumbnailUrls500x500: post.thumbnailUrls500x500,
      videoUrl: post.videoUrl,
      firebaseVideoUrl: post.firebaseVideoUrl,
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

  Future<void> handleCreatePost(
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
        _createPost(
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

  Future<void> handleStartLive({required Post post}) {
    FAC.logEvent(FAEvent.start_live);

    if (!validate()) {
      return Future.value();
    }

    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(status: RCCubit.instance.getText(R.startingLiveVideo), dismissOnTap: true);

      return CallHandlerCubit.retrievePermissions(
        onPermissionGranted: () async {
          //1-generate call token
          Map<String, dynamic> queryMap = {
            'channelName': 'channel_${UniqueKey().hashCode.toString()}',
            'uid': 0,
          };
          // int from string
          //

          return _liveApi.generateCallToken(queryMap: queryMap).then((value) {
            final token = value['data']['token'];
            final channelName = value['data']['channelId'];

            return _startPublicLive(
              post: post,
              token: token,
              channelName: channelName,
            ).then((uploadedPost) {
              _isSubmitting = false;
              EasyLoading.showSuccess(RCCubit.instance.getText(R.liveVideoStarted),
                  dismissOnTap: true);

              EmitterLiveScreen.show(post: uploadedPost);
            }).onError((error, stackTrace) {
              _isSubmitting = false;
              EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
            });
          }).catchError((onError) {
            debugPrint(onError);
            EasyLoading.showError('');
          });
        },
      );
    } else {
      EasyLoading.showInfo(
        RCCubit.instance.getText(R.liveIsAlreadyStarting),
        dismissOnTap: true,
      );
      return Future.value();
    }
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
        add(LoadPost(postID: postFromBloc.postID!, images: null));
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
        add(LoadPost(postID: postFromBloc.postID!, images: null));
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
