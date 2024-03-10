import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fibali/fibali_core/ui/constants.dart';

class CallApi {
  final _chatRef = FirebaseFirestore.instance.collection(chatsCollection);
  StreamSubscription<QuerySnapshot<Chat>> listenToInComingCall({required String currentUserID}) {
    return Chat.ref
        .where(ChatLabels.receiverID.name, isEqualTo: currentUserID)
        .where(ChatLabels.callMethod.name, isEqualTo: CallMethods.inApp.name)
        .where(ChatLabels.timestamp.name, isGreaterThan: Timestamp.now())
        .orderBy(ChatLabels.timestamp.name, descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenToCallStatus(
      {required String chatID}) {
    return _chatRef.doc(chatID).snapshots().listen((event) {});
  }

  Future<void> postCallToFirestore({
    required Chat chat,
  }) {
    final db = FirebaseFirestore.instance;
    final chatDoc = _chatRef.doc(chat.chatID);
    final messageDoc = chatDoc.collection(messagesCollection).doc();

    final batch = db.batch();
    final message = Message(
      chatID: chat.chatID,
      messageID: messageDoc.id,
      appointmentID: chat.appointmentID,
      channelName: chat.channelName,
      token: chat.token,
      type: MessageTypes.call.name,
      senderID: chat.senderID,
      senderName: chat.senderName,
      senderPhoto: chat.senderPhoto,
      receiverID: chat.receiverID,
      receiverName: chat.receiverName,
      receiverPhoto: chat.receiverPhoto,
      status: CallStatus.ringing.name,
      createAt: chat.createAt,
      timestamp: FieldValue.serverTimestamp(),
      text: null,
      item: null,
      location: null,
      order: null,
      swap: null,
      otherItems: null,
      senderItems: null,
      photoUrl: null,
      photoUrls: null,
    );

    batch
      ..set(chatDoc, chat.toFirestore(), SetOptions(merge: true))
      ..set(messageDoc, message.toFirestore());
    return batch.commit();
  }

  Future<void> updateUserBusyStatusFirestore(
      {required Chat chat, required bool busyCalling}) async {
    if (busyCalling) {
      return SharedPreferences.getInstance()
          .then((prefs) => prefs.setString("currentCallID", chat.chatID!));
    }

    if (!busyCalling) {
      return SharedPreferences.getInstance().then((prefs) => prefs.remove("currentCallID"));
    }
  }

  //Sender
  Future<dynamic> generateCallToken({required Map<String, dynamic> queryMap}) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('createCallsWithToken');

      final response = await callable.call({
        'channelName': queryMap['channelName'],
        'uid': queryMap['uid'],
      });

      debugPrint('fireVideoCallResp: ${response.data}');

      return response.data;
    } catch (error) {
      debugPrint("fireVideoCallError: ${error.toString()}");
    }
  }

  Future<void> updateCallStatus({required Chat chat, required String status}) {
    final db = FirebaseFirestore.instance;
    final chatDoc = _chatRef.doc(chat.chatID);
    final messageDoc = chatDoc.collection(messagesCollection).doc();

    final batch = FirebaseFirestore.instance.batch();
    final message = Message(
      appointmentID: chat.appointmentID,
      chatID: chat.chatID,
      messageID: messageDoc.id,
      type: MessageTypes.call.name,
      token: chat.token,
      channelName: chat.channelName,
      senderID: chat.senderID,
      senderName: chat.senderName,
      senderPhoto: chat.senderPhoto,
      receiverID: chat.receiverID,
      receiverName: chat.receiverName,
      receiverPhoto: chat.receiverPhoto,
      status: status,
      createAt: chat.createAt,
      timestamp: FieldValue.serverTimestamp(),
      item: null,
      location: null,
      order: null,
      swap: null,
      otherItems: null,
      photoUrl: null,
      senderItems: null,
      text: null,
      photoUrls: null,
    );

    batch
      ..set(messageDoc, message.toFirestore())
      ..update(chatDoc, {ChatLabels.lastMessage.name: message.toFirestore()});
    return batch.commit();
  }

  Future<void> endCurrentCall({required Chat call}) {
    return _chatRef.doc(call.chatID).update({ChatLabels.current.name: false});
  }
}
