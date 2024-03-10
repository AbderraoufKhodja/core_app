import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class AppointmentEvent {
  final String? type;
  final String? appointmentID;
  final String? clientName;
  final String? clientID;
  final String? interID;
  final num? rating;
  final bool? isSeen;
  final dynamic timestamp;

  AppointmentEvent({
    required this.type,
    required this.appointmentID,
    required this.clientName,
    required this.clientID,
    required this.interID,
    required this.rating,
    required this.isSeen,
    required this.timestamp,
  });

  static ref({required String appointmentID}) => FirebaseFirestore.instance
      .collection('translatorAppointments')
      .doc(appointmentID)
      .collection('appointmentEvents')
      .withConverter<AppointmentEvent>(
        fromFirestore: (snapshot, options) => AppointmentEvent.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  factory AppointmentEvent.fromFirestore(Map<String, dynamic> doc) {
    return AppointmentEvent(
      type: getField(doc, AELabels.type.name, String),
      appointmentID: getField(doc, AELabels.appointmentID.name, String),
      clientName: getField(doc, AELabels.clientName.name, String),
      clientID: getField(doc, AELabels.clientID.name, String),
      interID: getField(doc, AELabels.interID.name, String),
      rating: getField(doc, AELabels.rating.name, num),
      isSeen: getField(doc, AELabels.isSeen.name, bool),
      timestamp: getField(doc, AELabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AELabels.type.name: type,
      AELabels.appointmentID.name: appointmentID,
      AELabels.clientName.name: clientName,
      AELabels.clientID.name: clientID,
      AELabels.interID.name: interID,
      AELabels.rating.name: rating,
      AELabels.isSeen.name: isSeen,
      AELabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (appointmentID != null &&
        type != null &&
        clientName != null &&
        clientID != null &&
        interID != null) return true;

    return false;
  }
}

enum AELabels {
  type,
  appointmentID,
  clientName,
  clientID,
  interID,
  rating,
  isSeen,
  timestamp,
}
