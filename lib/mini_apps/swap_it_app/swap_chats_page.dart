import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/chats/chats_bloc.dart';
import 'package:fibali/ui/widgets/chat_swap_tile.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';

class SwapChatsPage extends StatefulWidget {
  const SwapChatsPage({Key? key}) : super(key: key);

  static Future<dynamic>? showPage(context) {
    return Get.to(() => BlocProvider.value(
          value: BlocProvider.of<ChatsBloc>(context),
          child: const SwapChatsPage(),
        ));
  }

  @override
  SwapChatsPageState createState() => SwapChatsPageState();
}

class SwapChatsPageState extends State<SwapChatsPage>
    with AutomaticKeepAliveClientMixin<SwapChatsPage> {
  @override
  bool get wantKeepAlive => true;
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  ChatsBloc get _chatBloc => BlocProvider.of<ChatsBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(RCCubit.instance.getText(R.messages),
            style: GoogleFonts.fredokaOne(color: Colors.grey)),
        elevation: 0,
        leading: const PopButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          if (_currentUser == null)
            const LogInWidget()
          else
            Expanded(
              child: _buildShoppingChats(chatType: ChatTypes.swapIt),
            ),
        ],
      ),
    );
  }

  Widget _buildShoppingChats({required ChatTypes chatType}) {
    return FirestoreListView<Chat>(
      query: Chat.ref
          .where(ChatLabels.usersID.name, arrayContains: _currentUser!.uid)
          .where(ChatLabels.type.name, isEqualTo: ChatTypes.swapIt.name)
          .orderBy('${ChatLabels.lastMessage.name}.${MessageLabels.timestamp.name}',
              descending: true),
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      emptyBuilder: (context) => const Center(child: EmptyChatsWidget()),
      itemBuilder: (context, snapshot) {
        final chat = snapshot.data();

        if (chat.isValid()) {
          return ChatSwapTile(
            chat: chat,
            otherUserID: chat.usersID!.firstWhere(
              (id) => id != _currentUser!.uid,
              orElse: () => _currentUser!.uid,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Stack(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white60,
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, top: 24.0),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white60,
                child: Padding(
                  padding: EdgeInsets.only(right: 14.0, bottom: 14.0),
                  child: Iconify(
                    EmojioneMonotone.open_mailbox_with_lowered_flag,
                    color: Colors.grey,
                    size: 70,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        const Text(
          'No chats yet',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const Text(
          'Add new friends and start conversations',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
