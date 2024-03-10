import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chat {
  final String? chatID;
  final String? appointmentID;
  String? channelName;
  String? token;
  final String? type;
  final String? callMethod;
  final dynamic usersID;
  final Map<String, dynamic>? lastMessage;
  final String? receiverID;
  final String? receiverName;
  final String? receiverPhoto;
  final String? senderID;
  final String? senderPhoto;
  final String? senderName;
  final Map<String, dynamic>? isSeen;
  final dynamic timestamp;
  final bool? current;
  final dynamic lastEventTimestamp;
  final dynamic createAt;

  static ChatTypes chatTypeFromString({required String? name}) {
    if (name == ChatTypes.personal.name) {
      return ChatTypes.personal;
    }
    if (name == ChatTypes.shopping.name) {
      return ChatTypes.shopping;
    }
    if (name == ChatTypes.translation.name) {
      return ChatTypes.translation;
    }
    if (name == ChatTypes.swapIt.name) {
      return ChatTypes.swapIt;
    }

    return ChatTypes.personal;
  }

  Chat({
    required this.chatID,
    required this.appointmentID,
    required this.channelName,
    required this.token,
    required this.type,
    required this.callMethod,
    required this.usersID,
    required this.lastMessage,
    required this.senderID,
    required this.senderName,
    required this.senderPhoto,
    required this.receiverID,
    required this.receiverName,
    required this.receiverPhoto,
    required this.isSeen,
    required this.timestamp,
    required this.current,
    required this.lastEventTimestamp,
    required this.createAt,
  });

  static const chatsCollection = "chats";

  static CollectionReference<Chat> get ref =>
      FirebaseFirestore.instance.collection(chatsCollection).withConverter<Chat>(
            fromFirestore: (snapshot, options) => Chat.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  factory Chat.fromFirestore(Map<String, dynamic> doc) {
    return Chat(
      chatID: getField(doc, ChatLabels.chatID.name, String),
      appointmentID: getField(doc, ChatLabels.appointmentID.name, String),
      channelName: getField(doc, ChatLabels.channelName.name, String),
      token: getField(doc, ChatLabels.token.name, String),
      type: getField(doc, ChatLabels.type.name, String),
      callMethod: getField(doc, ChatLabels.callMethod.name, String),
      usersID: getField(doc, ChatLabels.usersID.name, List),
      lastMessage: getField(doc, ChatLabels.lastMessage.name, Map<String, dynamic>),
      senderID: getField(doc, ChatLabels.senderID.name, String),
      senderName: getField(doc, ChatLabels.senderName.name, String),
      senderPhoto: getField(doc, ChatLabels.senderPhoto.name, String),
      receiverID: getField(doc, ChatLabels.receiverID.name, String),
      receiverName: getField(doc, ChatLabels.receiverName.name, String),
      receiverPhoto: getField(doc, ChatLabels.receiverPhoto.name, String),
      isSeen: getField(doc, ChatLabels.isSeen.name, Map<String, dynamic>),
      timestamp: getField(doc, ChatLabels.timestamp.name, Timestamp),
      current: getField(doc, ChatLabels.current.name, bool),
      lastEventTimestamp: getField(doc, ChatLabels.lastEventTimestamp.name, Timestamp),
      createAt: getField(doc, ChatLabels.createAt.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      ChatLabels.chatID.name: chatID,
      ChatLabels.appointmentID.name: appointmentID,
      ChatLabels.channelName.name: channelName,
      ChatLabels.token.name: token,
      ChatLabels.type.name: type,
      ChatLabels.callMethod.name: callMethod,
      ChatLabels.usersID.name: usersID,
      ChatLabels.lastMessage.name: lastMessage,
      ChatLabels.senderID.name: senderID,
      ChatLabels.senderName.name: senderName,
      ChatLabels.senderPhoto.name: senderPhoto,
      ChatLabels.receiverID.name: receiverID,
      ChatLabels.receiverName.name: receiverName,
      ChatLabels.receiverPhoto.name: receiverPhoto,
      ChatLabels.isSeen.name: isSeen,
      ChatLabels.timestamp.name: timestamp,
      ChatLabels.current.name: current,
      ChatLabels.lastEventTimestamp.name: lastEventTimestamp,
      ChatLabels.createAt.name: createAt,
    };
  }

  Map<String, dynamic> toCloudFunctions() {
    return {
      ChatLabels.chatID.name: chatID,
      ChatLabels.appointmentID.name: appointmentID,
      ChatLabels.channelName.name: channelName,
      ChatLabels.token.name: token,
      ChatLabels.type.name: type,
      ChatLabels.callMethod.name: callMethod,
      ChatLabels.usersID.name: usersID,
      ChatLabels.lastMessage.name: lastMessage,
      ChatLabels.senderID.name: senderID,
      ChatLabels.senderName.name: senderName,
      ChatLabels.senderPhoto.name: senderPhoto,
      ChatLabels.receiverID.name: receiverID,
      ChatLabels.receiverName.name: receiverName,
      ChatLabels.receiverPhoto.name: receiverPhoto,
      ChatLabels.isSeen.name: isSeen,
      ChatLabels.current.name: current,
      ChatLabels.timestamp.name: null,
      ChatLabels.lastEventTimestamp.name: null,
      ChatLabels.createAt.name: null,
    };
  }

  bool isValid() {
    if (chatID != null && usersID is List) return true;

    return false;
  }

  static storageRef({required String chatID, required String messageID}) {
    return FirebaseStorage.instance.ref().child(chatsCollection).child(chatID).child(messageID);
  }
}

enum ChatTypes { personal, translation, shopping, swapIt }

enum ChatLabels {
  chatID,
  appointmentID,
  channelName,
  token,
  type,
  callMethod,
  usersID,
  lastMessage,
  senderID,
  senderName,
  senderPhoto,
  receiverID,
  receiverName,
  receiverPhoto,
  isSeen,
  timestamp,
  current,
  lastEventTimestamp,
  createAt,
}
