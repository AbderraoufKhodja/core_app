import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class ShoppingOrder {
  final Map<String, dynamic>? lastOrderEvent;
  final String? storeID;
  final List<dynamic>? usersID;
  final String? storeName;
  final String? itemTitle;
  final String? itemID;
  final String? storeOwnerID;
  final String? storePhoneNumber;
  final String? orderID;
  final String? itemDescription;
  final String? itemPhoto;
  final String? storeLogo;
  final String? clientPhoto;
  final String? variantPhoto;
  final num? finalPrice;
  final String? note;
  final String? currency;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? deliveryAddress;
  final Map<String, dynamic>? isSeen;
  final bool? isConfirmed;
  final String? clientName;
  final String? clientPhoneNumber;
  final String? clientID;
  final dynamic timestamp;

  const ShoppingOrder({
    required this.orderID,
    required this.itemID,
    required this.lastOrderEvent,
    required this.clientID,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.storeID,
    required this.usersID,
    required this.storeName,
    required this.itemTitle,
    required this.itemDescription,
    required this.itemPhoto,
    required this.storeLogo,
    required this.clientPhoto,
    required this.variantPhoto,
    required this.finalPrice,
    required this.note,
    required this.currency,
    required this.storeOwnerID,
    required this.storePhoneNumber,
    required this.attributes,
    required this.deliveryAddress,
    required this.isSeen,
    required this.isConfirmed,
    required this.timestamp,
  });

  static CollectionReference<ShoppingOrder> get ref =>
      FirebaseFirestore.instance.collection('orders').withConverter<ShoppingOrder>(
          fromFirestore: (snapshot, options) => ShoppingOrder.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory ShoppingOrder.fromFirestore(Map<String, dynamic> doc) {
    return ShoppingOrder(
      orderID: getField(doc, SOLabels.orderID.name, String),
      itemID: getField(doc, SOLabels.itemID.name, String),
      lastOrderEvent: getField(doc, SOLabels.lastOrderEvent.name, Map<String, dynamic>),
      clientID: getField(doc, SOLabels.clientID.name, String),
      clientName: getField(doc, SOLabels.clientName.name, String),
      clientPhoneNumber: getField(doc, SOLabels.clientPhoneNumber.name, String),
      storeID: getField(doc, SOLabels.storeID.name, String),
      usersID: getField(doc, SOLabels.usersID.name, List),
      storeName: getField(doc, SOLabels.storeName.name, String),
      itemTitle: getField(doc, SOLabels.itemTitle.name, String),
      storeOwnerID: getField(doc, SOLabels.storeOwnerID.name, String),
      storePhoneNumber: getField(doc, SOLabels.storePhoneNumber.name, String),
      itemDescription: getField(doc, SOLabels.itemDescription.name, String),
      itemPhoto: getField(doc, SOLabels.itemPhoto.name, String),
      storeLogo: getField(doc, SOLabels.storeLogo.name, String),
      clientPhoto: getField(doc, SOLabels.clientPhoto.name, String),
      variantPhoto: getField(doc, SOLabels.variantPhoto.name, String),
      finalPrice: getField(doc, SOLabels.finalPrice.name, num),
      note: getField(doc, SOLabels.note.name, String),
      currency: getField(doc, SOLabels.currency.name, String),
      attributes: getField(doc, SOLabels.attributes.name, Map<String, dynamic>),
      deliveryAddress: getField(doc, SOLabels.deliveryAddress.name, Map<String, dynamic>),
      isSeen: getField(doc, SOLabels.isSeen.name, Map<String, dynamic>),
      isConfirmed: getField(doc, SOLabels.isConfirmed.name, bool),
      timestamp: getField(doc, SOLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SOLabels.orderID.name: orderID,
      SOLabels.itemID.name: itemID,
      SOLabels.lastOrderEvent.name: lastOrderEvent,
      SOLabels.clientID.name: clientID,
      SOLabels.clientName.name: clientName,
      SOLabels.clientPhoneNumber.name: clientPhoneNumber,
      SOLabels.storeID.name: storeID,
      SOLabels.usersID.name: usersID,
      SOLabels.storeName.name: storeName,
      SOLabels.itemTitle.name: itemTitle,
      SOLabels.storeOwnerID.name: storeOwnerID,
      SOLabels.storePhoneNumber.name: storePhoneNumber,
      SOLabels.itemDescription.name: itemDescription,
      SOLabels.itemPhoto.name: itemPhoto,
      SOLabels.storeLogo.name: storeLogo,
      SOLabels.clientPhoto.name: clientPhoto,
      SOLabels.variantPhoto.name: variantPhoto,
      SOLabels.finalPrice.name: finalPrice,
      SOLabels.note.name: note,
      SOLabels.currency.name: currency,
      SOLabels.attributes.name: attributes,
      SOLabels.deliveryAddress.name: deliveryAddress,
      SOLabels.isSeen.name: isSeen,
      SOLabels.isConfirmed.name: isConfirmed,
      SOLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (orderID != null &&
        itemID != null &&
        lastOrderEvent != null &&
        clientID != null &&
        clientName != null &&
        storeID != null &&
        usersID != null &&
        storeName != null &&
        itemTitle != null &&
        finalPrice != null &&
        storeOwnerID != null) return true;
    return false;
  }
}

enum SOLabels {
  orderID,
  itemID,
  lastOrderEvent,
  clientID,
  clientName,
  clientPhoneNumber,
  storeID,
  usersID,
  storeName,
  itemTitle,
  itemDescription,
  itemPhoto,
  storeLogo,
  clientPhoto,
  variantPhoto,
  finalPrice,
  note,
  currency,
  storeOwnerID,
  storePhoneNumber,
  attributes,
  deliveryAddress,
  isSeen,
  isConfirmed,
  timestamp,
}
