import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/widgets/chat_tile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatTile extends StatefulWidget {
  final Chat chat;
  final String otherUserID;

  const ChatTile({
    super.key,
    required this.chat,
    required this.otherUserID,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> with AutomaticKeepAliveClientMixin<ChatTile> {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      subtitle: ChatTileContent(chat: widget.chat),
      trailing: widget.chat.timestamp != null
          ? Text(
              timeago.format(widget.chat.timestamp!.toDate()),
              style: const TextStyle(color: Colors.grey),
            )
          : const Text(''),
    );
  }
}
