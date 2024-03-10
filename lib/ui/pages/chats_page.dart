import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/ui/widgets/chat_tile.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  ChatsPageState createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> with AutomaticKeepAliveClientMixin<ChatsPage> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.messages)),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            padding: const EdgeInsets.all(8),
            tabs: [
              Badge(
                badgeContent: StreamBuilder<QuerySnapshot<Chat>>(
                    stream: Chat.ref
                        .where(ChatLabels.usersID.name, arrayContains: _currentUser!.uid)
                        .where('${ChatLabels.isSeen.name}.${_currentUser!.uid}', isEqualTo: false)
                        .where(ChatLabels.type.name, isEqualTo: ChatTypes.personal.name)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        return const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.redAccent,
                          child: SizedBox(),
                        );
                      }

                      return const SizedBox();
                    }),
                badgeStyle: const BadgeStyle(
                  shape: BadgeShape.circle,
                  padding: EdgeInsets.all(0),
                ),
                position: BadgePosition.topEnd(end: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(RCCubit.instance.getText(R.personal)),
                ),
              ),
              Badge(
                badgeContent: StreamBuilder<QuerySnapshot<Chat>>(
                    stream: Chat.ref
                        .where(ChatLabels.usersID.name, arrayContains: _currentUser!.uid)
                        .where('${ChatLabels.isSeen.name}.${_currentUser!.uid}', isEqualTo: false)
                        .where(ChatLabels.type.name, isEqualTo: ChatTypes.shopping.name)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        return const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.redAccent,
                          child: SizedBox(),
                        );
                      }

                      return const SizedBox();
                    }),
                badgeStyle: const BadgeStyle(
                  shape: BadgeShape.circle,
                  padding: EdgeInsets.all(0),
                ),
                position: BadgePosition.topEnd(end: 0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(RCCubit.instance.getText(R.shopping))),
              ),
              // Badge(
              //   badgeContent: StreamBuilder<QuerySnapshot<Chat>>(
              //       stream: Chat.ref
              //           .where(ChatLabels.usersID.name, arrayContains: _currentUser!.uid)
              //           .where('${ChatLabels.isSeen.name}.${_currentUser!.uid}', isEqualTo: false)
              //           .where(ChatLabels.type.name, isEqualTo: ChatTypes.swapIt.name)
              //           .limit(1)
              //           .snapshots(),
              //       builder: (context, snapshot) {
              //         if ((snapshot.data?.docs.length ?? 0) > 0) {
              //           return const CircleAvatar(
              //             radius: 6,
              //             backgroundColor: Colors.redAccent,
              //             child: SizedBox(),
              //           );
              //         }

              //         return const SizedBox();
              //       }),
              //   badgeStyle: const BadgeStyle(
              //     shape: BadgeShape.circle,
              //     padding: EdgeInsets.all(0),
              //   ),
              //   position: BadgePosition.topEnd(end: 0),
              //   child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Text(RCCubit.instance.getText(R.swaps))),
              // ),
            ],
          ),
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Expanded(
              child: TabBarView(
                children: [
                  ChatList(chatType: ChatTypes.personal),
                  ChatList(chatType: ChatTypes.shopping),
                  // ChatList(chatType: ChatTypes.swapIt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.chatType}) : super(key: key);

  final ChatTypes chatType;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with AutomaticKeepAliveClientMixin<ChatList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return FirestoreListView<Chat>(
      query: Chat.ref
          .where(ChatLabels.usersID.name, arrayContains: currentUser!.uid)
          .where(ChatLabels.type.name, isEqualTo: widget.chatType.name)
          .orderBy(
            '${ChatLabels.lastMessage.name}.${MessageLabels.timestamp.name}',
            descending: true,
          ),
      loadingBuilder: (context) =>
          Center(child: CircularProgressIndicator(color: Colors.grey.shade300)),
      emptyBuilder: (context) => const EmptyChatsWidget(),
      itemBuilder: (context, snapshot) {
        final chat = snapshot.data();

        if (chat.isValid()) {
          return ChatTile(
            chat: chat,
            otherUserID: chat.usersID!.firstWhere(
              (id) => id != currentUser.uid,
              orElse: () => currentUser.uid,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
// This widget displays an empty mail box icon and a subtitle when there are no chats in the chats page. The subtitle encourages the users to add new friends and start conversations. This widget is built using Flutter framework and can be customized with different colors and fonts.

class EmptyChatsWidget extends StatelessWidget {
  const EmptyChatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleCirclesWidget(
      title: RCCubit.instance.getText(R.noChatsYetTitle),
      description: RCCubit.instance.getText(R.noChatsYetDescription),
      child: const Iconify(
        EmojioneMonotone.open_mailbox_with_lowered_flag,
        color: Colors.grey,
        size: 70,
      ),
    );
  }
}
