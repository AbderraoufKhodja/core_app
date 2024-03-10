import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ChatGetSnackBar extends GetSnackBar {
  final Chat chat;
  final String otherUserID;

  const ChatGetSnackBar({
    super.key,
    required this.chat,
    required this.otherUserID,
  });

  @override
  State<ChatGetSnackBar> createState() => _ChatGetSnackBarState();
}

class _ChatGetSnackBarState extends State<ChatGetSnackBar> {
  String get _otherUserName {
    if (widget.chat.senderID == widget.otherUserID) {
      return widget.chat.senderName!;
    } else {
      return widget.chat.receiverName!;
    }
  }

  String? get _otherUserPhoto {
    if (widget.chat.senderID == widget.otherUserID) {
      return widget.chat.senderPhoto;
    } else {
      return widget.chat.receiverPhoto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetSnackBar(
      onTap: (snackBar) {
        showMessagingPage(
          type: Chat.chatTypeFromString(name: widget.chat.type),
          chatID: widget.chat.chatID!,
          otherUserID: widget.otherUserID,
        );
      },
      isDismissible: true,

      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      title: _otherUserName,

      mainButton: PhotoWidgetNetwork(
        label: Utils.getInitial(_otherUserName),
        width: 50,
        height: 50,
        photoUrl: _otherUserPhoto,
        boxShape: BoxShape.circle,
      ),
      message: 'fawegwaeg',
      // messageText: MessageText(chat: widget.chat),
    );
  }
}

class MessageText extends StatelessWidget {
  const MessageText({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    switch (Utils.enumFromString(MessageTypes.values, chat.lastMessage?['type'])) {
      case MessageTypes.text:
        return Text(
          chat.lastMessage?['text'],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
          maxLines: 1,
        );

      case MessageTypes.photo:
        return Row(
          children: <Widget>[
            const Icon(Icons.photo, color: Colors.grey, size: 18),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.photo),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      case MessageTypes.location:
        return Row(
          children: <Widget>[
            const Icon(Icons.location_on, color: Colors.grey, size: 18),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.location),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      case MessageTypes.newSwap:
        return Row(
          children: <Widget>[
            const Iconify(Mdi.cards, size: 18, color: Colors.grey),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.swap),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      case MessageTypes.call:
        return Row(
          children: <Widget>[
            const Icon(Icons.phone_rounded, color: Colors.grey, size: 18),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.call),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      case MessageTypes.swapAccepted:
        return Row(
          children: <Widget>[
            const Iconify(Mdi.cards, size: 18, color: Colors.grey),
            const SizedBox(width: 8.0),
            Text(RCCubit.instance.getText(R.swap), style: const TextStyle(color: Colors.grey)),
          ],
        );

      case null:
        return const SizedBox();
    }
  }
}
