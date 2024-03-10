import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslatorAppointment {
  final String? appointmentID;
  final List<dynamic>? usersID;
  final List<dynamic>? languagesCodings;
  final Map<String, dynamic>? lastAppointmentEvent;
  final String? interID;
  final String? interName;
  final String? interPhoto;
  final String? interPhoneNumber;
  final String? clientID;
  final String? clientName;
  final String? clientPhoto;
  final String? clientPhoneNumber;
  final String? subject;
  final String? type;
  final String? method;
  final List<dynamic>? interFrom;
  final List<dynamic>? interTo;
  final String? interClass;
  final bool? asap;
  final bool? isActive;
  final String? dialCode;
  final String? isoCode;
  final String? province;
  final String? subProvince;
  final String? subSubProvince;
  final String? streetAddress;
  final dynamic timestamp;
  final dynamic startDateTime;
  final dynamic endDateTime;

  const TranslatorAppointment({
    required this.appointmentID,
    required this.lastAppointmentEvent,
    required this.clientID,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.interID,
    required this.usersID,
    required this.languagesCodings,
    required this.interName,
    required this.interPhoto,
    required this.clientPhoto,
    required this.subject,
    required this.type,
    required this.method,
    required this.interFrom,
    required this.interTo,
    required this.interClass,
    required this.asap,
    required this.isActive,
    required this.interPhoneNumber,
    required this.dialCode,
    required this.isoCode,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.streetAddress,
    required this.timestamp,
    required this.startDateTime,
    required this.endDateTime,
  });

  static ref() => FirebaseFirestore.instance
      .collection('translatorAppointments')
      .withConverter<TranslatorAppointment>(
        fromFirestore: (snapshot, options) => TranslatorAppointment.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  factory TranslatorAppointment.fromFirestore(Map<String, dynamic> doc) {
    return TranslatorAppointment(
      appointmentID: getField(doc, TALabels.appointmentID.name, String),
      lastAppointmentEvent: getField(doc, TALabels.lastAppointmentEvent.name, Map<String, dynamic>),
      clientID: getField(doc, TALabels.clientID.name, String),
      clientName: getField(doc, TALabels.clientName.name, String),
      clientPhoneNumber: getField(doc, TALabels.clientPhoneNumber.name, String),
      interID: getField(doc, TALabels.interID.name, String),
      usersID: getField(doc, TALabels.usersID.name, List),
      languagesCodings: getField(doc, TALabels.languagesCodings.name, List),
      interName: getField(doc, TALabels.interName.name, String),
      interPhoneNumber: getField(doc, TALabels.interPhoneNumber.name, String),
      interPhoto: getField(doc, TALabels.interPhoto.name, String),
      clientPhoto: getField(doc, TALabels.clientPhoto.name, String),
      subject: getField(doc, TALabels.subject.name, String),
      type: getField(doc, TALabels.type.name, String),
      method: getField(doc, TALabels.method.name, String),
      interFrom: getField(doc, TALabels.interFrom.name, List),
      interTo: getField(doc, TALabels.interTo.name, List),
      interClass: getField(doc, TALabels.interClass.name, String),
      asap: getField(doc, TALabels.asap.name, bool),
      isActive: getField(doc, TALabels.isActive.name, bool),
      dialCode: getField(doc, TALabels.dialCode.name, String),
      isoCode: getField(doc, TALabels.isoCode.name, String),
      province: getField(doc, TALabels.province.name, String),
      subProvince: getField(doc, TALabels.subProvince.name, String),
      subSubProvince: getField(doc, TALabels.subSubProvince.name, String),
      streetAddress: getField(doc, TALabels.streetAddress.name, String),
      timestamp: getField(doc, TALabels.timestamp.name, Timestamp),
      startDateTime: getField(doc, TALabels.startDateTime.name, Timestamp),
      endDateTime: getField(doc, TALabels.endDateTime.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      TALabels.appointmentID.name: appointmentID,
      TALabels.lastAppointmentEvent.name: lastAppointmentEvent,
      TALabels.clientID.name: clientID,
      TALabels.clientName.name: clientName,
      TALabels.clientPhoneNumber.name: clientPhoneNumber,
      TALabels.interID.name: interID,
      TALabels.usersID.name: usersID,
      TALabels.languagesCodings.name: languagesCodings,
      TALabels.interName.name: interName,
      TALabels.interPhoneNumber.name: interPhoneNumber,
      TALabels.interPhoto.name: interPhoto,
      TALabels.clientPhoto.name: clientPhoto,
      TALabels.subject.name: subject,
      TALabels.type.name: type,
      TALabels.method.name: method,
      TALabels.interFrom.name: interFrom,
      TALabels.interTo.name: interTo,
      TALabels.interClass.name: interClass,
      TALabels.asap.name: asap,
      TALabels.isActive.name: isActive,
      TALabels.dialCode.name: dialCode,
      TALabels.isoCode.name: isoCode,
      TALabels.province.name: province,
      TALabels.subProvince.name: subProvince,
      TALabels.subSubProvince.name: subSubProvince,
      TALabels.streetAddress.name: streetAddress,
      TALabels.timestamp.name: timestamp,
      TALabels.startDateTime.name: startDateTime,
      TALabels.endDateTime.name: endDateTime,
    };
  }

  bool isValid() {
    if (appointmentID != null && clientID != null) return true;

    print('Translator model not valid!');

    return false;
  }

  factory TranslatorAppointment.fromPreferences({required SharedPreferences prefs}) {
    return TranslatorAppointment(
      appointmentID: null,
      clientID: null,
      clientName: prefs.getString('clientName'),
      clientPhoneNumber: prefs.getString('clientPhoneNumber'),
      interID: null,
      usersID: null,
      languagesCodings: null,
      interName: null,
      interPhoneNumber: null,
      interPhoto: null,
      clientPhoto: null,
      lastAppointmentEvent: null,
      subject: prefs.getString('subject'),
      type: prefs.getString('type'),
      method: prefs.getString('method'),
      interFrom: prefs.getStringList('interFrom'),
      interTo: prefs.getStringList('interTo'),
      interClass: prefs.getString('interClass'),
      asap: prefs.getBool('asap'),
      isActive: prefs.getBool('isActive'),
      dialCode: prefs.getString("dialCode"),
      isoCode: prefs.getString("isoCode"),
      province: prefs.getString("province"),
      subProvince: prefs.getString("subProvince"),
      subSubProvince: prefs.getString("subSubProvince"),
      streetAddress: prefs.getString("streetAddress"),
      endDateTime: null,
      startDateTime: null,
      timestamp: null,
    );
  }
}

/// Translation appointment type: ["online", "offline"]
enum TAType { online, offline }

enum TALabels {
  appointmentID,
  usersID,
  languagesCodings,
  lastAppointmentEvent,
  interID,
  interName,
  interPhoto,
  interPhoneNumber,
  clientID,
  clientName,
  clientPhoto,
  clientPhoneNumber,
  subject,
  type,
  method,
  interFrom,
  interTo,
  interClass,
  asap,
  isActive,

  dialCode,
  isoCode,
  province,
  subProvince,
  subSubProvince,
  streetAddress,
  timestamp,
  startDateTime,
  endDateTime,
}

enum TAStates {
  newTranslatorAppointment,
  translatorApplication,
  translatorHired,
  canceledByClient,
  canceledByTranslator,
  complete
}
