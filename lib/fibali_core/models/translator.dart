import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class Translator {
  final String? translatorID;
  final String? status;
  String? bio;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? dialCode;
  final num? avgRating;
  final num? numRatings;
  final num? numReviews;
  final num? numLikes;
  final num? numRefunds;
  final num? numCompletions;
  final num? numOrders;
  final num? hourlyRate;
  final Map<String, dynamic>? stats;
  String? photoUrl;
  final String? translatorClass;
  List<dynamic>? languages;
  List<dynamic>? languagesCodings;
  String? country;
  bool? isOnlineTranslator;
  bool? isInPersonTranslator;
  bool? isActive;
  String? province;
  String? subProvince;
  final String? subSubProvince;
  final dynamic timestamp;

  Translator({
    required this.translatorID,
    required this.bio,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dialCode,
    required this.status,
    required this.avgRating,
    required this.numRatings,
    required this.numReviews,
    required this.numLikes,
    required this.numRefunds,
    required this.numCompletions,
    required this.numOrders,
    required this.hourlyRate,
    required this.stats,
    required this.photoUrl,
    required this.translatorClass,
    required this.languages,
    required this.languagesCodings,
    required this.country,
    required this.isOnlineTranslator,
    required this.isInPersonTranslator,
    required this.isActive,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.timestamp,
  });
  static const translatorsCollection = 'translators';

  static CollectionReference<Translator> get ref =>
      FirebaseFirestore.instance.collection(translatorsCollection).withConverter<Translator>(
          fromFirestore: (snapshot, options) => Translator.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory Translator.fromFirestore(Map<String, dynamic> doc) {
    return Translator(
      translatorID: getField(doc, TLabels.translatorID.name, String),
      status: getField(doc, TLabels.status.name, String),
      bio: getField(doc, TLabels.bio.name, String),
      firstName: getField(doc, TLabels.firstName.name, String),
      lastName: getField(doc, TLabels.lastName.name, String),
      phoneNumber: getField(doc, TLabels.phoneNumber.name, String),
      dialCode: getField(doc, TLabels.dialCode.name, String),
      avgRating: getField(doc, TLabels.avgRating.name, num),
      numRatings: getField(doc, TLabels.numRatings.name, num),
      numReviews: getField(doc, TLabels.numReviews.name, num),
      numLikes: getField(doc, TLabels.numLikes.name, num),
      numRefunds: getField(doc, TLabels.numRefunds.name, num),
      numCompletions: getField(doc, TLabels.numCompletions.name, num),
      numOrders: getField(doc, TLabels.numOrders.name, num),
      hourlyRate: getField(doc, TLabels.hourlyRate.name, num),
      stats: getField(doc, TLabels.stats.name, Map<String, dynamic>),
      photoUrl: getField(doc, TLabels.photoUrl.name, String),
      translatorClass: getField(doc, TLabels.translatorClass.name, String),
      languages: getField(doc, TLabels.languages.name, List<dynamic>),
      languagesCodings: getField(doc, TLabels.languagesCodings.name, List<dynamic>),
      country: getField(doc, TLabels.country.name, String),
      isOnlineTranslator: getField(doc, TLabels.isOnlineTranslator.name, bool),
      isInPersonTranslator: getField(doc, TLabels.isInPersonTranslator.name, bool),
      isActive: getField(doc, TLabels.isActive.name, bool),
      province: getField(doc, TLabels.province.name, String),
      subProvince: getField(doc, TLabels.subProvince.name, String),
      subSubProvince: getField(doc, TLabels.subSubProvince.name, String),
      timestamp: getField(doc, TLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      TLabels.translatorID.name: translatorID,
      TLabels.status.name: status,
      TLabels.bio.name: bio,
      TLabels.firstName.name: firstName,
      TLabels.lastName.name: lastName,
      TLabels.phoneNumber.name: phoneNumber,
      TLabels.dialCode.name: dialCode,
      TLabels.avgRating.name: avgRating,
      TLabels.numRatings.name: numRatings,
      TLabels.numReviews.name: numReviews,
      TLabels.numLikes.name: numLikes,
      TLabels.numRefunds.name: numRefunds,
      TLabels.numCompletions.name: numCompletions,
      TLabels.numOrders.name: numOrders,
      TLabels.hourlyRate.name: hourlyRate,
      TLabels.stats.name: stats,
      TLabels.photoUrl.name: photoUrl,
      TLabels.translatorClass.name: translatorClass,
      TLabels.languages.name: languages,
      TLabels.languagesCodings.name: languagesCodings,
      TLabels.country.name: country,
      TLabels.isOnlineTranslator.name: isOnlineTranslator,
      TLabels.isInPersonTranslator.name: isInPersonTranslator,
      TLabels.isActive.name: isActive,
      TLabels.province.name: province,
      TLabels.subProvince.name: subProvince,
      TLabels.subSubProvince.name: subSubProvince,
      TLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (translatorID != null) return true;
    return false;
  }
}

enum TLabels {
  translatorID,
  status,
  bio,
  firstName,
  lastName,
  phoneNumber,
  dialCode,
  avgRating,
  numRatings,
  numReviews,
  numLikes,
  numRefunds,
  numCompletions,
  numOrders,
  hourlyRate,
  stats,
  photoUrl,
  translatorClass,
  languages,
  languagesCodings,
  country,
  isOnlineTranslator,
  isInPersonTranslator,
  isActive,
  province,
  subProvince,
  subSubProvince,
  timestamp,
}

enum TStatus { applicationPending, hired, fired, suspended }
