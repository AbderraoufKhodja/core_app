import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:uuid/uuid.dart';

class Item {
  String? itemID;
  String? storeOwnerID;
  String? storeID;
  String? storeName;
  String? storePhoneNumber;
  String? itemPhotoUrl;
  String? storeLogo;
  dynamic videoUrl;
  dynamic firebaseVideoUrl;
  List<dynamic>? photoUrls;
  List<dynamic>? thumbnailUrls100x100;
  List<dynamic>? thumbnailUrls250x375;
  List<dynamic>? thumbnailUrls500x500;
  List<dynamic>? additionalPhotos;
  String? description;
  String? title;
  Map<String, dynamic>? attributes;
  String? currency;
  num? price;
  num? salePrice;
  final num? avgRating;
  final num? numLikes;
  final num? numViews;
  final num? numRatings;
  final num? numReviews;
  final num? numRefunds;
  final num? numReceptions;
  final num? numOrders;
  final num? numConfirmations;
  final num? numFavorites;
  final num? numPackagesSent;
  final num? numReminders;
  String? additionalInfo;
  String? brand;
  String? madeIn;
  String? category1;
  String? category2;
  String? category3;
  String? category4;
  String? category5;
  String? category6;
  String? country;
  String? province;
  String? subProvince;
  String? subSubProvince;
  String? streetAddress;
  Map<String, dynamic>? source;
  Map<String, dynamic>? variants;
  ReturnPolicy? returnPolicy;
  Map<String, dynamic>? location;
  Map<String, dynamic>? frequentlyAQ;
  List<dynamic>? keywords;
  List<dynamic>? sourcePhotos;
  bool? isActive;
  bool? teamChoice;
  dynamic timestamp;

  Item({
    required this.storeOwnerID,
    required this.storeID,
    required this.itemID,
    required this.storeName,
    required this.storePhoneNumber,
    required this.itemPhotoUrl,
    required this.storeLogo,
    required this.videoUrl,
    required this.firebaseVideoUrl,
    required this.description,
    required this.title,
    required this.attributes,
    required this.currency,
    required this.price,
    required this.salePrice,
    required this.numLikes,
    required this.numViews,
    required this.avgRating,
    required this.numRatings,
    required this.numReviews,
    required this.numRefunds,
    required this.numReceptions,
    required this.numOrders,
    required this.numConfirmations,
    required this.numFavorites,
    required this.numPackagesSent,
    required this.numReminders,
    required this.additionalInfo,
    required this.brand,
    required this.madeIn,
    required this.category1,
    required this.category2,
    required this.category3,
    required this.category4,
    required this.category5,
    required this.category6,
    required this.country,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.streetAddress,
    required this.source,
    required this.variants,
    required this.returnPolicy,
    required this.location,
    required this.frequentlyAQ,
    required this.keywords,
    required this.sourcePhotos,
    required this.photoUrls,
    required this.thumbnailUrls100x100,
    required this.thumbnailUrls250x375,
    required this.thumbnailUrls500x500,
    required this.additionalPhotos,
    required this.isActive,
    required this.teamChoice,
    required this.timestamp,
  });

