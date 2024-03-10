import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/chats/bloc.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

class ChatsBadge extends StatefulWidget {
  final bool isActive;

  const ChatsBadge({Key? key, required this.isActive}) : super(key: key);

  @override
  State<ChatsBadge> createState() => _ChatsBadgeState();
}

class _ChatsBadgeState extends State<ChatsBadge> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  ChatsBloc get _chatBloc => BlocProvider.of<ChatsBloc>(context);

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const SizedBox();
    return FirestoreQueryBuilder<Chat>(
      query: Chat.ref
          .where(ChatLabels.usersID.name, arrayContains: _currentUser!.uid)
          .where('${ChatLabels.isSeen.name}.${_currentUser!.uid}', isEqualTo: false)
          .limit(10),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Iconify(
            Carbon.chat,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          );
        }
        if (snapshot.hasError) {
          return Iconify(
            Carbon.chat,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          );
        }
        final chats = snapshot.docs.map((doc) => doc.data());

        return bd.Badge(
          showBadge: chats.any(
            (chat) => chat.isSeen?[_currentUser?.uid] == false,
          ),
          badgeContent: FittedBox(
            child: Text(
              chats.where((chat) => chat.isSeen?[_currentUser?.uid] == false).length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          badgeStyle: const bd.BadgeStyle(
            shape: bd.BadgeShape.circle,
            padding: EdgeInsets.all(3),
          ),
          child: Iconify(
            Carbon.chat,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          ),
        );
      },
    );
  }
}
