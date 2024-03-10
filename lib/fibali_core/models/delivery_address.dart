import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryAddress {
  String? id;
  String? name;
  String? phoneNumber;
  GeoPoint? geopoint;
  String? dialCode;
  String? isoCode;
  String? country;
  String? province;
  String? subProvince;
  String? subSubProvince;
  String? streetAddress;

  DeliveryAddress({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.geopoint,
    required this.dialCode,
    required this.isoCode,
    required this.country,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.streetAddress,
  });
  static ref({required String userID}) => FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(userID)
      .collection('addresses')
      .withConverter<DeliveryAddress>(
        fromFirestore: (snapshot, options) => DeliveryAddress.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );
  factory DeliveryAddress.fromFirestore(Map<String, dynamic> doc) {
    return DeliveryAddress(
      id: getField(doc, DALabels.id.name, String),
      name: getField(doc, DALabels.name.name, String),
      phoneNumber: getField(doc, DALabels.phoneNumber.name, String),
      geopoint: getField(doc, DALabels.geopoint.name, GeoPoint),
      dialCode: getField(doc, DALabels.dialCode.name, String),
      isoCode: getField(doc, DALabels.isoCode.name, String),
      country: getField(doc, DALabels.country.name, String),
      province: getField(doc, DALabels.province.name, String),
      subProvince: getField(doc, DALabels.subProvince.name, String),
      subSubProvince: getField(doc, DALabels.subSubProvince.name, String),
      streetAddress: getField(doc, DALabels.streetAddress.name, String),
    );
  }
  factory DeliveryAddress.empty() {
    return DeliveryAddress(
      id: null,
      name: null,
      phoneNumber: null,
      geopoint: null,
      dialCode: null,
      isoCode: null,
      country: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      streetAddress: null,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      DALabels.id.name: id,
      DALabels.name.name: name,
      DALabels.phoneNumber.name: phoneNumber,
      DALabels.geopoint.name: geopoint,
      DALabels.dialCode.name: dialCode,
      DALabels.isoCode.name: isoCode,
      DALabels.country.name: country,
      DALabels.province.name: province,
      DALabels.subProvince.name: subProvince,
      DALabels.subSubProvince.name: subSubProvince,
      DALabels.streetAddress.name: streetAddress,
    };
  }

  bool isValid() {
    if (id != null &&
        name != null &&
        phoneNumber != null &&
        geopoint != null &&
        dialCode != null &&
        isoCode != null &&
        country != null &&
        province != null &&
        subProvince != null &&
        streetAddress != null) return true;
    return false;
  }

  factory DeliveryAddress.fromPreferences({required SharedPreferences prefs}) {
    return DeliveryAddress(
      id: null,
      name: prefs.getString(DALabels.name.name),
      phoneNumber: prefs.getString(DALabels.phoneNumber.name),
      geopoint: null,
      dialCode: prefs.getString(DALabels.dialCode.name),
      isoCode: prefs.getString(DALabels.isoCode.name),
      country: prefs.getString(DALabels.country.name),
      province: prefs.getString(DALabels.province.name),
      subProvince: prefs.getString(DALabels.subProvince.name),
      subSubProvince: prefs.getString(DALabels.subSubProvince.name),
      streetAddress: prefs.getString(DALabels.streetAddress.name),
    );
  }
}

enum DALabels {
  id,
  name,
  phoneNumber,
  geopoint,
  dialCode,
  isoCode,
  country,
  province,
  subProvince,
  subSubProvince,
  streetAddress,
}
