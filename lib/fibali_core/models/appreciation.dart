import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';

class Appreciation {
  String? itemID;
  String? interestBy;
  String? uid;
  String? state;
  dynamic timestamp;

  Appreciation({
    required this.itemID,
    required this.interestBy,
    required this.uid,
    required this.state,
    required this.timestamp,
  });

  factory Appreciation.fromFirestore(Map<String, dynamic> doc) {
    return Appreciation(
      itemID: getField(doc, ApLabels.itemID.name, String),
      interestBy: getField(doc, ApLabels.interestBy.name, String),
      uid: getField(doc, ApLabels.uid.name, String),
      state: getField(doc, ApLabels.state.name, String),
      timestamp: getField(doc, ApLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      ApLabels.itemID.name: itemID,
      ApLabels.interestBy.name: interestBy,
      ApLabels.uid.name: uid,
      ApLabels.state.name: state,
      ApLabels.timestamp.name: timestamp,
    };
  }

  Map<String, Object?> toJson() {
    return {
      ApLabels.itemID.name: itemID,
      ApLabels.interestBy.name: interestBy,
      ApLabels.uid.name: uid,
      ApLabels.state.name: state,
      if (timestamp is Timestamp) ApLabels.timestamp.name: timestamp.toDate().toIso8601String(),
    };
  }

  bool isValid() {
    if (interestBy != null && uid != null && itemID != null) return true;

    return false;
  }

  static CollectionReference<Appreciation> get ref =>
      FirebaseFirestore.instance.collection('usersInterest').withConverter<Appreciation>(
            fromFirestore: (snapshot, options) => Appreciation.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  factory Appreciation.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Appreciation(
      itemID: getField(doc, ApLabels.itemID.name, String) as String,
      interestBy: getField(doc, ApLabels.interestBy.name, String) as String,
      uid: getField(doc, ApLabels.uid.name, String) as String,
      state: getField(doc, ApLabels.state.name, String) as String,
      timestamp:
          (getField(doc, ApLabels.timestamp.name, Timestamp) ?? Timestamp.now()) as Timestamp,
    );
  }
}

enum ApLabels {
  itemID,
  interestBy,
  uid,
  state,
  timestamp,
}

enum ApTypes { dislike, like }
