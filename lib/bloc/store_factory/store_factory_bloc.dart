import 'dart:async';
import 'dart:io';

import 'package:fibali/algeria_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

import 'bloc.dart';

class StoreFactoryBloc extends Bloc<StoreFactoryEvent, StoreFactoryState> {
  final _db = FirebaseFirestore.instance;
  final _dbs = FirebaseStorage.instance;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  bool? isKeyValid1;
  bool? isKeyValid2;
  bool? isKeyValid3;

  bool _isSubmitting = false;
  bool editEnabled = false;
  XFile? logoFile;
  XFile? backgroundFile;
  List<String> keywords = [];
  List<String> currencies = ['DZD'];

  List<String> countries = [
    CountriesIso.DZ.name,
    CountriesIso.CN.name,
    CountriesIso.TN.name,
    CountriesIso.EG.name,
    CountriesIso.MA.name
  ];

  List<String> provinces = AlgeriaCities.getProvinces();
  List<String> subProvinces = [];
  List<String> subSubProvinces = [];

  String? currency;
  String? country;
  String? province;
  String? subProvince;
  String? subSubProvince;
  String? streetAddress;
  String? phoneNumber;
  String? dialCode;
  String? description;
  String? storeName;
  String? authorFirstName;
  String? authorLastName;

  StoreFactoryBloc() : super(StoreFactoryInitial()) {
    on<LoadUserStores>((event, emit) {
      emit(LoadingStoreFactory());

      final userItems = getUserStores(userID: event.userID);

      emit(StoreFactoryLoaded(userStores: userItems));
    });
  }

  Stream<QuerySnapshot<Store>> getUserStores({required String userID}) {
    return BehaviorSubject()
      ..addStream(Store.ref.where(StoreLabels.storeOwnerID.name, isEqualTo: userID).snapshots());
  }

