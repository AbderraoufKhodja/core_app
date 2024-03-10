import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class OrderEvent {
  final String? type;
  final String? orderID;
  final String? orderEventID;
  final GeoPoint? geopoint;
  final String? senderName;
  final String? senderPhoto;
  final String? senderID;
  final String? receiverID;
  final String? storeID;
  final String? itemID;
  final String? text;
  List<dynamic>? photoUrls;
  num? rating;
  // final Map<String, dynamic>? isSeen;
  final dynamic timestamp;

  OrderEvent({
    required this.type,
    required this.orderID,
    required this.orderEventID,
    required this.geopoint,
    required this.senderName,
    required this.senderPhoto,
    required this.senderID,
    required this.receiverID,
    required this.storeID,
    required this.itemID,
    required this.text,
    required this.photoUrls,
    required this.rating,
    // required this.isSeen,
    required this.timestamp,
  });

  static const ordersCollection = "orders";
  static const orderEventsCollection = "orderEvents";

  static CollectionReference<OrderEvent> ref({required String orderID}) {
    return FirebaseFirestore.instance
        .collection(ordersCollection)
        .doc(orderID)
        .collection(orderEventsCollection)
        .withConverter<OrderEvent>(
          fromFirestore: (snapshot, options) => OrderEvent.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        );
  }

  factory OrderEvent.fromFirestore(Map<String, dynamic> doc) {
    return OrderEvent(
      type: getField(doc, OrEvLabels.type.name, String),
      orderID: getField(doc, OrEvLabels.orderID.name, String),
      orderEventID: getField(doc, OrEvLabels.orderEventID.name, String),
      geopoint: getField(doc, OrEvLabels.geopoint.name, GeoPoint),
      senderName: getField(doc, OrEvLabels.senderName.name, String),
      senderPhoto: getField(doc, OrEvLabels.senderPhoto.name, String),
      senderID: getField(doc, OrEvLabels.senderID.name, String),
      receiverID: getField(doc, OrEvLabels.receiverID.name, String),
      storeID: getField(doc, OrEvLabels.storeID.name, String),
      itemID: getField(doc, OrEvLabels.itemID.name, String),
      text: getField(doc, OrEvLabels.text.name, String),
      photoUrls: getField(doc, OrEvLabels.photoUrls.name, List),
      rating: getField(doc, OrEvLabels.rating.name, num),
      // isSeen: getField(doc, OrEvLabels.isSeen.name, Map<String, dynamic>),
      timestamp: getField(doc, OrEvLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      OrEvLabels.type.name: type,
      OrEvLabels.orderID.name: orderID,
      OrEvLabels.orderEventID.name: orderEventID,
      OrEvLabels.geopoint.name: geopoint,
      OrEvLabels.senderName.name: senderName,
      OrEvLabels.senderPhoto.name: senderPhoto,
      OrEvLabels.senderID.name: senderID,
      OrEvLabels.receiverID.name: receiverID,
      OrEvLabels.storeID.name: storeID,
      OrEvLabels.itemID.name: itemID,
      OrEvLabels.text.name: text,
      OrEvLabels.photoUrls.name: photoUrls,
      OrEvLabels.rating.name: rating,
      // OrEvLabels.isSeen.name: isSeen,
      OrEvLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (orderID != null &&
        orderEventID != null &&
        type != null &&
        senderName != null &&
        senderID != null &&
        receiverID != null &&
        itemID != null) return true;

    return false;
  }
}

enum OrEvLabels {
  type,
  orderID,
  orderEventID,
  geopoint,
  senderName,
  senderPhoto,
  senderID,
  receiverID,
  storeID,
  itemID,
  text,
  photoUrls,
  rating,
  // isSeen,
  timestamp,
}

enum OrEvTypes {
  newOrder,
  remindSeller,
  orderReceived,
  refundApplication,
  addReview,
  itemPackaged,
  packageSent,
  confirmOrder,
  acceptRefund,
  declineRefund,
}
