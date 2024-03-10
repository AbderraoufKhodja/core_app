import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class Favorite {
  String? uid;
  String? photo;
  String? type;
  String? itemID;
  dynamic timestamp;

  Favorite({
    required this.uid,
    required this.photo,
    required this.type,
    required this.itemID,
    required this.timestamp,
  });

  static get ref => FirebaseFirestore.instance.collection('favorites').withConverter<Favorite>(
        fromFirestore: (snapshot, options) => Favorite.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  factory Favorite.fromFirestore(Map<String, dynamic> doc) {
    return Favorite(
      uid: getField(doc, 'uid', String),
      photo: getField(doc, 'photo', String),
      type: getField(doc, 'type', String),
      itemID: getField(doc, 'itemID', String),
      timestamp: getField(doc, 'timestamp', Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'photo': photo,
      'type': type,
      'itemID': itemID,
      'timestamp': timestamp,
    };
  }

  bool isValid() {
    if (uid != null && itemID != null && timestamp != null && photo != null && type != null) {
      return true;
    }
    return false;
  }
}
