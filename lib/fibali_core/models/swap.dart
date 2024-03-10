import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class Swap {
  final Map<String, dynamic>? lastSwapEvent;
  final String? receiverID;
  final List<dynamic>? usersID;
  final Map<String, dynamic>? receiverItemsID;
  final Map<String, dynamic>? senderItemsID;
  final String? receiverName;
  final String? swapID;
  final String? receiverPhoto;
  final String? senderPhoto;
  final num? finalPrice;
  final String? note;
  final String? currency;
  final Map<String, dynamic>? isSeen;
  final String? senderName;
  final String? senderID;
  final dynamic timestamp;

  const Swap({
    required this.swapID,
    required this.lastSwapEvent,
    required this.senderID,
    required this.senderName,
    required this.receiverID,
    required this.usersID,
    required this.senderItemsID,
    required this.receiverItemsID,
    required this.receiverName,
    required this.receiverPhoto,
    required this.senderPhoto,
    required this.finalPrice,
    required this.note,
    required this.currency,
    required this.isSeen,
    required this.timestamp,
  });

  static CollectionReference<Swap> get ref =>
      FirebaseFirestore.instance.collection('swaps').withConverter<Swap>(
          fromFirestore: (snapshot, options) => Swap.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory Swap.fromFirestore(Map<String, dynamic> doc) {
    return Swap(
      swapID: getField(doc, SwLabels.swapID.name, String),
      lastSwapEvent: getField(doc, SwLabels.lastSwapEvent.name, Map<String, dynamic>),
      senderID: getField(doc, SwLabels.senderID.name, String),
      senderName: getField(doc, SwLabels.senderName.name, String),
      receiverID: getField(doc, SwLabels.receiverID.name, String),
      usersID: getField(doc, SwLabels.usersID.name, List),
      senderItemsID: getField(doc, SwLabels.senderItemsID.name, Map<String, dynamic>),
      receiverItemsID: getField(doc, SwLabels.receiverItemsID.name, Map<String, dynamic>),
      receiverName: getField(doc, SwLabels.receiverName.name, String),
      receiverPhoto: getField(doc, SwLabels.receiverPhoto.name, String),
      senderPhoto: getField(doc, SwLabels.senderPhoto.name, String),
      finalPrice: getField(doc, SwLabels.finalPrice.name, num),
      note: getField(doc, SwLabels.note.name, String),
      currency: getField(doc, SwLabels.currency.name, String),
      isSeen: getField(doc, SwLabels.isSeen.name, Map<String, dynamic>),
      timestamp: getField(doc, SwLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SwLabels.swapID.name: swapID,
      SwLabels.lastSwapEvent.name: lastSwapEvent,
      SwLabels.senderID.name: senderID,
      SwLabels.senderName.name: senderName,
      SwLabels.receiverID.name: receiverID,
      SwLabels.usersID.name: usersID,
      SwLabels.senderItemsID.name: senderItemsID,
      SwLabels.receiverItemsID.name: receiverItemsID,
      SwLabels.receiverName.name: receiverName,
      SwLabels.receiverPhoto.name: receiverPhoto,
      SwLabels.senderPhoto.name: senderPhoto,
      SwLabels.finalPrice.name: finalPrice,
      SwLabels.note.name: note,
      SwLabels.currency.name: currency,
      SwLabels.isSeen.name: isSeen,
      SwLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (swapID != null &&
        lastSwapEvent != null &&
        senderID != null &&
        senderName != null &&
        receiverID != null &&
        usersID != null &&
        senderItemsID != null &&
        receiverItemsID != null &&
        receiverName != null) return true;

    return false;
  }
}

enum SwLabels {
  swapID,
  lastSwapEvent,
  senderID,
  senderName,
  receiverID,
  usersID,
  senderItemsID,
  receiverItemsID,
  receiverName,
  receiverPhoto,
  senderPhoto,
  finalPrice,
  note,
  currency,
  isSeen,
  timestamp,
}
