import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';
import 'package:translator/translator.dart';

import './bloc.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final _db = FirebaseFirestore.instance;
  final translator = GoogleTranslator();

  MessagingBloc() : super(MessagingInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(MessagingLoadingState());
      final Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream = BehaviorSubject()
        ..addStream(
          await getMessages(
            chatID: event.chatID,
            prevDoc: event.prevDoc,
          ),
        );
      emit(MessagingLoadedState(messagingStream: messagesStream));
    });
  }

  Future<void> markAsSeen({
    required String currentUserID,
    required String chatID,
  }) {
    return _db.collection(chatsCollection).doc(chatID).update({
      'isSeen.$currentUserID': true,
    });
  }

  static Future<void> sendMessage({
    required ChatTypes type,
    required Message message,
    required String chatID,
    required String senderID,
    required String senderName,
    required String? senderPhoto,
    required String receiverName,
    required String? receiverPhoto,
    required String receiverID,
    required List<XFile>? photoFiles,
  }) async {
    FAC.logEvent(FAEvent.send_message);

    final writeBatch = FirebaseFirestore.instance.batch();
    final chatRef = Chat.ref.doc(chatID);
    final messageRef = Message.ref(chatID: chatID).doc();

    if (photoFiles != null) {
      final photoUrls = await Utils.uploadPhotos(
        ref: Chat.storageRef(chatID: chatID, messageID: messageRef.id),
        files: photoFiles,
        needModeration: false,
      );
      message.photoUrls = photoUrls;

      final uploadMessage = Message(
        type: MessageTypes.photo.name,
        chatID: chatID,
        messageID: messageRef.id,
        senderName: message.senderName,
        senderID: message.senderID,
        location: null,
        senderItems: null,
        otherItems: null,
        item: null,
        order: null,
        swap: null,
        text: null,
        photoUrl: message.photoUrls![0],
        receiverID: receiverID,
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        receiverName: null,
        receiverPhoto: null,
        senderPhoto: message.senderPhoto,
        status: null,
        token: null,
        photoUrls: message.photoUrls,
      );

      final chat = Chat(
        type: type.name,
        chatID: chatID,
        usersID: FieldValue.arrayUnion([receiverID, senderID]),
        lastMessage: uploadMessage.toFirestore(),
        senderID: senderID,
        senderName: senderName,
        senderPhoto: senderPhoto,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        receiverID: receiverID,
        isSeen: {receiverID: false},
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        token: null,
        callMethod: null,
        lastEventTimestamp: FieldValue.serverTimestamp(),
        current: null,
      );

      writeBatch
        ..set<Chat>(chatRef, chat, SetOptions(merge: true))
        ..set<Message>(messageRef, uploadMessage)
        ..commit();
    }

    if (message.text != null) {
      final uploadMessage = Message(
        type: MessageTypes.text.name,
        chatID: chatID,
        messageID: messageRef.id,
        senderName: message.senderName,
        senderID: message.senderID,
        location: null,
        senderItems: null,
        otherItems: null,
        item: null,
        order: null,
        swap: null,
        text: message.text,
        photoUrl: null,
        receiverID: receiverID,
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        receiverName: null,
        receiverPhoto: null,
        senderPhoto: message.senderPhoto,
        status: null,
        token: null,
        photoUrls: message.photoUrls,
      );

      final chat = Chat(
        type: type.name,
        chatID: chatID,
        usersID: FieldValue.arrayUnion([receiverID, senderID]),
        lastMessage: uploadMessage.toFirestore(),
        senderID: senderID,
        senderName: senderName,
        senderPhoto: senderPhoto,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        receiverID: receiverID,
        isSeen: {receiverID: false},
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        token: null,
        callMethod: null,
        current: null,
        lastEventTimestamp: FieldValue.serverTimestamp(),
      );

      writeBatch
        ..set<Chat>(chatRef, chat, SetOptions(merge: true))
        ..set<Message>(messageRef, uploadMessage)
        ..commit();
    }

    if (message.location != null) {
      final uploadMessage = Message(
        type: MessageTypes.location.name,
        chatID: chatID,
        messageID: messageRef.id,
        senderName: message.senderName,
        senderID: message.senderID,
        location: message.location,
        senderItems: message.senderItems,
        otherItems: message.otherItems,
        item: null,
        order: null,
        swap: null,
        text: null,
        photoUrl: null,
        receiverID: receiverID,
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        receiverName: null,
        receiverPhoto: null,
        senderPhoto: message.senderPhoto,
        status: null,
        token: null,
        photoUrls: message.photoUrls,
      );

      final chat = Chat(
        type: type.name,
        chatID: chatID,
        usersID: FieldValue.arrayUnion([receiverID, senderID]),
        lastMessage: uploadMessage.toFirestore(),
        senderID: senderID,
        senderName: senderName,
        senderPhoto: senderPhoto,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        receiverID: receiverID,
        isSeen: {receiverID: false},
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        token: null,
        callMethod: null,
        lastEventTimestamp: FieldValue.serverTimestamp(),
        current: null,
      );

      writeBatch
        ..set<Chat>(chatRef, chat, SetOptions(merge: true))
        ..set<Message>(messageRef, uploadMessage)
        ..commit();
    }

    if (message.type == MessageTypes.newSwap.name) {
      final uploadMessage = Message(
        type: MessageTypes.newSwap.name,
        chatID: chatID,
        messageID: messageRef.id,
        senderName: message.senderName,
        senderID: message.senderID,
        location: message.location,
        senderItems: message.senderItems,
        otherItems: message.otherItems,
        item: null,
        order: null,
        swap: message.swap,
        text: null,
        photoUrl: null,
        receiverID: receiverID,
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        receiverName: null,
        receiverPhoto: null,
        senderPhoto: message.senderPhoto,
        status: null,
        token: null,
        photoUrls: message.photoUrls,
      );

      final chat = Chat(
        type: type.name,
        chatID: chatID,
        usersID: FieldValue.arrayUnion([receiverID, senderID]),
        lastMessage: uploadMessage.toFirestore(),
        senderID: senderID,
        senderName: senderName,
        senderPhoto: senderPhoto,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        receiverID: receiverID,
        isSeen: {receiverID: false},
        timestamp: FieldValue.serverTimestamp(),
        appointmentID: null,
        channelName: null,
        createAt: null,
        token: null,
        callMethod: null,
        lastEventTimestamp: FieldValue.serverTimestamp(),
        current: null,
      );

      writeBatch
        ..set<Chat>(chatRef, chat, SetOptions(merge: true))
        ..set<Message>(messageRef, uploadMessage)
        ..commit();
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMessages({
    required String chatID,
    required DocumentSnapshot? prevDoc,
  }) async {
    if (prevDoc != null) {
      return _db
          .collection(chatsCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .orderBy('timestamp', descending: false)
          .endBeforeDocument(prevDoc)
          .limitToLast(20)
          .snapshots(includeMetadataChanges: true);
    } else {
      final querySnapshot = await _db
          .collection(chatsCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .orderBy('timestamp', descending: true)
          .limit(15)
          .get();

      if (querySnapshot.docs.length <= 15) {
        return _db
            .collection(chatsCollection)
            .doc(chatID)
            .collection(messagesCollection)
            .orderBy('timestamp', descending: false)
            .snapshots(includeMetadataChanges: true);
      } else {
        return _db
            .collection(chatsCollection)
            .doc(chatID)
            .collection(messagesCollection)
            .orderBy('timestamp', descending: false)
            .startAtDocument(querySnapshot.docs.last)
            .snapshots(includeMetadataChanges: true);
      }
    }
  }
}
