import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class PostMessage {
  final String? type;
  final String? postID;
  final String? senderName;
  final String? senderID;
  final String? text;
  final bool? isSeen;
  final dynamic timestamp;

  const PostMessage({
    required this.type,
    required this.postID,
    required this.senderName,
    required this.senderID,
    required this.text,
    required this.isSeen,
    required this.timestamp,
  });

  factory PostMessage.fromDocument(Map<String, dynamic> data) {
    return PostMessage(
      type: getField(data, 'type', String),
      postID: getField(data, 'postID', String),
      senderName: getField(data, 'senderName', String),
      senderID: getField(data, 'senderID', String),
      text: getField(data, 'text', String),
      isSeen: getField(data, 'isSeen', bool),
      timestamp: getField(data, 'timestamp', Timestamp),
    );
  }

  bool isValid() {
    if (postID != null && type != null && senderName != null && senderID != null && text != null)
      return true;
    return false;
  }
}
