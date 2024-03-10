import 'package:fibali/fibali_core/models/app_user.dart';

class DLParams {
  String? uid;
  String? photo;
  String? type;
  String? itemID;

  DLParams({
    required this.uid,
    required this.photo,
    required this.type,
    required this.itemID,
  });

  factory DLParams.fromFirestore(Map<String, dynamic> doc) {
    return DLParams(
      uid: getField(doc, DLLabels.uid.name, String),
      photo: getField(doc, DLLabels.photo.name, String),
      type: getField(doc, DLLabels.type.name, String),
      itemID: getField(doc, DLLabels.itemID.name, String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DLLabels.type.name: type,
      DLLabels.uid.name: uid,
      DLLabels.photo.name: photo,
      DLLabels.itemID.name: itemID,
    };
  }

  bool isValid() {
    if (uid != null && itemID != null && type != null) {
      return true;
    }
    return false;
  }
}

enum DLLabels {
  uid,
  photo,
  type,
  itemID,
}

enum DLTypes { app, shoppingItem, post, swapItem }
