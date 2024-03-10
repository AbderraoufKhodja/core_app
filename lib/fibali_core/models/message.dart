import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class Message {
  final String? chatID;
  final String? appointmentID;
  final String? messageID;
  final String? type;
  final String? status;
  final String? token;
  final String? channelName;
  final String? senderPhoto;
  final String? receiverName;
  final String? receiverPhoto;
  final Map<String, dynamic>? order;
  final Map<String, dynamic>? swap;
  final Map<String, dynamic>? item;
  final Map<String, dynamic>? senderItems;
  final Map<String, dynamic>? otherItems;
  final GeoPoint? location;
  final String? senderName;
  final String? senderID;
  final String? receiverID;
  final String? text;
  String? photoUrl;
  List<dynamic>? photoUrls;
  final dynamic timestamp;
  final dynamic createAt;

  Message({
    required this.chatID,
    required this.appointmentID,
    required this.messageID,
    required this.type,
    required this.status,
    required this.token,
    required this.channelName,
    required this.senderPhoto,
    required this.receiverName,
    required this.receiverPhoto,
    required this.order,
    required this.swap,
    required this.item,
    required this.senderItems,
    required this.otherItems,
    required this.location,
    required this.senderName,
    required this.senderID,
    required this.receiverID,
    required this.text,
    required this.photoUrl,
    required this.photoUrls,
    required this.timestamp,
    required this.createAt,
  });

  static const chatsCollection = "chats";
  static const messagesCollection = "messages";

  static CollectionReference<Message> ref({required String chatID}) {
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .withConverter<Message>(
          fromFirestore: (snapshot, options) =>
              Message.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        );
  }

  factory Message.fromFirestore(Map<String, dynamic> doc) {
    return Message(
      chatID: getField(doc, MessageLabels.chatID.name, String),
      appointmentID: getField(doc, MessageLabels.appointmentID.name, String),
      messageID: getField(doc, MessageLabels.messageID.name, String),
      type: getField(doc, MessageLabels.type.name, String),
      status: getField(doc, MessageLabels.status.name, String),
      token: getField(doc, MessageLabels.token.name, String),
      channelName: getField(doc, MessageLabels.channelName.name, String),
      senderPhoto: getField(doc, MessageLabels.senderPhoto.name, String),
      receiverName: getField(doc, MessageLabels.receiverName.name, String),
      receiverPhoto: getField(doc, MessageLabels.receiverPhoto.name, String),
      order: getField(doc, MessageLabels.order.name, Map<String, dynamic>),
      swap: getField(doc, MessageLabels.swap.name, Map<String, dynamic>),
      item: getField(doc, MessageLabels.item.name, Map<String, dynamic>),
      senderItems:
          getField(doc, MessageLabels.senderItems.name, Map<String, dynamic>),
      otherItems:
          getField(doc, MessageLabels.otherItems.name, Map<String, dynamic>),
      location: getField(doc, MessageLabels.location.name, GeoPoint),
      senderName: getField(doc, MessageLabels.senderName.name, String),
      senderID: getField(doc, MessageLabels.senderID.name, String),
      receiverID: getField(doc, MessageLabels.receiverID.name, String),
      text: getField(doc, MessageLabels.text.name, String),
      photoUrl: getField(doc, MessageLabels.photoUrl.name, String),
      photoUrls: getField(doc, MessageLabels.photoUrls.name, List<dynamic>),
      timestamp: getField(doc, MessageLabels.timestamp.name, Timestamp),
      createAt: getField(doc, MessageLabels.createAt.name, Timestamp),
    );
  }

  bool isValid() {
    if (chatID != null &&
        messageID != null &&
        type != null &&
        senderName != null &&
        senderID != null &&
        receiverID != null &&
        (order != null ||
            swap != null ||
            item != null ||
            senderItems != null ||
            otherItems != null ||
            location != null ||
            text != null ||
            photoUrl != null ||
            photoUrls != null)) return true;

    return false;
  }

  Map<String, dynamic> toFirestore() {
    return {
      MessageLabels.chatID.name: chatID,
      MessageLabels.appointmentID.name: appointmentID,
      MessageLabels.messageID.name: messageID,
      MessageLabels.type.name: type,
      MessageLabels.status.name: status,
      MessageLabels.token.name: token,
      MessageLabels.channelName.name: channelName,
      MessageLabels.senderPhoto.name: senderPhoto,
      MessageLabels.receiverName.name: receiverName,
      MessageLabels.receiverPhoto.name: receiverPhoto,
      MessageLabels.order.name: order,
      MessageLabels.swap.name: swap,
      MessageLabels.item.name: item,
      MessageLabels.senderItems.name: senderItems,
      MessageLabels.otherItems.name: otherItems,
      MessageLabels.location.name: location,
      MessageLabels.senderName.name: senderName,
      MessageLabels.senderID.name: senderID,
      MessageLabels.receiverID.name: receiverID,
      MessageLabels.text.name: text,
      MessageLabels.photoUrl.name: photoUrl,
      MessageLabels.photoUrls.name: photoUrls,
      MessageLabels.timestamp.name: timestamp,
      MessageLabels.createAt.name: createAt,
    };
  }
}

enum MessageLabels {
  chatID,
  appointmentID,
  messageID,
  type,
  status,
  token,
  channelName,
  senderPhoto,
  receiverName,
  receiverPhoto,
  order,
  swap,
  item,
  senderItems,
  otherItems,
  location,
  senderName,
  senderID,
  receiverID,
  text,
  photoUrl,
  photoUrls,
  timestamp,
  createAt,
}

enum MessageTypes { photo, text, location, newSwap, swapAccepted, call }