  static CollectionReference<Item> get ref =>
      FirebaseFirestore.instance.collection(itemsCollection).withConverter<Item>(
          fromFirestore: (snapshot, options) => Item.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  static Reference videoStorageRef({required String itemID}) {
    final videoID = const Uuid().v4();
    return FirebaseStorage.instance
        .ref()
        .child(itemsCollection)
        .child(itemID)
        .child('itemVideo')
        .child('$videoID.mp4');
  }

  factory Item.fromFirestore(Map<String, dynamic> doc) {
    return Item(
      storeOwnerID: getField(doc, ItemLabels.storeOwnerID.name, String),
      storeID: getField(doc, ItemLabels.storeID.name, String),
      itemID: getField(doc, ItemLabels.itemID.name, String),
      storeName: getField(doc, ItemLabels.storeName.name, String),
      storePhoneNumber: getField(doc, ItemLabels.storePhoneNumber.name, String),
      itemPhotoUrl: getField(doc, ItemLabels.itemPhotoUrl.name, String),
      storeLogo: getField(doc, ItemLabels.storeLogo.name, String),
      videoUrl: getField(doc, ItemLabels.videoUrl.name, dynamic),
      firebaseVideoUrl: getField(doc, ItemLabels.firebaseVideoUrl.name, dynamic),
      keywords: getField(doc, ItemLabels.keywords.name, List<dynamic>),
      sourcePhotos: getField(doc, ItemLabels.sourcePhotos.name, List<dynamic>),
      description: getField(doc, ItemLabels.description.name, String),
      title: getField(doc, ItemLabels.title.name, String),
      attributes: getField(doc, ItemLabels.attributes.name, Map<String, dynamic>),
      currency: getField(doc, ItemLabels.currency.name, String),
      price: getField(doc, ItemLabels.price.name, num),
      salePrice: getField(doc, ItemLabels.salePrice.name, num),
      numLikes: getField(doc, ItemLabels.numLikes.name, num),
      numViews: getField(doc, ItemLabels.numViews.name, num),
      avgRating: getField(doc, ItemLabels.avgRating.name, num),
      numRatings: getField(doc, ItemLabels.numRatings.name, num),
      numReviews: getField(doc, ItemLabels.numReviews.name, num),
      numRefunds: getField(doc, ItemLabels.numRefunds.name, num),
      numReceptions: getField(doc, ItemLabels.numReceptions.name, num),
      numOrders: getField(doc, ItemLabels.numOrders.name, num),
      numConfirmations: getField(doc, ItemLabels.numConfirmations.name, num),
      numFavorites: getField(doc, ItemLabels.numFavorites.name, num),
      numPackagesSent: getField(doc, ItemLabels.numPackagesSent.name, num),
      numReminders: getField(doc, ItemLabels.numReminders.name, num),
      additionalInfo: getField(doc, ItemLabels.additionalInfo.name, String),
      brand: getField(doc, ItemLabels.brand.name, String),
      madeIn: getField(doc, ItemLabels.madeIn.name, String),
      category1: getField(doc, ItemLabels.category1.name, String),
      category2: getField(doc, ItemLabels.category2.name, String),
      category3: getField(doc, ItemLabels.category3.name, String),
      category4: getField(doc, ItemLabels.category4.name, String),
      category5: getField(doc, ItemLabels.category5.name, String),
      category6: getField(doc, ItemLabels.category6.name, String),
      country: getField(doc, ItemLabels.country.name, String),
      province: getField(doc, ItemLabels.province.name, String),
      subProvince: getField(doc, ItemLabels.subProvince.name, String),
      subSubProvince: getField(doc, ItemLabels.subSubProvince.name, String),
      streetAddress: getField(doc, ItemLabels.streetAddress.name, String),
      source: getField(doc, ItemLabels.source.name, Map<String, dynamic>),
      variants: getField(doc, ItemLabels.variants.name, Map<String, dynamic>),
      returnPolicy: getField(doc, ItemLabels.returnPolicy.name, ReturnPolicy),
      location: getField(doc, ItemLabels.location.name, Map<String, dynamic>),
      frequentlyAQ: getField(doc, ItemLabels.frequentlyAQ.name, Map<String, dynamic>),
      photoUrls: getField(doc, ItemLabels.photoUrls.name, List<dynamic>),
      thumbnailUrls100x100: getField(doc, ItemLabels.thumbnailUrls100x100.name, List<dynamic>),
      thumbnailUrls250x375: getField(doc, ItemLabels.thumbnailUrls250x375.name, List<dynamic>),
      thumbnailUrls500x500: getField(doc, ItemLabels.thumbnailUrls500x500.name, List<dynamic>),
      additionalPhotos: getField(doc, ItemLabels.additionalPhotos.name, List<dynamic>),
      isActive: getField(doc, ItemLabels.isActive.name, bool),
      teamChoice: getField(doc, ItemLabels.teamChoice.name, bool),
      timestamp: getField(doc, ItemLabels.timestamp.name, Timestamp),
    );
  }
  factory Item.empty() {
    return Item(
      storeOwnerID: null,
      storeID: null,
      itemID: null,
      storeName: null,
      storePhoneNumber: null,
      itemPhotoUrl: null,
      storeLogo: null,
      videoUrl: null,
      firebaseVideoUrl: null,
      keywords: null,
      sourcePhotos: null,
      description: null,
      title: null,
      attributes: null,
      currency: null,
      price: null,
      salePrice: null,
      numLikes: null,
      numViews: null,
      avgRating: null,
      numRatings: null,
      numReviews: null,
      numRefunds: null,
      numReceptions: null,
      numOrders: null,
      numConfirmations: null,
      numFavorites: null,
      numPackagesSent: null,
      numReminders: null,
      additionalInfo: null,
      brand: null,
      madeIn: null,
      category1: null,
      category2: null,
      category3: null,
      category4: null,
      category5: null,
      category6: null,
      country: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      streetAddress: null,
      source: null,
      variants: null,
      returnPolicy: null,
      location: null,
      frequentlyAQ: null,
      photoUrls: null,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      additionalPhotos: null,
      isActive: null,
      teamChoice: null,
      timestamp: null,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      ItemLabels.storeOwnerID.name: storeOwnerID,
      ItemLabels.storeID.name: storeID,
      ItemLabels.itemID.name: itemID,
      ItemLabels.storeName.name: storeName,
      ItemLabels.storePhoneNumber.name: storePhoneNumber,
      ItemLabels.itemPhotoUrl.name: itemPhotoUrl,
      ItemLabels.storeLogo.name: storeLogo,
      ItemLabels.videoUrl.name: videoUrl,
      ItemLabels.firebaseVideoUrl.name: firebaseVideoUrl,
      ItemLabels.description.name: description,
      ItemLabels.title.name: title,
      ItemLabels.attributes.name: attributes,
      ItemLabels.currency.name: currency,
      ItemLabels.price.name: price,
      ItemLabels.salePrice.name: salePrice,
      ItemLabels.numLikes.name: numLikes,
      ItemLabels.numViews.name: numViews,
      ItemLabels.avgRating.name: avgRating,
      ItemLabels.numRatings.name: numRatings,
      ItemLabels.numReviews.name: numReviews,
      ItemLabels.numRefunds.name: numRefunds,
      ItemLabels.numReceptions.name: numReceptions,
      ItemLabels.numOrders.name: numOrders,
      ItemLabels.numConfirmations.name: numConfirmations,
      ItemLabels.numFavorites.name: numFavorites,
      ItemLabels.numPackagesSent.name: numPackagesSent,
      ItemLabels.numReminders.name: numReminders,
      ItemLabels.additionalInfo.name: additionalInfo,
      ItemLabels.brand.name: brand,
      ItemLabels.madeIn.name: madeIn,
      ItemLabels.category1.name: category1,
      ItemLabels.category2.name: category2,
      ItemLabels.category3.name: category3,
      ItemLabels.category4.name: category4,
      ItemLabels.category5.name: category5,
      ItemLabels.category6.name: category6,
      ItemLabels.country.name: country,
      ItemLabels.province.name: province,
      ItemLabels.subProvince.name: subProvince,
      ItemLabels.subSubProvince.name: subSubProvince,
      ItemLabels.streetAddress.name: streetAddress,
      ItemLabels.source.name: source,
      ItemLabels.variants.name: variants,
      ItemLabels.returnPolicy.name: returnPolicy?.toJson(),
      ItemLabels.location.name: location,
      ItemLabels.frequentlyAQ.name: frequentlyAQ,
      ItemLabels.keywords.name: keywords,
      ItemLabels.sourcePhotos.name: sourcePhotos,
      ItemLabels.photoUrls.name: photoUrls,
      ItemLabels.thumbnailUrls100x100.name: thumbnailUrls100x100,
      ItemLabels.thumbnailUrls250x375.name: thumbnailUrls250x375,
      ItemLabels.thumbnailUrls500x500.name: thumbnailUrls500x500,
      ItemLabels.additionalPhotos.name: additionalPhotos,
      ItemLabels.isActive.name: isActive,
      ItemLabels.teamChoice.name: teamChoice,
      ItemLabels.timestamp.name: timestamp,
    };
  }

  Map<String, dynamic> toLinkJson() {
    return {
      ItemLabels.storeOwnerID.name: storeOwnerID,
      ItemLabels.storeID.name: storeID,
      ItemLabels.itemID.name: itemID,
      ItemLabels.storeName.name: storeName,
      ItemLabels.storePhoneNumber.name: storePhoneNumber,
      ItemLabels.itemPhotoUrl.name: itemPhotoUrl,
      ItemLabels.storeLogo.name: storeLogo,
      ItemLabels.videoUrl.name: videoUrl,
      ItemLabels.firebaseVideoUrl.name: firebaseVideoUrl,
      ItemLabels.description.name: description,
      ItemLabels.title.name: title,
      ItemLabels.attributes.name: jsonEncode(attributes),
      ItemLabels.currency.name: currency,
      ItemLabels.price.name: price.toString(),
      ItemLabels.salePrice.name: salePrice.toString(),
      ItemLabels.numLikes.name: numLikes.toString(),
      ItemLabels.numViews.name: numViews.toString(),
      ItemLabels.avgRating.name: avgRating.toString(),
      ItemLabels.numRatings.name: numRatings.toString(),
      ItemLabels.numReviews.name: numReviews.toString(),
      ItemLabels.numRefunds.name: numRefunds.toString(),
      ItemLabels.numReceptions.name: numReceptions.toString(),
      ItemLabels.numOrders.name: numOrders.toString(),
      ItemLabels.numConfirmations.name: numConfirmations.toString(),
      ItemLabels.numFavorites.name: numFavorites.toString(),
      ItemLabels.numPackagesSent.name: numPackagesSent.toString(),
      ItemLabels.numReminders.name: numReminders.toString(),
      ItemLabels.additionalInfo.name: additionalInfo,
      ItemLabels.brand.name: brand,
      ItemLabels.madeIn.name: madeIn,
      ItemLabels.category1.name: category1,
      ItemLabels.category2.name: category2,
      ItemLabels.category3.name: category3,
      ItemLabels.category4.name: category4,
      ItemLabels.category5.name: category5,
      ItemLabels.category6.name: category6,
      ItemLabels.country.name: country,
      ItemLabels.province.name: province,
      ItemLabels.subProvince.name: subProvince,
      ItemLabels.subSubProvince.name: subSubProvince,
      ItemLabels.streetAddress.name: streetAddress,
      ItemLabels.source.name: jsonEncode(source),
      ItemLabels.variants.name: jsonEncode(variants),
      ItemLabels.returnPolicy.name: jsonEncode(returnPolicy?.toJson()),
      ItemLabels.location.name: null,
      ItemLabels.frequentlyAQ.name: jsonEncode(frequentlyAQ),
      ItemLabels.keywords.name: keywords,
      ItemLabels.sourcePhotos.name: sourcePhotos,
      ItemLabels.photoUrls.name: photoUrls,
      ItemLabels.thumbnailUrls100x100.name: thumbnailUrls100x100,
      ItemLabels.thumbnailUrls250x375.name: thumbnailUrls250x375,
      ItemLabels.thumbnailUrls500x500.name: thumbnailUrls500x500,
      ItemLabels.additionalPhotos.name: additionalPhotos,
      ItemLabels.isActive.name: jsonEncode(isActive),
      ItemLabels.teamChoice.name: jsonEncode(teamChoice),
      ItemLabels.timestamp.name: (timestamp as Timestamp?)?.millisecondsSinceEpoch.toString(),
    };
  }

  bool isValid() {
    if (storeOwnerID != null &&
        storeID != null &&
        itemID != null &&
        description != null &&
        title != null &&
        price != null &&
        photoUrls != null &&
        isActive != null) return true;
    return false;
  }

  factory Item.fromPreferences({required SharedPreferences prefs}) {
    return Item(
      storeOwnerID: null,
      storeID: null,
      itemID: null,
      storeName: null,
      storePhoneNumber: null,
      itemPhotoUrl: null,
      storeLogo: null,
      videoUrl: prefs.getString(ItemLabels.videoUrl.name),
      firebaseVideoUrl: prefs.getString(ItemLabels.firebaseVideoUrl.name),
      description: prefs.getString(ItemLabels.description.name),
      title: prefs.getString(ItemLabels.title.name),
      attributes: null,
      currency: prefs.getString(ItemLabels.currency.name),
      price: prefs.getDouble(ItemLabels.price.name),
      salePrice: null,
      numLikes: null,
      numViews: null,
      avgRating: null,
      numRatings: null,
      numReviews: null,
      numRefunds: null,
      numReceptions: null,
      numOrders: null,
      numConfirmations: null,
      numFavorites: null,
      numPackagesSent: null,
      numReminders: null,
      additionalInfo: prefs.getString(ItemLabels.additionalInfo.name),
      brand: prefs.getString(ItemLabels.brand.name),
      madeIn: prefs.getString(ItemLabels.madeIn.name),
      category1: prefs.getString(ItemLabels.category1.name),
      category2: prefs.getString(ItemLabels.category2.name),
      category3: prefs.getString(ItemLabels.category3.name),
      category4: prefs.getString(ItemLabels.category4.name),
      category5: prefs.getString(ItemLabels.category5.name),
      category6: prefs.getString(ItemLabels.category6.name),
      country: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      streetAddress: prefs.getString(ItemLabels.streetAddress.name),
      source: null,
      variants: null,
      returnPolicy: null,
      location: null,
      frequentlyAQ: null,
      keywords: prefs.getStringList(ItemLabels.keywords.name),
      sourcePhotos: prefs.getStringList(ItemLabels.sourcePhotos.name),
      photoUrls: null,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      additionalPhotos: null,
      isActive: null,
      teamChoice: null,
      timestamp: null,
    );
  }
}

enum ItemLabels {
  storeOwnerID,
  storeID,
  itemID,
  storeName,
  storePhoneNumber,
  itemPhotoUrl,
  storeLogo,
  videoUrl,
  firebaseVideoUrl,
  description,
  title,
  attributes,
  currency,
  price,
  salePrice,
  numLikes,
  numViews,
  avgRating,
  numRatings,
  numReviews,
  numRefunds,
  numReceptions,
  numOrders,
  numConfirmations,
  numFavorites,
  numPackagesSent,
  numReminders,
  additionalInfo,
  brand,
  madeIn,
  category1,
  category2,
  category3,
  category4,
  category5,
  category6,
  country,
  province,
  subProvince,
  subSubProvince,
  streetAddress,
  source,
  variants,
  returnPolicy,
  location,
  frequentlyAQ,
  keywords,
  sourcePhotos,
  photoUrls,
  thumbnailUrls100x100,
  thumbnailUrls250x375,
  thumbnailUrls500x500,
  additionalPhotos,
  isActive,
  teamChoice,
  timestamp,
}

enum ReturnTimeFrame {
  sevenDayReturnPolicy,
  fourteenDayReturnPolicy,
  thirtyDayReturnPolicy,
  sixtyDayReturnPolicy,
  ninetyDayReturnPolicy,
  noReturnPolicy,
}

class ReturnPolicy {
  ReturnPolicy({
    this.timeFrame,
    this.acceptExchange,
    this.condition,
    this.returnOptions,
    this.exchangeOptions,
  });

