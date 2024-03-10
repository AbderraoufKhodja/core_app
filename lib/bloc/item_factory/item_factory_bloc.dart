import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'bloc.dart';

class ItemFactoryBloc extends Bloc<ItemFactoryEvent, ItemFactoryState> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormBuilderState>();

  final Store store;
  late Reference itemsStorageRef;
  late Item item;

  bool _isSubmitting = false;

  ReturnPolicy returnPolicy = ReturnPolicy.empty();

  bool? isKeyValid1;
  bool? isKeyValid2;
  bool? isKeyValid3;
  bool? isKeyValid4;
  bool? isKeyValid5;
  bool? isKeyValid6;

  ItemFactoryBloc({required this.store}) : super(ItemFactoryInitial()) {
    itemsStorageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(store.storeOwnerID!)
        .child('store')
        .child('items');

    on<LoadItem>((event, emit) async {
      emit(ItemFactoryLoading());
      if (event.itemID is String) {
        final itemDoc = await getItem(itemID: event.itemID!);
        item = itemDoc.data()!;
        emit(ExistingItem());
      } else {
        item = await getCacheItem();
        emit(NewItem());
      }
    });
  }

  Future<DocumentSnapshot<Item>> getItem({required String itemID}) {
    final itemDoc = Item.ref.doc(itemID).get();
    return itemDoc;
  }

  Future<Item> getCacheItem() async {
    final prefs = await SharedPreferences.getInstance();

    return Item.fromPreferences(prefs: prefs);
  }

  Future<void> handleRemoveStoreItem({required String itemID}) {
    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _removeStoreItem(itemID: itemID).then((value) {
        debugPrint('Item removed');
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        Get.back();
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value();
    }
  }

  Future<void> _removeStoreItem({required String itemID}) async {
    // TODO: Check later in should delete the items media too
    final itemRef = Item.ref.doc(itemID);
    return itemRef.delete();
  }

  Future<void> _uploadNewItem({required Item item}) async {
    final currentUser = BlocProvider.of<AuthBloc>(Get.context!).currentUser!;
    final itemRef = Item.ref.doc();
    final videoStorageRef = Item.videoStorageRef(itemID: itemRef.id);

    List<String>? itemPhotoUrls;
    List<String>? sourcePhotoUrls;
    List<String>? descriptionPhotos;

    final photoUrls = await Future.wait([
      Future.wait<String>(
        item.photoUrls != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('itemPhotos'),
                photos: item.photoUrls!)
            : [],
      ),
      Future.wait<String>(
        item.sourcePhotos != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('sourcePhotos'),
                photos: item.sourcePhotos!)
            : [],
      ),
      Future.wait<String>(
        item.additionalPhotos != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('descriptionPhotos'),
                photos: item.additionalPhotos!)
            : [],
      ),
      Future.wait<String>(item.variants?.entries.map(
            (variant) async {
              if (variant.value['photo'] is XFile) {
                final photo = variant.value['photo'] as XFile;
                final variantID = const Uuid().v4();
                final variantsRef =
                    itemsStorageRef.child(itemRef.id).child('variantPhotos').child(variantID);

                if (kIsWeb) {
                  final photoBytes = await photo.readAsBytes();
                  return variantsRef.putData(photoBytes).then(
                        (value) => variantsRef.getDownloadURL().then(
                              (url) => item.variants!.update(
                                variant.key,
                                (val) {
                                  val['photo'] = url;
                                  return val;
                                },
                              ),
                            ),
                      );
                } else {
                  return variantsRef.putFile(File(variant.value['photo'].path)).then(
                        (value) => variantsRef.getDownloadURL().then(
                              (url) => item.variants!.update(
                                variant.key,
                                (val) {
                                  val['photo'] = url;
                                  return val;
                                },
                              ),
                            ),
                      );
                }
              }
              return variant.value['photo'].toString();
            },
          ) ??
          [])
    ]);

    itemPhotoUrls = photoUrls[0].isNotEmpty ? photoUrls[0] : null;
    sourcePhotoUrls = photoUrls[1].isNotEmpty ? photoUrls[1] : null;
    descriptionPhotos = photoUrls[2].isNotEmpty ? photoUrls[2] : null;

    Map<String, dynamic>? location;

    try {
      final geopoint = await SettingsCubit.determinePosition(userID: null);

      location = GeoFlutterFire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
          .dataForThreeHundredKm;
    } catch (e) {
      debugPrint('Error getting location: $e');
    }

    if (item.videoUrl is File) {
      await Utils.uploadPostVideo(
        postID: itemRef.id,
        postPath: itemRef.path,
        uid: currentUser.uid,
        videoID: videoStorageRef.name,
        ref: videoStorageRef,
        file: item.videoUrl,
      );
    }

    final newItem = Item(
      itemID: itemRef.id,
      numViews: 0,
      avgRating: 0,
      numRatings: 0,
      numLikes: 0,
      numOrders: 0,
      numReceptions: 0,
      numRefunds: 0,
      numReviews: 0,
      numConfirmations: 0,
      numPackagesSent: 0,
      numReminders: 0,
      numFavorites: 0,
      videoUrl: null,
      firebaseVideoUrl: item.firebaseVideoUrl,
      photoUrls: itemPhotoUrls,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      additionalPhotos: descriptionPhotos,
      additionalInfo: item.additionalInfo,
      brand: item.brand,
      madeIn: item.madeIn,
      sourcePhotos: sourcePhotoUrls,
      itemPhotoUrl: itemPhotoUrls!.first,
      storeID: store.storeID,
      storeName: store.name,
      storePhoneNumber: store.phoneNumber,
      country: store.country,
      province: store.province,
      storeLogo: store.logo,
      subProvince: store.subProvince,
      subSubProvince: store.subSubProvince,
      streetAddress: store.streetAddress,
      currency: store.currency,
      storeOwnerID: store.storeOwnerID,
      isActive: true,
      teamChoice: false,
      location: location,
      description: item.description,
      title: item.title,
      attributes: item.attributes,
      price: item.price,
      salePrice: item.salePrice,
      category1: item.category1,
      category2: item.category2,
      category3: item.category3,
      category4: item.category4,
      category5: item.category5,
      category6: item.category6,
      source: item.source,
      variants: item.variants,
      returnPolicy: item.returnPolicy,
      frequentlyAQ: item.frequentlyAQ,
      keywords: item.keywords,
      timestamp: FieldValue.serverTimestamp(),
    );

    return itemRef.set(newItem);
  }

  Future<void> _updateItemInfo({required Item item, required Store store}) async {
    final itemRef = Item.ref.doc(item.itemID);
    final currentUser = BlocProvider.of<AuthBloc>(Get.context!).currentUser!;
    final videoStorageRef = Item.videoStorageRef(itemID: itemRef.id);

    List<String>? itemPhotoUrls;
    List<String>? sourcePhotoUrls;
    List<String>? descriptionPhotos;

    final photoUrls = await Future.wait([
      Future.wait<String>(
        item.photoUrls != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('itemPhotos'),
                photos: item.photoUrls!)
            : [],
      ),
      Future.wait<String>(
        item.sourcePhotos != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('sourcePhotos'),
                photos: item.sourcePhotos!)
            : [],
      ),
      Future.wait<String>(
        item.additionalPhotos != null
            ? _uploadingPhotos(
                photosRef: itemsStorageRef.child(itemRef.id).child('descriptionPhotos'),
                photos: item.additionalPhotos!)
            : [],
      ),
      Future.wait<String>(item.variants?.entries.map(
            (variant) async {
              if (variant.value['photo'] is XFile) {
                final photo = variant.value['photo'] as XFile;
                final variantID = const Uuid().v4();
                final variantsRef =
                    itemsStorageRef.child(itemRef.id).child('variantPhotos').child(variantID);

                if (kIsWeb) {
                  final photoBytes = await photo.readAsBytes();
                  return variantsRef.putData(photoBytes).then(
                        (value) => variantsRef.getDownloadURL().then(
                              (url) => item.variants!.update(
                                variant.key,
                                (val) {
                                  val['photo'] = url;
                                  return val;
                                },
                              ),
                            ),
                      );
                } else {
                  return variantsRef.putFile(File(variant.value['photo'].path)).then(
                        (value) => variantsRef.getDownloadURL().then(
                              (url) => item.variants!.update(
                                variant.key,
                                (val) {
                                  val['photo'] = url;
                                  return val;
                                },
                              ),
                            ),
                      );
                }
              }
              return variant.value['photo'].toString();
            },
          ) ??
          []),
    ]);

    itemPhotoUrls = photoUrls[0].isNotEmpty ? photoUrls[0] : null;
    sourcePhotoUrls = photoUrls[1].isNotEmpty ? photoUrls[1] : null;
    descriptionPhotos = photoUrls[2].isNotEmpty ? photoUrls[2] : null;

    if (item.videoUrl is File) {
      await Utils.uploadPostVideo(
        postID: itemRef.id,
        postPath: itemRef.path,
        uid: currentUser.uid,
        videoID: videoStorageRef.name,
        ref: videoStorageRef,
        file: item.videoUrl,
      );
    }

    final updatedItem = Item(
      firebaseVideoUrl: item.firebaseVideoUrl,
      videoUrl: item.videoUrl,
      photoUrls: itemPhotoUrls,
      thumbnailUrls100x100: item.thumbnailUrls100x100,
      thumbnailUrls250x375: item.thumbnailUrls250x375,
      thumbnailUrls500x500: item.thumbnailUrls500x500,
      itemPhotoUrl: itemPhotoUrls!.first,
      sourcePhotos: sourcePhotoUrls,
      additionalPhotos: descriptionPhotos,
      additionalInfo: item.additionalInfo,
      brand: item.brand,
      madeIn: item.madeIn,
      variants: item.variants,
      returnPolicy: item.returnPolicy,
      storeOwnerID: store.storeOwnerID,
      storeName: store.name,
      storePhoneNumber: store.phoneNumber,
      storeLogo: store.logo,
      country: store.country,
      currency: store.currency,
      province: store.province,
      subProvince: store.subProvince,
      subSubProvince: store.subSubProvince,
      streetAddress: store.streetAddress,
      storeID: store.storeID,
      description: item.description,
      itemID: item.itemID,
      numViews: item.numViews,
      avgRating: item.avgRating,
      numRatings: item.numRatings,
      numLikes: item.numLikes,
      numOrders: item.numOrders,
      numReceptions: item.numReceptions,
      numRefunds: item.numRefunds,
      numReviews: item.numReviews,
      numConfirmations: item.numConfirmations,
      numPackagesSent: item.numPackagesSent,
      numReminders: item.numReminders,
      numFavorites: item.numFavorites,
      isActive: item.isActive,
      teamChoice: item.teamChoice,
      location: item.location,
      title: item.title,
      attributes: item.attributes,
      price: item.price,
      salePrice: item.salePrice,
      category1: item.category1,
      category2: item.category2,
      category3: item.category3,
      category4: item.category4,
      category5: item.category5,
      category6: item.category6,
      source: item.source,
      keywords: item.keywords,
      frequentlyAQ: item.frequentlyAQ,
      timestamp: item.timestamp,
    );

    return itemRef.update(updatedItem.toFirestore());
  }

  Iterable<Future<String>> _uploadingPhotos({
    required Reference photosRef,
    required List<dynamic> photos,
  }) {
    num count = 0;
    return photos.map(
      (photo) {
        if (photo is XFile) {
          count += 1;
          final photoFile = photo;
          final thisPhotoRef = photosRef.child(count.toString());

          if (kIsWeb) {
            return photoFile.readAsBytes().then(
                  (photoBytes) =>
                      thisPhotoRef.putData(photoBytes).then((_) => thisPhotoRef.getDownloadURL()),
                );
          } else {
            return thisPhotoRef
                .putFile(File(photoFile.path))
                .then((_) => thisPhotoRef.getDownloadURL());
          }
        }
        return Future.value(photo.toString());
      },
    );
  }

  Future<void> handleUploadNewItem(
    context, {
    required Item item,
    required Store store,
  }) async {
    if (validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.dismiss(animation: true);
        EasyLoading.show(status: RCCubit.instance.getText(R.uploadingItem), dismissOnTap: true);
        _uploadNewItem(
          item: item,
        ).then((value) {
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Get.back();
        }).onError((error, stackTrace) {
          print(stackTrace);
          print(error);
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
        });
      } else {
        EasyLoading.dismiss(animation: true);
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      }
    }
  }

  Future<void> handleUpdateExistingItem(
    context, {
    required Item item,
    required Store store,
  }) {
    if (validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.dismiss(animation: true);
        EasyLoading.show(status: RCCubit.instance.getText(R.updatingItem), dismissOnTap: true);
        return _updateItemInfo(
          item: item,
          store: store,
        ).then((value) {
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Get.back();
        }).onError((error, stackTrace) {
          print(stackTrace);
          print(error);
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
        });
      } else {
        EasyLoading.dismiss(animation: true);
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      }
    }

    return Future.value();
  }

  Future<void> handleHideStoreItem({required String itemID}) async {
    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _hideStoreItem(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadItem(itemID: item.itemID!));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _hideStoreItem({required String itemID}) {
    final itemRef = Item.ref.doc(itemID);

    return itemRef.update({"isActive": false});
  }

  Future<void> handleRestoreStoreItem({required String itemID}) async {
    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _restoreStoreItem(itemID: itemID).then((value) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        add(LoadItem(itemID: item.itemID!));
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _restoreStoreItem({required String itemID}) {
    final itemRef = Item.ref.doc(itemID);
    return itemRef.update({ItemLabels.isActive.name: true});
  }

  bool validate() {
    isKeyValid1 = formKey1.currentState?.validate() == true;
    isKeyValid2 = formKey2.currentState?.validate() == true;
    isKeyValid3 = formKey3.currentState?.validate() == true;
    isKeyValid4 = formKey4.currentState?.validate() == true;
    isKeyValid5 = formKey5.currentState?.validate() == true;
    isKeyValid6 = formKey6.currentState?.validate() == true;

    return formKey1.currentState?.validate() == true &&
        formKey2.currentState?.validate() == true &&
        formKey3.currentState?.validate() == true &&
        formKey4.currentState?.validate() == true &&
        formKey5.currentState?.validate() == true &&
        formKey6.currentState?.validate() == true;
  }
}
