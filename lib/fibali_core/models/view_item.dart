import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class ViewItem {
  String? uid;
  String? photo;
  String? type;
  String? itemID;
  dynamic timestamp;

  ViewItem({
    required this.uid,
    required this.photo,
    required this.type,
    required this.itemID,
    required this.timestamp,
  });

  static CollectionReference<ViewItem> get ref =>
      FirebaseFirestore.instance.collection(viewsCollection).withConverter<ViewItem>(
            fromFirestore: (snapshot, options) => ViewItem.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  factory ViewItem.fromFirestore(Map<String, dynamic> doc) {
    return ViewItem(
      uid: getField(doc, VLabels.uid.name, String),
      photo: getField(doc, VLabels.photo.name, String),
      type: getField(doc, VLabels.type.name, String),
      itemID: getField(doc, VLabels.itemID.name, String),
      timestamp: getField(doc, VLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      VLabels.uid.name: uid,
      VLabels.photo.name: photo,
      VLabels.type.name: type,
      VLabels.itemID.name: itemID,
      VLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (uid != null && itemID != null && timestamp != null && photo != null && type != null) {
      return true;
    }
    return false;
  }
}

enum VLabels {
  uid,
  photo,
  type,
  itemID,
  timestamp,
}

enum VTypes { shoppingItem, post, swapItem }