  String? timeFrame;
  bool? acceptExchange;
  Conditions? condition;
  ReturnOptions? returnOptions;
  ExchangeOptions? exchangeOptions;

  Map<String, dynamic> toJson() => {
        'timeFrame': timeFrame,
        'acceptExchange': acceptExchange,
        'conditions': condition?.toJson(),
        'returnOptions': returnOptions?.toJson(),
        'exchangeOptions': exchangeOptions?.toJson(),
      };

  ReturnPolicy copyWith({
    String? timeFrame,
    bool? isExchangeable,
    Conditions? condition,
    ReturnOptions? returnOptions,
    ExchangeOptions? exchangeOptions,
  }) {
    return ReturnPolicy(
      timeFrame: timeFrame ?? this.timeFrame,
      acceptExchange: isExchangeable ?? this.acceptExchange,
      condition: condition ?? this.condition,
      returnOptions: returnOptions ?? this.returnOptions,
      exchangeOptions: exchangeOptions ?? this.exchangeOptions,
    );
  }

  factory ReturnPolicy.empty() {
    return ReturnPolicy(
      timeFrame: null,
      acceptExchange: null,
      condition: null,
      returnOptions: null,
      exchangeOptions: null,
    );
  }

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) => ReturnPolicy(
        timeFrame: json['timeFrame'],
        acceptExchange: json['acceptExchange'],
        condition: Conditions.fromJson(json['conditions']),
        returnOptions: ReturnOptions.fromJson(json['returnOptions']),
        exchangeOptions: ExchangeOptions.fromJson(json['exchangeOptions']),
      );
}

