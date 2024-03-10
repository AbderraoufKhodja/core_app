import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/algeria_location.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc.dart';

class SwapFactoryBloc extends Bloc<SwapFactoryEvent, SwapFactoryState> {
  final formKey = GlobalKey<FormState>();
  final pageController = PageController();

  final swapCategories = [
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
  String? province;
  String? subProvince;
  String? subSubProvince;

  final AppUser currentUser;
  late SwapItem swapItem;

  bool _isSubmitting = false;

  bool? isKeyValid;

  int currentImageIdx = 0;

  SwapFactoryBloc({required this.currentUser}) : super(SwapFactoryInitial()) {
    on<LoadSwap>((event, emit) async {
      if (event.itemID is String) {
        emit(SwapFactoryLoading());
        final itemDoc = await getSwap(itemID: event.itemID!);
        swapItem = itemDoc.data()!;
        emit(ExistingSwap());
        return;
      }

      swapItem = await getCacheSwap();
      if (event.images?.isNotEmpty == true) {
        emit(NewSwap(images: event.images!));
      }
    });
  }

  Future<DocumentSnapshot<SwapItem>> getSwap({required String itemID}) {
    final itemDoc = SwapItem.ref.doc(itemID).get();
    return itemDoc;
  }

  Future<SwapItem> getCacheSwap() async {
    final prefs = await SharedPreferences.getInstance();

    return SwapItem.fromPreferences(prefs: prefs);
  }

  Future<void> _createSwapItem({required SwapItem swap}) async {
    final swapRef = SwapItem.ref.doc();

    final geopoint = await SettingsCubit.determinePosition(userID: currentUser.uid);

    swap.location = GeoFlutterFire()
        .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
        .dataForThreeHundredKm;

    List<String>? swapPhotoUrls;
    if (swap.photoUrls?.isNotEmpty == true) {
      swapPhotoUrls = await Utils.uploadPhotos(
        ref: SwapItem.itemsStorageRef(userID: currentUser.uid, itemID: swapRef.id),
        files: swap.photoUrls!,
      );
    }

    final uploadSwap = SwapItem(
      itemID: swapRef.id,
      uid: currentUser.uid,
      numLikes: 0,
      photoUrls: swapPhotoUrls,
      country: swap.country,
      province: swap.province,
      subProvince: swap.subProvince,
      subSubProvince: swap.subSubProvince,
      isActive: true,
      description: swap.description,
      tags: swap.tags,
      ownerName: currentUser.name,
      ownerPhoto: swap.ownerPhoto,
      title: swap.title,
      location: swap.location,
      currency: swap.currency,
      price: swap.price,
      numRatings: swap.numRatings,
      numReceptions: swap.numReceptions,
      numFavorites: swap.numFavorites,
      numComments: swap.numComments,
      numViews: swap.numViews,
      additionalInfo: swap.additionalInfo,
      brand: swap.brand,
      madeIn: swap.madeIn,
      category1: swap.category1,
      category2: swap.category2,
      category3: swap.category3,
      category4: swap.category4,
      category5: swap.category5,
      category6: swap.category6,
      streetAddress: swap.streetAddress,
      isSwapped: false,
      isSoldOut: false,
      isForSale: swap.isForSale,
      isForSwap: swap.isForSwap,
      timestamp: FieldValue.serverTimestamp(),
    );

    return swapRef.set(uploadSwap);
  }

  Future<void> _updateSwapInfo({required SwapItem swap, required AppUser currentUser}) async {
    final swapRef = SwapItem.ref.doc(swap.itemID);

    final geopoint = await SettingsCubit.determinePosition(userID: currentUser.uid);

    swap.location = GeoFlutterFire()
        .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
        .dataForThreeHundredKm;

    List<String>? swapPhotoUrls;
    if (swap.photoUrls?.isNotEmpty == true) {
      swapPhotoUrls = await Utils.uploadPhotos(
        ref: SwapItem.itemsStorageRef(userID: currentUser.uid, itemID: swapRef.id),
        files: swap.photoUrls!,
      );
    }

    final updatedSwap = SwapItem(
      itemID: swap.itemID,
      uid: currentUser.uid,
      ownerName: currentUser.name,
      country: swap.country,
      province: swap.province,
      subProvince: swap.subProvince,
      subSubProvince: swap.subSubProvince,
      description: swap.description,
      photoUrls: swapPhotoUrls,
      numLikes: swap.numLikes,
      isActive: swap.isActive,
      tags: swap.tags,
      timestamp: swap.timestamp,
      ownerPhoto: swap.ownerPhoto,
      title: swap.title,
      location: swap.location,
      currency: swap.currency,
      price: swap.price,
      numRatings: swap.numRatings,
      numReceptions: swap.numReceptions,
      numFavorites: swap.numFavorites,
      numComments: swap.numComments,
      numViews: swap.numViews,
      additionalInfo: swap.additionalInfo,
      brand: swap.brand,
      madeIn: swap.madeIn,
      category1: swap.category1,
      category2: swap.category2,
      category3: swap.category3,
      category4: swap.category4,
      category5: swap.category5,
      category6: swap.category6,
      streetAddress: swap.streetAddress,
      isSoldOut: swap.isSoldOut,
      isSwapped: swap.isSwapped,
      isForSale: swap.isForSale,
      isForSwap: swap.isForSwap,
    );

    return swapRef.update(updatedSwap.toFirestore());
  }

  Future<void> handleCreateSwapItem(
    context, {
    required SwapItem swap,
    required AppUser currentUser,
  }) async {
    FAC.logEvent(FAEvent.upload_new_swap_item_button_pressed);

    if (validate()) {
      FAC.logEvent(FAEvent.upload_new_swap_item_form_validated);
      if (!_isSubmitting) {
        EasyLoading.show(status: RCCubit.instance.getText(R.uploadingSwap), dismissOnTap: true);
        _createSwapItem(
          swap: swap,
        ).then((value) {
          _isSubmitting = false;
          FAC.logEvent(FAEvent.upload_new_swap_item_successfully_uploaded);
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Get.back();
        }).onError((error, stackTrace) {
          debugPrint(stackTrace.toString());
          debugPrint(error.toString());
          _isSubmitting = false;
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
          if (error is LocationPermanentlyDeniedException) {
            FAC.logEvent(FAEvent.upload_new_swap_item_error_location_permanently_denied);
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDeniedPermanently),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
          if (error is LocationDeniedException) {
            FAC.logEvent(FAEvent.upload_new_swap_item_error_location_denied);
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDenied),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
          if (error is LocationDisabledException) {
            FAC.logEvent(FAEvent.upload_new_swap_item_error_location_disabled);
            Get.showSnackbar(
              GetSnackBar(
                title: RCCubit.instance.getText(R.locationDisabled),
                message: RCCubit.instance.getText(R.pleaseEnableLocation),
              ),
            );
          }
        });
      } else {
        FAC.logEvent(FAEvent.upload_new_swap_item_form_already_submitting);
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      }
    }
    FAC.logEvent(FAEvent.upload_new_swap_item_form_invalidated);
  }

  Future<void> handleUpdateSwap(
    context, {
    required SwapItem swap,
    required AppUser currentUser,
  }) {
    FAC.logEvent(FAEvent.update_swap_item);

    if (validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.show(status: RCCubit.instance.getText(R.updatingSwap), dismissOnTap: true);
        return _updateSwapInfo(
          swap: swap,
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

  Future<void> handleHideSwap(
    context, {
    required String itemID,
  }) async {
    FAC.logEvent(FAEvent.hide_swap_item);

    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _hideSwap(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadSwap(itemID: swapItem.itemID!, images: null));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _hideSwap({required String itemID}) {
    final itemRef = SwapItem.ref.doc(itemID);

    return itemRef.update({SILabels.isActive.name: false});
  }

  Future<void> handleRestoreStoreSwap(
    context, {
    required String itemID,
  }) async {
    FAC.logEvent(FAEvent.restore_swap_item);

    if (!_isSubmitting) {
      _isSubmitting = true;

      EasyLoading.show(dismissOnTap: true);
      return _restoreStoreSwap(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadSwap(itemID: swapItem.itemID!, images: null));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _restoreStoreSwap({required String itemID}) {
    final itemRef = SwapItem.ref.doc(itemID);
    return itemRef.update({SILabels.isActive.name: true});
  }

  bool validate() {
    isKeyValid = formKey.currentState?.validate() == true;

    return formKey.currentState?.validate() == true;
  }

  static Future<void> handleDeleteSwapItem({required SwapItem swapItem}) async {
    FAC.logEvent(FAEvent.remove_swap_item);

    EasyLoading.show(status: RCCubit.instance.getText(R.deletingSwap), dismissOnTap: true);
    final itemRef = SwapItem.ref.doc(swapItem.itemID);

    itemRef.delete().then((value) {
      EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
      Get.back();
    }).onError((error, stackTrace) {
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }
}
