import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class Store {
  final String? storeOwnerID;
  final String? status;
  final String? storeID;
  String? description;
  String? name;
  String? authorFirstName;
  String? authorLastName;
  String? phoneNumber;
  String? dialCode;
  final num? avgRating;
  final num? numRatings;
  final num? numReviews;
  final num? numLikes;
  final num? numViews;
  final num? numFavorites;
  final num? numRefunds;
  final num? numReceptions;
  final num? numOrders;
  final num? numPackagesSent;
  final num? numConfirmations;
  final num? numReminders;
  final Map<String, dynamic>? stats;
  String? logo;
  String? background;
  String? currency;
  final List<dynamic>? categories;
  List<dynamic>? keywords;
  String? country;
  String? province;
  String? subProvince;
  final String? subSubProvince;
  String? streetAddress;
  final dynamic timestamp;

  Store({
    required this.storeOwnerID,
    required this.storeID,
    required this.description,
    required this.name,
    required this.authorFirstName,
    required this.authorLastName,
    required this.phoneNumber,
    required this.dialCode,
    required this.status,
    required this.avgRating,
    required this.numRatings,
    required this.numReviews,
    required this.numLikes,
    required this.numViews,
    required this.numFavorites,
    required this.numRefunds,
    required this.numReceptions,
    required this.numOrders,
    required this.numPackagesSent,
    required this.numConfirmations,
    required this.numReminders,
    required this.stats,
    required this.logo,
    required this.background,
    required this.currency,
    required this.categories,
    required this.keywords,
    required this.country,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.streetAddress,
    required this.timestamp,
  });
  static const storesCollection = 'stores';

  static CollectionReference<Store> get ref =>
      FirebaseFirestore.instance.collection(storesCollection).withConverter<Store>(
          fromFirestore: (snapshot, options) => Store.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory Store.fromFirestore(Map<String, dynamic> doc) {
    return Store(
      storeOwnerID: getField(doc, StoreLabels.storeOwnerID.name, String),
      status: getField(doc, StoreLabels.status.name, String),
      storeID: getField(doc, StoreLabels.storeID.name, String),
      description: getField(doc, StoreLabels.description.name, String),
      name: getField(doc, StoreLabels.name.name, String),
      authorFirstName: getField(doc, StoreLabels.authorFirstName.name, String),
      authorLastName: getField(doc, StoreLabels.authorLastName.name, String),
      phoneNumber: getField(doc, StoreLabels.phoneNumber.name, String),
      dialCode: getField(doc, StoreLabels.dialCode.name, String),
      avgRating: getField(doc, StoreLabels.avgRating.name, num),
      numRatings: getField(doc, StoreLabels.numRatings.name, num),
      numReviews: getField(doc, StoreLabels.numReviews.name, num),
      numLikes: getField(doc, StoreLabels.numLikes.name, num),
      numViews: getField(doc, StoreLabels.numViews.name, num),
      numFavorites: getField(doc, StoreLabels.numFavorites.name, num),
      numRefunds: getField(doc, StoreLabels.numRefunds.name, num),
      numReceptions: getField(doc, StoreLabels.numReceptions.name, num),
      numOrders: getField(doc, StoreLabels.numOrders.name, num),
      numPackagesSent: getField(doc, StoreLabels.numPackagesSent.name, num),
      numConfirmations: getField(doc, StoreLabels.numConfirmations.name, num),
      numReminders: getField(doc, StoreLabels.numReminders.name, num),
      stats: getField(doc, StoreLabels.stats.name, Map<String, dynamic>),
      logo: getField(doc, StoreLabels.logo.name, String),
      background: getField(doc, StoreLabels.background.name, String),
      currency: getField(doc, StoreLabels.currency.name, String),
      categories: getField(doc, StoreLabels.categories.name, List<dynamic>),
      keywords: getField(doc, StoreLabels.keywords.name, List<dynamic>),
      country: getField(doc, StoreLabels.country.name, String),
      province: getField(doc, StoreLabels.province.name, String),
      subProvince: getField(doc, StoreLabels.subProvince.name, String),
      subSubProvince: getField(doc, StoreLabels.subSubProvince.name, String),
      streetAddress: getField(doc, StoreLabels.streetAddress.name, String),
      timestamp: getField(doc, StoreLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      StoreLabels.storeOwnerID.name: storeOwnerID,
      StoreLabels.status.name: status,
      StoreLabels.storeID.name: storeID,
      StoreLabels.description.name: description,
      StoreLabels.name.name: name,
      StoreLabels.authorFirstName.name: authorFirstName,
      StoreLabels.authorLastName.name: authorLastName,
      StoreLabels.phoneNumber.name: phoneNumber,
      StoreLabels.dialCode.name: dialCode,
      StoreLabels.avgRating.name: avgRating,
      StoreLabels.numRatings.name: numRatings,
      StoreLabels.numReviews.name: numReviews,
      StoreLabels.numLikes.name: numLikes,
      StoreLabels.numViews.name: numViews,
      StoreLabels.numFavorites.name: numFavorites,
      StoreLabels.numRefunds.name: numRefunds,
      StoreLabels.numReceptions.name: numReceptions,
      StoreLabels.numOrders.name: numOrders,
      StoreLabels.numPackagesSent.name: numPackagesSent,
      StoreLabels.numConfirmations.name: numConfirmations,
      StoreLabels.numReminders.name: numReminders,
      StoreLabels.stats.name: stats,
      StoreLabels.logo.name: logo,
      StoreLabels.background.name: background,
      StoreLabels.currency.name: currency,
      StoreLabels.categories.name: categories,
      StoreLabels.keywords.name: keywords,
      StoreLabels.country.name: country,
      StoreLabels.province.name: province,
      StoreLabels.subProvince.name: subProvince,
      StoreLabels.subSubProvince.name: subSubProvince,
      StoreLabels.streetAddress.name: streetAddress,
      StoreLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (storeOwnerID != null &&
        status != null &&
        storeID != null &&
        description != null &&
        name != null &&
        authorFirstName != null &&
        authorLastName != null &&
        phoneNumber != null &&
        dialCode != null &&
        logo != null &&
        background != null &&
        currency != null &&
        country != null &&
        streetAddress != null) return true;
    return false;
  }
}

enum StoreLabels {
  storeOwnerID,
  status,
  storeID,
  description,
  name,
  authorFirstName,
  authorLastName,
  phoneNumber,
  dialCode,
  avgRating,
  numRatings,
  numReviews,
  numLikes,
  numViews,
  numFavorites,
  numRefunds,
  numReceptions,
  numOrders,
  numPackagesSent,
  numConfirmations,
  numReminders,
  stats,
  logo,
  background,
  currency,
  categories,
  keywords,
  country,
  province,
  subProvince,
  subSubProvince,
  streetAddress,
  timestamp,
}