class Conditions {
  Conditions({
    this.unusedOriginalCondition,
    this.defectiveDamaged,
    this.notAsDescribed,
  });

  bool? unusedOriginalCondition;
  bool? defectiveDamaged;
  bool? notAsDescribed;

  Conditions copyWith({
    bool? unusedOriginalCondition,
    bool? defectiveDamaged,
    bool? notAsDescribed,
  }) {
    return Conditions(
      unusedOriginalCondition: unusedOriginalCondition ?? unusedOriginalCondition,
      defectiveDamaged: defectiveDamaged ?? defectiveDamaged,
      notAsDescribed: notAsDescribed ?? notAsDescribed,
    );
  }

  Map<String, dynamic> toJson() => {
        'unusedOriginalCondition': unusedOriginalCondition,
        'defectiveDamaged': defectiveDamaged,
        'notAsDescribed': notAsDescribed,
      };

  factory Conditions.fromJson(Map<String, dynamic> json) => Conditions(
        unusedOriginalCondition: json['unusedOriginalCondition'],
        defectiveDamaged: json['defectiveDamaged'],
        notAsDescribed: json['notAsDescribed'],
      );
}

class ReturnOptions {
  ReturnOptions({
    this.inStoreReturns,
    this.mailReturns,
    this.homeOfficePickupReturns,
  });

