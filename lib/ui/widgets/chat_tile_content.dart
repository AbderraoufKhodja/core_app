import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ChatTileContent extends StatelessWidget {
  const ChatTileContent({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    switch (Utils.enumFromString(MessageTypes.values, chat.lastMessage?['type'])) {
      case MessageTypes.text:
        return Text(
          chat.lastMessage?['text'],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: chat.isSeen?[currentUser!.uid] == false ? Colors.grey : Colors.grey,
            fontStyle:
                chat.isSeen?[currentUser!.uid] == false ? FontStyle.italic : FontStyle.normal,
          ),
          maxLines: 1,
        );

      case MessageTypes.photo:
        return Row(
          children: <Widget>[
            const Icon(
              Icons.photo,
              color: Colors.grey,
              size: 18,
            ),
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
            const Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 18,
            ),
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
            const Iconify(
              Mdi.cards,
              size: 18,
              color: Colors.grey,
            ),
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
      case MessageTypes.swapAccepted:
        return Row(
          children: <Widget>[
            const Iconify(
              Mdi.cards,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8.0),
            Text(
              RCCubit.instance.getText(R.swap),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );

      case null:
        return const SizedBox();
    }
  }
}
