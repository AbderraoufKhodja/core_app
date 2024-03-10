import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwapItem {
  String? itemID;
  String? uid;
  String? ownerName;
  String? ownerPhoto;
  List<dynamic>? photoUrls;
  String? description;
  String? title;
  Map<String, dynamic>? location;
  String? currency;
  num? price;
  final num? numLikes;
  final num? numRatings;
  final num? numReceptions;
  final num? numFavorites;
  final num? numComments;
  final num? numViews;
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
  List<dynamic>? tags;
  bool? isActive;
  bool? isSwapped;
  bool? isSoldOut;
  bool? isForSale;
  bool? isForSwap;
  dynamic timestamp;

  SwapItem({
    required this.uid,
    required this.itemID,
    required this.ownerName,
    required this.ownerPhoto,
    required this.description,
    required this.title,
    required this.location,
    required this.currency,
    required this.price,
    required this.numLikes,
    required this.numRatings,
    required this.numReceptions,
    required this.numFavorites,
    required this.numComments,
    required this.numViews,
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
    required this.tags,
    required this.photoUrls,
    required this.isActive,
    required this.isSwapped,
    required this.isSoldOut,
    required this.isForSale,
    required this.isForSwap,
    required this.timestamp,
  });

  static CollectionReference<SwapItem> get ref => FirebaseFirestore.instance
      .collection(swapItemsCollection)
      .withConverter<SwapItem>(
          fromFirestore: (snapshot, options) =>
              SwapItem.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory SwapItem.fromFirestore(Map<String, dynamic> doc) {
    return SwapItem(
      uid: getField(doc, SILabels.uid.name, String),
      itemID: getField(doc, SILabels.itemID.name, String),
      ownerName: getField(doc, SILabels.ownerName.name, String),
      ownerPhoto: getField(doc, SILabels.ownerPhoto.name, String),
      tags: getField(doc, SILabels.tags.name, List<dynamic>),
      description: getField(doc, SILabels.description.name, String),
      title: getField(doc, SILabels.title.name, String),
      location: getField(doc, SILabels.location.name, Map<String, dynamic>),
      currency: getField(doc, SILabels.currency.name, String),
      price: getField(doc, SILabels.price.name, num),
      numLikes: getField(doc, SILabels.numLikes.name, num),
      numRatings: getField(doc, SILabels.numRatings.name, num),
      numReceptions: getField(doc, SILabels.numReceptions.name, num),
      numFavorites: getField(doc, SILabels.numFavorites.name, num),
      numComments: getField(doc, SILabels.numComments.name, num),
      numViews: getField(doc, SILabels.numViews.name, num),
      additionalInfo: getField(doc, SILabels.additionalInfo.name, String),
      brand: getField(doc, SILabels.brand.name, String),
      madeIn: getField(doc, SILabels.madeIn.name, String),
      category1: getField(doc, SILabels.category1.name, String),
      category2: getField(doc, SILabels.category2.name, String),
      category3: getField(doc, SILabels.category3.name, String),
      category4: getField(doc, SILabels.category4.name, String),
      category5: getField(doc, SILabels.category5.name, String),
      category6: getField(doc, SILabels.category6.name, String),
      country: getField(doc, SILabels.country.name, String),
      province: getField(doc, SILabels.province.name, String),
      subProvince: getField(doc, SILabels.subProvince.name, String),
      subSubProvince: getField(doc, SILabels.subSubProvince.name, String),
      streetAddress: getField(doc, SILabels.streetAddress.name, String),
      photoUrls: getField(doc, SILabels.photoUrls.name, List<dynamic>),
      isActive: getField(doc, SILabels.isActive.name, bool),
      isSwapped: getField(doc, SILabels.isSwapped.name, bool),
      isSoldOut: getField(doc, SILabels.isSoldOut.name, bool),
      isForSale: getField(doc, SILabels.isForSale.name, bool),
      isForSwap: getField(doc, SILabels.isForSwap.name, bool),
      timestamp: getField(doc, SILabels.timestamp.name, Timestamp),
    );
  }

  factory SwapItem.empty() {
    return SwapItem(
      uid: null,
      itemID: null,
      ownerName: null,
      ownerPhoto: null,
      tags: null,
      description: null,
      title: null,
      location: null,
      currency: null,
      price: null,
      numLikes: null,
      numRatings: null,
      numReceptions: null,
      numFavorites: null,
      numComments: null,
      numViews: null,
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
      photoUrls: null,
      isActive: null,
      isSwapped: null,
      isSoldOut: null,
      isForSale: null,
      isForSwap: null,
      timestamp: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) SILabels.uid.name: uid,
      if (itemID != null) SILabels.itemID.name: itemID,
      if (ownerName != null) SILabels.ownerName.name: ownerName,
      if (ownerPhoto != null) SILabels.ownerPhoto.name: ownerPhoto,
      if (description != null) SILabels.description.name: description,
      if (title != null) SILabels.title.name: title,
      if (location != null) SILabels.location.name: location,
      if (currency != null) SILabels.currency.name: currency,
      if (price != null) SILabels.price.name: price,
      if (numLikes != null) SILabels.numLikes.name: numLikes,
      if (numRatings != null) SILabels.numRatings.name: numRatings,
      if (numReceptions != null) SILabels.numReceptions.name: numReceptions,
      if (numFavorites != null) SILabels.numFavorites.name: numFavorites,
      if (numComments != null) SILabels.numComments.name: numComments,
      if (numViews != null) SILabels.numViews.name: numViews,
      if (additionalInfo != null) SILabels.additionalInfo.name: additionalInfo,
      if (brand != null) SILabels.brand.name: brand,
      if (madeIn != null) SILabels.madeIn.name: madeIn,
      if (category1 != null) SILabels.category1.name: category1,
      if (category2 != null) SILabels.category2.name: category2,
      if (category3 != null) SILabels.category3.name: category3,
      if (category4 != null) SILabels.category4.name: category4,
      if (category5 != null) SILabels.category5.name: category5,
      if (category6 != null) SILabels.category6.name: category6,
      if (country != null) SILabels.country.name: country,
      if (province != null) SILabels.province.name: province,
      if (subProvince != null) SILabels.subProvince.name: subProvince,
      if (subSubProvince != null) SILabels.subSubProvince.name: subSubProvince,
      if (streetAddress != null) SILabels.streetAddress.name: streetAddress,
      if (tags != null) SILabels.tags.name: tags,
      if (photoUrls != null) SILabels.photoUrls.name: photoUrls,
      if (isActive != null) SILabels.isActive.name: isActive,
      if (isSwapped != null) SILabels.isSwapped.name: isSwapped,
      if (isSoldOut != null) SILabels.isSoldOut.name: isSoldOut,
      if (isForSale != null) SILabels.isForSale.name: isForSale,
      if (isForSwap != null) SILabels.isForSwap.name: isForSwap,
      if (timestamp != null) SILabels.timestamp.name: timestamp,
    };
  }

  Map<String, dynamic> toLinkJson() {
    return {
      if (uid != null) SILabels.uid.name: uid,
      if (itemID != null) SILabels.itemID.name: itemID,
      if (ownerName != null) SILabels.ownerName.name: ownerName,
      if (description != null) SILabels.description.name: description,
      if (photoUrls != null) SILabels.photoUrls.name: photoUrls![0],
    };
  }

  bool isValid() {
    if (uid != null &&
        itemID != null &&
        ownerName != null &&
        photoUrls != null) {
      return true;
    }

    return false;
  }

  factory SwapItem.fromPreferences({required SharedPreferences prefs}) {
    return SwapItem(
      uid: null,
      itemID: null,
      ownerName: null,
      ownerPhoto: null,
      description: prefs.getString(SILabels.description.name),
      title: prefs.getString(SILabels.title.name),
      location: null,
      currency: prefs.getString(SILabels.currency.name),
      price: prefs.getDouble(SILabels.price.name),
      numLikes: null,
      numRatings: null,
      numReceptions: null,
      numFavorites: null,
      numComments: null,
      numViews: null,
      additionalInfo: prefs.getString(SILabels.additionalInfo.name),
      brand: prefs.getString(SILabels.brand.name),
      madeIn: prefs.getString(SILabels.madeIn.name),
      category1: prefs.getString(SILabels.category1.name),
      category2: prefs.getString(SILabels.category2.name),
      category3: prefs.getString(SILabels.category3.name),
      category4: prefs.getString(SILabels.category4.name),
      category5: prefs.getString(SILabels.category5.name),
      category6: prefs.getString(SILabels.category6.name),
      country: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      streetAddress: prefs.getString(SILabels.streetAddress.name),
      tags: prefs.getStringList(SILabels.tags.name),
      photoUrls: null,
      isActive: null,
      isSwapped: null,
      isSoldOut: null,
      isForSale: null,
      isForSwap: null,
      timestamp: null,
    );
  }

  static Reference itemsStorageRef(
      {required String userID, required String itemID}) {
    return FirebaseStorage.instance
        .ref()
        .child('users')
        .child(userID)
        .child('swapItems')
        .child(itemID)
        .child('itemsPhotos');
  }
}

enum SILabels {
  uid,
  itemID,
  ownerName,
  ownerPhoto,
  description,
  title,
  location,
  currency,
  price,
  numLikes,
  numRatings,
  numReceptions,
  numFavorites,
  numComments,
  numViews,
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
  tags,
  photoUrls,
  isActive,
  isSwapped,
  isSoldOut,
  isForSale,
  isForSwap,
  timestamp,
}