  OptionDescription? inStoreReturns;
  OptionDescription? mailReturns;
  OptionDescription? homeOfficePickupReturns;

  ReturnOptions copyWith({
    OptionDescription? inStore,
    OptionDescription? mailReturns,
    OptionDescription? homeOfficePickups,
  }) {
    return ReturnOptions(
      inStoreReturns: inStore ?? inStoreReturns,
      mailReturns: mailReturns ?? mailReturns,
      homeOfficePickupReturns: homeOfficePickups ?? homeOfficePickupReturns,
    );
  }

  Map<String, dynamic> toJson() => {
        'inStoreReturns': inStoreReturns,
        'mailReturns': mailReturns,
        'homeOfficePickupReturns': homeOfficePickupReturns,
      };

  factory ReturnOptions.fromJson(Map<String, dynamic> json) => ReturnOptions(
        inStoreReturns: OptionDescription.fromJson(json['inStoreReturns']),
        mailReturns: OptionDescription.fromJson(json['mailReturns']),
        homeOfficePickupReturns: OptionDescription.fromJson(json['homeOfficePickupReturns']),
      );
}

class ExchangeOptions {
  ExchangeOptions({
    this.inStoreExchanges,
    this.mailExchanges,
    this.homeOfficePickupExchanges,
  });

