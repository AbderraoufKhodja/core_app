import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatSwapTile extends StatefulWidget {
  final Chat chat;
  final String otherUserID;

  const ChatSwapTile({
    super.key,
    required this.chat,
    required this.otherUserID,
  });

  @override
  State<ChatSwapTile> createState() => _ChatSwapTileState();
}

class _ChatSwapTileState extends State<ChatSwapTile> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

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
    return ListTile(
      onTap: () => showMessagingPage(
        type: Chat.chatTypeFromString(name: widget.chat.type),
        chatID: widget.chat.chatID!,
        otherUserID: widget.otherUserID,
      ),
      tileColor:
          widget.chat.isSeen?[_currentUser!.uid] == false ? Colors.white30 : Colors.transparent,
      title: Text(
        _otherUserName,
        maxLines: 1,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black54,
              fontWeight: widget.chat.isSeen?[_currentUser!.uid] == false
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
      ),
      dense: true,
      leading: bd.Badge(
        position: bd.BadgePosition.topEnd(end: -4, top: -4),
        showBadge: widget.chat.isSeen?[_currentUser!.uid] == false,
        child: PhotoWidgetNetwork(
          label: Utils.getInitial(_otherUserName),
          width: 50,
          height: 50,
          photoUrl: _otherUserPhoto,
          boxShape: BoxShape.circle,
        ),
      ),
      subtitle: buildChatContent(),
      trailing: widget.chat.timestamp != null
          ? Text(
              timeago.format(widget.chat.timestamp!.toDate()),
              style: const TextStyle(color: Colors.grey),
            )
          : const Text(''),
    );
  }

  Widget buildChatContent() {
    switch (Utils.enumFromString(MessageTypes.values, widget.chat.lastMessage?['type'])) {
      case MessageTypes.text:
        return Text(
          widget.chat.lastMessage?['text'],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.chat.isSeen?[_currentUser!.uid] == false
                ? Colors.grey.shade400
                : Colors.grey.shade400,
            fontStyle: widget.chat.isSeen?[_currentUser!.uid] == false
                ? FontStyle.italic
                : FontStyle.normal,
          ),
          maxLines: 1,
        );

      case MessageTypes.photo:
        return Row(
          children: <Widget>[
            Icon(
              Icons.photo,
              color: Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 8.0),
            Text(RCCubit.instance.getText(R.photo)),
          ],
        );
      case MessageTypes.location:
        return Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 8.0),
            Text(RCCubit.instance.getText(R.location)),
          ],
        );
      case MessageTypes.newSwap:
        return Row(
          children: <Widget>[
            const Iconify(
              Mdi.cards,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8.0),
            Text(RCCubit.instance.getText(R.swap)),
          ],
        );
      case MessageTypes.swapAccepted:
        return Row(
          children: <Widget>[
            const Iconify(
              Mdi.cards,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8.0),
            Text(RCCubit.instance.getText(R.swap)),
          ],
        );

      case MessageTypes.call:
        return Row(
          children: <Widget>[
            const Icon(
              Icons.phone_rounded,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.call),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      case null:
        return const SizedBox();
    }
  }
}
