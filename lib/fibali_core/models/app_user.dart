import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppUser {
  final String uid;
  String name;
  String? phoneNumber;
  String? email;
  String? bio;
  String? gender;
  String? backgroundPhoto;
  String? country;
  String? businessType;
  Map<String, dynamic>? deliveryAddress;
  Map<String, dynamic>? location;
  Map<String, dynamic>? devices;
  bool? isVerified;
  bool? busyCalling;
  bool? isSeller;
  bool? isActive;
  bool? isAnonymous;
  List<dynamic>? relations;
  String? photoUrl;
  num? numFollower;
  num? numFollowing;
  num? avgSwapRating;
  num? numSwapRating;
  dynamic timestamp;
  dynamic birthDay;
  dynamic userTermsAgreementTimestamp;

  AppUser({
    required this.uid,
    required this.name,
    required this.isVerified,
    required this.busyCalling,
    required this.phoneNumber,
    required this.email,
    required this.bio,
    required this.gender,
    required this.deliveryAddress,
    required this.location,
    required this.devices,
    required this.backgroundPhoto,
    required this.country,
    required this.businessType,
    required this.isSeller,
    required this.isActive,
    required this.isAnonymous,
    required this.relations,
    required this.photoUrl,
    required this.numFollower,
    required this.numFollowing,
    required this.avgSwapRating,
    required this.numSwapRating,
    required this.timestamp,
    required this.birthDay,
    required this.userTermsAgreementTimestamp,
  });

  static CollectionReference<AppUser> get ref => FirebaseFirestore.instance
      .collection(usersCollection)
      .withConverter<AppUser>(
          fromFirestore: (snapshot, options) =>
              AppUser.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  static Reference photoStorageRef({required String userID}) {
    return FirebaseStorage.instance
        .ref()
        .child(usersCollection)
        .child(userID)
        .child('profilePhoto');
  }

  factory AppUser.fromFirestore(Map<String, dynamic> doc) {
    return AppUser(
      uid: getField(doc, AULabels.uid.name, String),
      name: getField(doc, AULabels.name.name, String),
      phoneNumber: getField(doc, AULabels.phoneNumber.name, String),
      email: getField(doc, AULabels.email.name, String),
      bio: getField(doc, AULabels.bio.name, String),
      gender: getField(doc, AULabels.gender.name, String),
      deliveryAddress:
          getField(doc, AULabels.deliveryAddress.name, Map<String, dynamic>),
      location: getField(doc, AULabels.location.name, Map<String, dynamic>),
      devices: getField(doc, AULabels.devices.name, Map<String, dynamic>),
      backgroundPhoto: getField(doc, AULabels.backgroundPhoto.name, String),
      country: getField(doc, AULabels.country.name, String),
      businessType: getField(doc, AULabels.businessType.name, String),
      isSeller: getField(doc, AULabels.isSeller.name, bool),
      isVerified: getField(doc, AULabels.isVerified.name, bool),
      busyCalling: getField(doc, AULabels.busyCalling.name, bool),
      isActive: getField(doc, AULabels.isActive.name, bool),
      isAnonymous: getField(doc, AULabels.isAnonymous.name, bool),
      relations: getField(doc, AULabels.relations.name, List<dynamic>),
      photoUrl: getField(doc, AULabels.photoUrl.name, String),
      numFollower: getField(doc, AULabels.numFollower.name, num),
      numFollowing: getField(doc, AULabels.numFollowing.name, num),
      avgSwapRating: getField(doc, AULabels.avgSwapRating.name, num),
      numSwapRating: getField(doc, AULabels.numSwapRating.name, num),
      timestamp: getField(doc, AULabels.timestamp.name, Timestamp),
      birthDay: getField(doc, AULabels.birthDay.name, Timestamp),
      userTermsAgreementTimestamp:
          getField(doc, AULabels.userTermsAgreementTimestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AULabels.uid.name: uid,
      AULabels.name.name: name,
      AULabels.phoneNumber.name: phoneNumber,
      AULabels.email.name: email,
      AULabels.bio.name: bio,
      AULabels.gender.name: gender,
      AULabels.deliveryAddress.name: deliveryAddress,
      AULabels.location.name: location,
      AULabels.devices.name: devices,
      AULabels.backgroundPhoto.name: backgroundPhoto,
      AULabels.country.name: country,
      AULabels.businessType.name: businessType,
      AULabels.isSeller.name: isSeller,
      AULabels.isVerified.name: isVerified,
      AULabels.busyCalling.name: busyCalling,
      AULabels.isActive.name: isActive,
      AULabels.isAnonymous.name: isAnonymous,
      AULabels.relations.name: relations,
      AULabels.photoUrl.name: photoUrl,
      AULabels.numFollower.name: numFollower,
      AULabels.numFollowing.name: numFollowing,
      AULabels.avgSwapRating.name: avgSwapRating,
      AULabels.numSwapRating.name: numSwapRating,
      AULabels.timestamp.name: timestamp,
      AULabels.birthDay.name: birthDay,
      AULabels.userTermsAgreementTimestamp.name: userTermsAgreementTimestamp,
    };
  }

  Map<String, dynamic> toFAJson() {
    return {
      AULabels.uid.name: uid,
      AULabels.name.name: name,
      AULabels.phoneNumber.name: phoneNumber,
      AULabels.email.name: email,
      AULabels.bio.name: bio,
      AULabels.gender.name: gender,
      AULabels.deliveryAddress.name: deliveryAddress,
      AULabels.location.name: location,
      AULabels.devices.name: devices,
      AULabels.backgroundPhoto.name: backgroundPhoto,
      AULabels.country.name: country,
      AULabels.businessType.name: businessType,
      AULabels.isSeller.name: isSeller,
      AULabels.isVerified.name: isVerified,
      AULabels.busyCalling.name: busyCalling,
      AULabels.isActive.name: isActive,
      AULabels.isAnonymous.name: isAnonymous,
      AULabels.relations.name: relations,
      AULabels.photoUrl.name: photoUrl,
      AULabels.numFollower.name: numFollower,
      AULabels.numFollowing.name: numFollowing,
      AULabels.avgSwapRating.name: avgSwapRating,
      AULabels.numSwapRating.name: numSwapRating,
      AULabels.timestamp.name: timestamp,
      AULabels.birthDay.name: birthDay,
      AULabels.userTermsAgreementTimestamp.name: userTermsAgreementTimestamp,
    };
  }
}

// TODO: find a less ugly solution
dynamic getField(doc, String name, Type type) {
  try {
    final value = doc[name];

    if (type == Map<String, dynamic>) return Map<String, dynamic>.from(value);

    if (type == List<dynamic>) return List<dynamic>.from(value);

    if (value is num && type == num) return num.tryParse(value.toString());

    if (value.runtimeType == type) return value;

    return null;
  } catch (err) {
    // print('firestore error $name: $err');
    return null;
  }
}

enum AULabels {
  uid,
  name,
  phoneNumber,
  email,
  bio,
  gender,
  deliveryAddress,
  location,
  devices,
  backgroundPhoto,
  country,
  businessType,
  isSeller,
  isVerified,
  busyCalling,
  isActive,
  isAnonymous,
  relations,
  photoUrl,
  numFollower,
  numFollowing,
  avgSwapRating,
  numSwapRating,
  timestamp,
  birthDay,
  userTermsAgreementTimestamp,
}

enum DeviceParameters {
  deviceID,
  data,
  token,
  lastTokenTimestamp,
  lastLoggedInTimestamp,
  lastLoggedOutTimestamp,
  isLogged
}

enum UTAKeys {
  reference,
  hasAcceptedTerms,
  timestamp,
}
