import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class Relation {
  String? type;
  String? uid;
  String? text;
  dynamic lastPostCheckTimestamp;
  dynamic timestamp;

  Relation({
    required this.type,
    required this.uid,
    required this.text,
    required this.lastPostCheckTimestamp,
    required this.timestamp,
  });

  static CollectionReference<Relation> ref({required String userID}) => FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(userID)
      .collection(relationsCollection)
      .withConverter<Relation>(
        fromFirestore: (snapshot, options) => Relation.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  factory Relation.fromFirestore(Map<String, dynamic> doc) {
    return Relation(
      type: getField(doc, ReLabels.type.name, String),
      uid: getField(doc, ReLabels.uid.name, String),
      text: getField(doc, ReLabels.text.name, String),
      lastPostCheckTimestamp: getField(doc, ReLabels.lastPostCheckTimestamp.name, Timestamp),
      timestamp: getField(doc, ReLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      ReLabels.type.name: type,
      ReLabels.uid.name: uid,
      ReLabels.text.name: text,
      ReLabels.lastPostCheckTimestamp.name: lastPostCheckTimestamp,
      ReLabels.timestamp.name: timestamp,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      ReLabels.type.name: type,
      ReLabels.uid.name: uid,
      ReLabels.text.name: text,
      ReLabels.lastPostCheckTimestamp.name: lastPostCheckTimestamp is Timestamp
          ? lastPostCheckTimestamp.millisecondsSinceEpoch
          : null,
      ReLabels.timestamp.name: timestamp is Timestamp ? timestamp.millisecondsSinceEpoch : null,
    };
  }

  factory Relation.fromJson(Map<String, dynamic> doc) {
    final lastPostCheckTimestamp = getField(doc, ReLabels.lastPostCheckTimestamp.name, int);
    final timestamp = getField(doc, ReLabels.timestamp.name, int);
    return Relation(
      type: getField(doc, ReLabels.type.name, String),
      uid: getField(doc, ReLabels.uid.name, String),
      text: getField(doc, ReLabels.text.name, String),
      lastPostCheckTimestamp: lastPostCheckTimestamp is int
          ? Timestamp.fromMillisecondsSinceEpoch(lastPostCheckTimestamp)
          : null,
      timestamp: timestamp is int ? Timestamp.fromMillisecondsSinceEpoch(timestamp) : null,
    );
  }

  bool isValid() {
    if (type != null && uid != null) return true;

    return false;
  }

  bool get isFriend => type == ReTypes.friends.name;
  bool get isFriendRequested => type == ReTypes.friendRequested.name;
  bool get isFriendRequestedBy => type == ReTypes.friendRequestedBy.name;
  bool get isFollowed => type == ReTypes.followed.name;
  bool get isFollowedBy => type == ReTypes.followedBy.name;
  bool get isBlocked => type == ReTypes.blocked.name;
  bool get isBlockedBy => type == ReTypes.blockedBy.name;
}

enum ReTypes {
  friends,
  friendRequested,
  friendRequestedBy,
  followed,
  followedBy,
  blocked,
  blockedBy,
}

enum ReLabels {
  uid,
  text,
  lastPostCheckTimestamp,
  type,
  timestamp,
}
