import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class SwapEvent {
  final String? type;
  final String? swapID;
  final GeoPoint? geopoint;
  final String? senderName;
  final String? senderPhoto;
  final String? senderID;
  final String? receiverID;
  final String? text;
  final Map<String, dynamic>? receiverItemsID;
  final Map<String, dynamic>? senderItemsID;
  List<dynamic>? photoUrls;
  num? rating;
  final bool? isSeen;
  final dynamic timestamp;

  SwapEvent({
    required this.type,
    required this.swapID,
    required this.geopoint,
    required this.senderName,
    required this.senderPhoto,
    required this.senderID,
    required this.receiverID,
    required this.text,
    required this.photoUrls,
    required this.receiverItemsID,
    required this.senderItemsID,
    required this.rating,
    required this.isSeen,
    required this.timestamp,
  });

  static CollectionReference<SwapEvent> ref({required String swapID}) => FirebaseFirestore.instance
      .collection('swaps')
      .doc(swapID)
      .collection('swapEvents')
      .withConverter<SwapEvent>(
          fromFirestore: (snapshot, options) => SwapEvent.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory SwapEvent.fromFirestore(Map<String, dynamic> doc) {
    return SwapEvent(
      type: getField(doc, SELabels.type.name, String),
      swapID: getField(doc, SELabels.swapID.name, String),
      geopoint: getField(doc, SELabels.geopoint.name, GeoPoint),
      senderName: getField(doc, SELabels.senderName.name, String),
      senderPhoto: getField(doc, SELabels.senderPhoto.name, String),
      senderID: getField(doc, SELabels.senderID.name, String),
      receiverID: getField(doc, SELabels.receiverID.name, String),
      text: getField(doc, SELabels.text.name, String),
      photoUrls: getField(doc, SELabels.photoUrls.name, List),
      receiverItemsID: getField(doc, SELabels.receiverItemsID.name, Map<String, dynamic>),
      senderItemsID: getField(doc, SELabels.senderItemsID.name, Map<String, dynamic>),
      rating: getField(doc, SELabels.rating.name, num),
      isSeen: getField(doc, SELabels.isSeen.name, bool),
      timestamp: getField(doc, SELabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SELabels.type.name: type,
      SELabels.swapID.name: swapID,
      SELabels.geopoint.name: geopoint,
      SELabels.senderName.name: senderName,
      SELabels.senderPhoto.name: senderPhoto,
      SELabels.senderID.name: senderID,
      SELabels.receiverID.name: receiverID,
      SELabels.text.name: text,
      SELabels.photoUrls.name: photoUrls,
      SELabels.receiverItemsID.name: receiverItemsID,
      SELabels.senderItemsID.name: senderItemsID,
      SELabels.rating.name: rating,
      SELabels.isSeen.name: isSeen,
      SELabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (swapID != null &&
        type != null &&
        senderName != null &&
        senderID != null &&
        receiverID != null) return true;

    return false;
  }
}

enum SETypes {
  newSwap,
  swapDeclined,
  swapAccepted,
  swapCanceled,
  addSwapReview,
}

enum SELabels {
  type,
  swapID,
  geopoint,
  senderName,
  senderPhoto,
  senderID,
  receiverID,
  text,
  photoUrls,
  receiverItemsID,
  senderItemsID,
  rating,
  isSeen,
  timestamp,
}
