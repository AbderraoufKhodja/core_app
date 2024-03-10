import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/messaging/messaging_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmSendImage extends StatelessWidget {
  const ConfirmSendImage({
    super.key,
    required this.chatID,
    required this.imageFiles,
    required this.otherUser,
    required this.type,
    required this.receiverName,
    required this.receiverPhoto,
  });

  final String chatID;
  final List<XFile> imageFiles;
  final AppUser otherUser;
  final ChatTypes type;
  final String receiverName;
  final String? receiverPhoto;

  static Future<dynamic>? show({
    required String chatID,
    required List<XFile> imageFiles,
    required AppUser otherUser,
    required ChatTypes type,
    required String receiverName,
    required String? receiverPhoto,
  }) async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return;
    }

    return Get.to(
      () => ConfirmSendImage(
        chatID: chatID,
        imageFiles: imageFiles,
        otherUser: otherUser,
        type: type,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: const PopButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                MessagingBloc.sendMessage(
                  message: Message(
                    chatID: chatID,
                    messageID: null,
                    type: MessageTypes.photo.name,
                    item: null,
                    photoUrl: null,
                    order: null,
                    swap: null,
                    text: null,
                    location: null,
                    senderItems: null,
                    otherItems: null,
                    receiverID: otherUser.uid,
                    senderName: currentUser!.name,
                    senderID: currentUser.uid,
                    timestamp: FieldValue.serverTimestamp(),
                    appointmentID: null,
                    channelName: null,
                    createAt: null,
                    receiverName: null,
                    receiverPhoto: null,
                    senderPhoto: null,
                    status: null,
                    token: null,
                    photoUrls: null,
                  ),
                  type: type,
                  senderID: currentUser.uid,
                  senderName: currentUser.name,
                  senderPhoto: currentUser.photoUrl,
                  receiverName: receiverName,
                  receiverPhoto: receiverPhoto,
                  receiverID: otherUser.uid,
                  photoFiles: imageFiles,
                  chatID: chatID,
                );
                Get.back();
              },
              child: Text(RCCubit.instance.getText(R.send)),
            ),
          ),
        ],
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: imageFiles.length > 1 ? 2 : 1,
        ),
        padding: const EdgeInsets.all(8),
        children: imageFiles
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  child: Image.file(
                    File(e.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
