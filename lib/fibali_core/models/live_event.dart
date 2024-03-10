import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class LiveEvent {
  final String? postID;
  final String? relatedItemType;
  final String? relatedItemRef;
  final String? liveEventID;
  final String? type;
  final String? status;
  final String? token;
  final String? channelName;
  final String? senderPhoto;
  final Map<String, dynamic>? order;
  final Map<String, dynamic>? swap;
  final Map<String, dynamic>? item;
  final Map<String, dynamic>? senderItems;
  final Map<String, dynamic>? otherItems;
  final GeoPoint? location;
  final String? senderName;
  final String? senderID;
  final String? text;
  List<dynamic>? photoUrls;
  final dynamic timestamp;
  final dynamic createAt;

  LiveEvent({
    required this.postID,
    required this.relatedItemType,
    required this.relatedItemRef,
    required this.liveEventID,
    required this.type,
    required this.status,
    required this.token,
    required this.channelName,
    required this.senderPhoto,
    required this.order,
    required this.swap,
    required this.item,
    required this.senderItems,
    required this.otherItems,
    required this.location,
    required this.senderName,
    required this.senderID,
    required this.text,
    required this.photoUrls,
    required this.timestamp,
    required this.createAt,
  });

  static const postsCollection = "posts";
  static const liveEventsCollection = "liveEvents";

  static CollectionReference<LiveEvent> ref({required String postID}) {
    return FirebaseFirestore.instance
        .collection(postsCollection)
        .doc(postID)
        .collection(liveEventsCollection)
        .withConverter<LiveEvent>(
          fromFirestore: (snapshot, options) => LiveEvent.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        );
  }

  factory LiveEvent.fromFirestore(Map<String, dynamic> doc) {
    return LiveEvent(
      postID: getField(doc, LELabels.postID.name, String),
      relatedItemType: getField(doc, LELabels.relatedItemType.name, String),
      relatedItemRef: getField(doc, LELabels.relatedItemRef.name, String),
      liveEventID: getField(doc, LELabels.liveEventID.name, String),
      type: getField(doc, LELabels.type.name, String),
      status: getField(doc, LELabels.status.name, String),
      token: getField(doc, LELabels.token.name, String),
      channelName: getField(doc, LELabels.channelName.name, String),
      senderPhoto: getField(doc, LELabels.senderPhoto.name, String),
      order: getField(doc, LELabels.order.name, Map<String, dynamic>),
      swap: getField(doc, LELabels.swap.name, Map<String, dynamic>),
      item: getField(doc, LELabels.item.name, Map<String, dynamic>),
      senderItems: getField(doc, LELabels.senderItems.name, Map<String, dynamic>),
      otherItems: getField(doc, LELabels.otherItems.name, Map<String, dynamic>),
      location: getField(doc, LELabels.location.name, GeoPoint),
      senderName: getField(doc, LELabels.senderName.name, String),
      senderID: getField(doc, LELabels.senderID.name, String),
      text: getField(doc, LELabels.text.name, String),
      photoUrls: getField(doc, LELabels.photoUrls.name, List<dynamic>),
      timestamp: getField(doc, LELabels.timestamp.name, Timestamp),
      createAt: getField(doc, LELabels.createAt.name, Timestamp),
    );
  }

  bool isValid() {
    if (postID != null &&
        liveEventID != null &&
        type != null &&
        senderName != null &&
        senderID != null &&
        (order != null ||
            swap != null ||
            item != null ||
            senderItems != null ||
            otherItems != null ||
            location != null ||
            text != null ||
            photoUrls != null)) return true;

    return false;
  }

  Map<String, dynamic> toFirestore() {
    return {
      LELabels.postID.name: postID,
      LELabels.relatedItemType.name: relatedItemType,
      LELabels.relatedItemRef.name: relatedItemRef,
      LELabels.liveEventID.name: liveEventID,
      LELabels.type.name: type,
      LELabels.status.name: status,
      LELabels.token.name: token,
      LELabels.channelName.name: channelName,
      LELabels.senderPhoto.name: senderPhoto,
      LELabels.order.name: order,
      LELabels.swap.name: swap,
      LELabels.item.name: item,
      LELabels.senderItems.name: senderItems,
      LELabels.otherItems.name: otherItems,
      LELabels.location.name: location,
      LELabels.senderName.name: senderName,
      LELabels.senderID.name: senderID,
      LELabels.text.name: text,
      LELabels.photoUrls.name: photoUrls,
      LELabels.timestamp.name: timestamp,
      LELabels.createAt.name: createAt,
    };
  }
}

enum LELabels {
  postID,
  relatedItemType,
  relatedItemRef,
  liveEventID,
  type,
  status,
  token,
  channelName,
  senderPhoto,
  order,
  swap,
  item,
  senderItems,
  otherItems,
  location,
  senderName,
  senderID,
  text,
  photoUrls,
  timestamp,
  createAt,
}

enum LiveEventTypes { live }

// Q: what is the Live streaming lifecycle when waiting for the the author to start the live stream?

enum LiveEventStatus { scheduled, starting, canceled, onGoing, ended }