  OptionDescription? inStoreExchanges;
  OptionDescription? mailExchanges;
  OptionDescription? homeOfficePickupExchanges;

  Map<String, dynamic> toJson() => {
        'inStoreExchanges': inStoreExchanges,
        'mailExchanges': mailExchanges,
        'homeOfficePickupExchanges': homeOfficePickupExchanges,
      };

  factory ExchangeOptions.fromJson(Map<String, dynamic> json) => ExchangeOptions(
        inStoreExchanges: OptionDescription.fromJson(json['inStoreExchanges']),
        mailExchanges: OptionDescription.fromJson(json['mailExchanges']),
        homeOfficePickupExchanges: OptionDescription.fromJson(json['homeOfficePickupExchanges']),
      );
}

class OptionDescription {
  OptionDescription({
    this.isAvailable,
    this.feeBearer,
    this.address,
    this.percentage,
  });

  bool? isAvailable;
  String? feeBearer;
  String? address;
  num? percentage;

  OptionDescription copyWith({
    bool? isAvailable,
    String? feeBearer,
    String? address,
    num? percentage,
  }) {
    return OptionDescription(
      isAvailable: isAvailable ?? this.isAvailable,
      feeBearer: feeBearer ?? this.feeBearer,
      address: address ?? this.address,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toJson() => {
        'isAvailable': isAvailable,
        'feeBearer': feeBearer,
        'address': address,
        'percentage': percentage,
      };

  factory OptionDescription.fromJson(Map<String, dynamic> json) => OptionDescription(
        isAvailable: json['isAvailable'],
        feeBearer: json['feeBearer'],
        address: json['address'],
        percentage: json['percentage'],
      );
}
