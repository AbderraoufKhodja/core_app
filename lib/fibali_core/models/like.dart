import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class Like {
  String? type;
  String? itemID;
  String? itemOwnerID;

  String? uid;
  List<dynamic>? friends;
  List<dynamic>? followers;
  dynamic timestamp;

  Like({
    required this.type,
    required this.itemID,
    required this.itemOwnerID,
    required this.uid,
    required this.friends,
    required this.followers,
    required this.timestamp,
  });

  factory Like.fromFirestore(Map<String, dynamic> doc) {
    return Like(
      type: getField(doc, LiLabels.type.name, String),
      itemID: getField(doc, LiLabels.itemID.name, String),
      itemOwnerID: getField(doc, LiLabels.itemOwnerID.name, String),
      uid: getField(doc, LiLabels.uid.name, String),
      friends: getField(doc, LiLabels.friends.name, String),
      followers: getField(doc, LiLabels.followers.name, String),
      timestamp: getField(doc, LiLabels.timestamp.name, Timestamp),
    );
  }

  static CollectionReference<Like> get ref =>
      FirebaseFirestore.instance.collection(likesCollection).withConverter<Like>(
            fromFirestore: (snapshot, options) => Like.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  Map<String, dynamic> toFirestore() {
    return {
      LiLabels.type.name: type,
      LiLabels.itemID.name: itemID,
      LiLabels.itemOwnerID.name: itemOwnerID,
      LiLabels.uid.name: uid,
      LiLabels.friends.name: friends,
      LiLabels.followers.name: followers,
      LiLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (type != null && uid != null && itemID != null && itemOwnerID != null) return true;

    return false;
  }
}

enum LiLabels {
  type,
  itemID,
  itemOwnerID,
  uid,
  friends,
  followers,
  timestamp,
}

enum LiTypes { postItem, commentItem, shoppingItem, swapItem }