  Future<void> handleOpenStore(
    context, {
    required String storeOwnerID,
    required String description,
    required String storeName,
    required String authorFirstName,
    required String authorLastName,
    required String dialCode,
    required String phoneNumber,
    required XFile logoFile,
    required XFile backgroundFile,
    required String country,
    required String currency,
    required String? province,
    required String? subProvince,
    required String? subSubProvince,
    required String streetAddress,
    required List<String>? keywords,
  }) async {
    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(status: RCCubit.instance.getText(R.openingStore), dismissOnTap: true);
      _openStore(
        storeOwnerID: storeOwnerID,
        description: description,
        storeName: storeName,
        authorFirstName: authorFirstName,
        authorLastName: authorLastName,
        phoneNumber: phoneNumber,
        dialCode: dialCode,
        logoFile: logoFile,
        backgroundFile: backgroundFile,
        currency: currency,
        country: country,
        province: province,
        subProvince: subProvince,
        subSubProvince: subSubProvince,
        streetAddress: streetAddress,
        keywords: keywords,
      ).then((value) {
        _isSubmitting = false;
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _openStore({
    required String storeOwnerID,
    required String description,
    required String storeName,
    required String authorFirstName,
    required String authorLastName,
    required String dialCode,
    required String phoneNumber,
    required XFile logoFile,
    required XFile backgroundFile,
    required String country,
    required String currency,
    required String? province,
    required String? subProvince,
    required String? subSubProvince,
    required String streetAddress,
    required List<String>? keywords,
  }) async {
    final batch = _db.batch();

    final storeRef = Store.ref.doc(storeOwnerID);

    final logoRef = _dbs
        .ref()
        .child('users')
        .child(storeOwnerID)
        .child('stores')
        .child(storeRef.id)
        .child('logo');

    final backgroundRef = _dbs
        .ref()
        .child('users')
        .child(storeOwnerID)
        .child('stores')
        .child(storeRef.id)
        .child('background');

    if (kIsWeb) {
      await Future.wait([
        logoRef.putData(await logoFile.readAsBytes()),
        backgroundRef.putData(await backgroundFile.readAsBytes()),
      ]);
    } else {
      await Future.wait([
        logoRef.putFile(File(logoFile.path)),
        backgroundRef.putFile(File(backgroundFile.path)),
      ]);
    }

    final values = await Future.wait([
      logoRef.getDownloadURL(),
      backgroundRef.getDownloadURL(),
    ]);

    final store = Store(
      storeOwnerID: storeOwnerID,
      storeID: storeRef.id,
      description: description,
      name: storeName,
      authorFirstName: authorFirstName,
      authorLastName: authorLastName,
      phoneNumber: phoneNumber,
      status: 'firstSubmission',
      numViews: 0,
      numFavorites: 0,
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
      dialCode: dialCode,
      stats: null,
      logo: values[0],
      categories: null,
      background: values[1],
      currency: currency,
      country: country,
      province: province,
      subProvince: subProvince,
      subSubProvince: subSubProvince,
      streetAddress: streetAddress,
      keywords: keywords,
      timestamp: FieldValue.serverTimestamp(),
    );

    batch
      ..set<Store>(storeRef, store)
      ..update(_db.collection(usersCollection).doc(storeOwnerID),
          {AULabels.businessType.name: BusinessTypes.retailer.name});

    return batch.commit();
  }

  Future<void> handleUpdateStore(
    context, {
    required Store previousStore,
    required String storeOwnerID,
    required String description,
    required String storeName,
    required String authorFirstName,
    required String authorLastName,
    required String phoneNumber,
    required String dialCode,
    required XFile? logoFile,
    required XFile? backgroundFile,
    required String currency,
    required String country,
    required String province,
    required String subProvince,
    required String? subSubProvince,
    required String streetAddress,
    required List<String>? keywords,
  }) async {
    if (!_isSubmitting) {
      _isSubmitting = true;
      EasyLoading.show(status: RCCubit.instance.getText(R.updatingStoreInfo), dismissOnTap: true);
      _updateStore(
        previousStore: previousStore,
        storeOwnerID: storeOwnerID,
        description: description,
        storeName: storeName,
        authorFirstName: authorFirstName,
        authorLastName: authorLastName,
        phoneNumber: phoneNumber,
        dialCode: dialCode,
        logoFile: logoFile,
        backgroundFile: backgroundFile,
        currency: currency,
        country: country,
        province: province,
        subProvince: subProvince,
        subSubProvince: subSubProvince,
        streetAddress: streetAddress,
        keywords: keywords,
      ).then((value) {
        _isSubmitting = false;
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
        Future.delayed(const Duration(seconds: 2)).then((value) => Get.back());
      }).onError((error, stackTrace) {
        _isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }

  Future<void> _updateStore({
    required Store previousStore,
    required String storeOwnerID,
    required String description,
    required String storeName,
    required String authorFirstName,
    required String authorLastName,
    required String phoneNumber,
    required String dialCode,
    required XFile? logoFile,
    required XFile? backgroundFile,
    required String currency,
    required String country,
    required String province,
    required String subProvince,
    required String? subSubProvince,
    required String streetAddress,
    required List<String>? keywords,
  }) async {
    final batch = _db.batch();

    final storeRef = Store.ref.doc(previousStore.storeID);

    final updatedStore = Store(
      storeOwnerID: storeOwnerID,
      storeID: previousStore.storeID,
      description: description,
      name: storeName,
      authorFirstName: authorFirstName,
      authorLastName: authorLastName,
      phoneNumber: phoneNumber,
      dialCode: dialCode,
      status: previousStore.status,
      numViews: previousStore.numViews,
      numFavorites: previousStore.numFavorites,
      avgRating: previousStore.avgRating,
      numRatings: previousStore.numRatings,
      numReviews: previousStore.numReviews,
      numLikes: previousStore.numLikes,
      numRefunds: previousStore.numRefunds,
      numReceptions: previousStore.numReceptions,
      numOrders: previousStore.numOrders,
      numPackagesSent: previousStore.numPackagesSent,
      numConfirmations: previousStore.numConfirmations,
      numReminders: previousStore.numReminders,
      stats: previousStore.stats,
      logo: previousStore.logo,
      background: previousStore.background,
      categories: previousStore.categories,
      keywords: keywords,
      currency: currency,
      country: country,
      province: province,
      subProvince: subProvince,
      subSubProvince: subSubProvince,
      streetAddress: streetAddress,
      timestamp: previousStore.timestamp,
    );

    await _uploadImages(
      backgroundFile: backgroundFile,
      logoFile: logoFile,
      updatedStore: updatedStore,
      storeOwnerID: updatedStore.storeOwnerID!,
      storeID: updatedStore.storeID!,
    );

    batch
      ..update(storeRef, updatedStore.toFirestore())
      ..update(_db.collection(usersCollection).doc(storeOwnerID),
          {AULabels.businessType.name: BusinessTypes.translator.name});

    return batch.commit();
  }

  Future<void> _uploadImages({
    required XFile? backgroundFile,
    required XFile? logoFile,
    required Store updatedStore,
    required String storeOwnerID,
    required String storeID,
  }) async {
    final logoRef = _dbs.ref().child('users').child(storeOwnerID).child('store').child('logo');

    final backgroundRef =
        _dbs.ref().child('users').child(storeOwnerID).child('store').child('background');

    if (backgroundFile != null && logoFile == null) {
      if (kIsWeb) {
        await backgroundRef.putData(await backgroundFile.readAsBytes());
      } else {
        await backgroundRef.putFile(File(backgroundFile.path));
      }

      final backgroundUrl = await backgroundRef.getDownloadURL();
      updatedStore.background = backgroundUrl;
    } else if (logoFile != null && backgroundFile == null) {
      if (kIsWeb) {
        await logoRef.putData(await logoFile.readAsBytes());
      } else {
        await logoRef.putFile(File(logoFile.path));
      }

      final logoUrl = await logoRef.getDownloadURL();
      updatedStore.logo = logoUrl;
    } else if (logoFile != null && backgroundFile != null) {
      if (kIsWeb) {
        await Future.wait([
          logoRef.putData(await logoFile.readAsBytes()),
          backgroundRef.putData(await backgroundFile.readAsBytes()),
        ]);
      } else {
        await Future.wait([
          logoRef.putFile(File(logoFile.path)),
          backgroundRef.putFile(File(backgroundFile.path)),
        ]);
      }

      final values = await Future.wait([
        logoRef.getDownloadURL(),
        backgroundRef.getDownloadURL(),
      ]);

      updatedStore.logo = values[0];
      updatedStore.background = values[1];
    }
  }

  bool validate() {
    isKeyValid1 = formKey1.currentState?.validate() == true;
    isKeyValid2 = formKey2.currentState?.validate() == true;
    isKeyValid3 = formKey3.currentState?.validate() == true;

    return formKey1.currentState?.validate() == true &&
        formKey2.currentState?.validate() == true &&
        formKey3.currentState?.validate() == true;
  }
}
