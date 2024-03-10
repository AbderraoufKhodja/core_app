import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/messaging/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/ui/pages/personal_chat_report_page.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/pages/settings_pages/privacy_security/blocked_users_page.dart';
import 'package:fibali/ui/pages/store_page.dart';
import 'package:fibali/ui/pages/swap_user_profile_page.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fibali/ui/widgets/chat_orders_card.dart';
import 'package:fibali/ui/widgets/make_swap_card.dart';
import 'package:fibali/ui/widgets/message_bubble.dart';
import 'package:fibali/ui/widgets/messaging_text_field.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingPage extends StatefulWidget {
  final String chatID;
  final ChatTypes type;
  final AppUser otherUser;

  const MessagingPage({
    super.key,
    required this.chatID,
    required this.type,
    required this.otherUser,
  });

  @override
  MessagingPageState createState() => MessagingPageState();
}

class MessagingPageState extends State<MessagingPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  MessagingBloc get _messagingBloc => BlocProvider.of<MessagingBloc>(context);

  RelationsCubit get relationsCubit => BlocProvider.of<RelationsCubit>(context);

  @override
  void initState() {
    super.initState();

    _messagingBloc.add(LoadMessages(
      chatID: widget.chatID,
      prevDoc: null,
    ));

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentChatID", widget.chatID));

    _messagingBloc.markAsSeen(
      currentUserID: _currentUser!.uid,
      chatID: widget.chatID,
    );
  }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((prefs) => prefs.remove("currentChatID"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationsCubit, RelationsState>(
      builder: (context, state) {
        if (state is RelationsInitial) {
          relationsCubit.initStream(userID: _currentUser!.uid);
        }

        if (state is RelationsLoading) {
          return LoadingGrid(width: Get.width);
        }

        if (state is RelationsLoaded) {
          return StreamBuilder<QuerySnapshot<Relation>>(
              stream: relationsCubit.relationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingGrid(width: Get.width);
                }

                final relations = snapshot.data?.docs
                    .map((doc) => doc.data())
                    .where((relation) => relation.uid == widget.otherUser.uid)
                    .toList();

                if (relations?.any((relation) => relation.isBlockedBy) == true) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: const PopButton(),
                      title: Text(widget.otherUser.name),
                      centerTitle: false,
                    ),
                    body: Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/91603-blocked-account-gray.json",
                            height: 200,
                            width: 200,
                            repeat: false,
                          ),
                          Text(
                            RCCubit.instance.getText(R.youHaveBeenBlockedByThisUser),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (relations?.any((relation) => relation.isBlocked) == true) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: const PopButton(),
                      title: Text(widget.otherUser.name),
                      centerTitle: false,
                    ),
                    body: Center(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/91603-blocked-account-gray.json",
                            height: 200,
                            width: 200,
                            repeat: false,
                          ),
                          Text(
                            RCCubit.instance.getText(R.youHaveBlockedThisUser),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              BlockedUsersPage.show();
                            },
                            child: Text(RCCubit.instance.getText(R.unblock)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return WillPopScope(
                  onWillPop: () {
                    _messagingBloc.markAsSeen(
                      currentUserID: _currentUser!.uid,
                      chatID: widget.chatID,
                    );
                    return Future.value(true);
                  },
                  child: Scaffold(
                    body: Scaffold(
                      appBar: AppBar(
                        elevation: 1,
                        centerTitle: false,
                        leading: PopButton(
                          onPressed: () {
                            _messagingBloc.markAsSeen(
                              currentUserID: _currentUser!.uid,
                              chatID: widget.chatID,
                            );
                            Get.back();
                          },
                        ),
                        title: buildHeader(),
                        actions: [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<CallHandlerCubit>(context).fireVideoCall(
                                context,
                                chat: Chat(
                                  appointmentID: null,
                                  type: widget.type.name,
                                  lastMessage: Message(
                                    appointmentID: null,
                                    messageID: null,
                                    type: MessageTypes.call.name,
                                    token: null,
                                    channelName: null,
                                    chatID: widget.chatID,
                                    senderID: _currentUser?.uid,
                                    senderPhoto: _currentUser?.photoUrl,
                                    senderName: _currentUser?.name,
                                    receiverID: widget.otherUser.uid,
                                    receiverName: widget.otherUser.name,
                                    receiverPhoto: widget.otherUser.photoUrl,
                                    status: CallStatus.ringing.name,
                                    createAt: DateTime.now().millisecondsSinceEpoch,
                                    timestamp: DateTime.now().millisecondsSinceEpoch,
                                    item: null,
                                    location: null,
                                    order: null,
                                    swap: null,
                                    otherItems: null,
                                    photoUrl: null,
                                    senderItems: null,
                                    text: null,
                                    photoUrls: null,
                                  ).toFirestore(),
                                  token: null,
                                  channelName: null,
                                  chatID: widget.chatID,
                                  senderID: _currentUser?.uid,
                                  senderPhoto: _currentUser?.photoUrl,
                                  senderName: _currentUser?.name,
                                  receiverID: widget.otherUser.uid,
                                  receiverName: widget.otherUser.name,
                                  receiverPhoto: widget.otherUser.photoUrl,
                                  createAt: DateTime.now().millisecondsSinceEpoch,
                                  current: true,
                                  callMethod: CallMethods.inApp.name,
                                  lastEventTimestamp: FieldValue.serverTimestamp(),
                                  timestamp: FieldValue.serverTimestamp(),
                                  isSeen: {widget.otherUser.uid: false},
                                  usersID: [_currentUser!.uid, widget.otherUser.uid],
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone_rounded, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PopupMenuButton<String>(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: null,
                                    child: Text(RCCubit.instance.getText(R.report)),
                                    onTap: () async {
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      ChatReportPage.showPage(
                                        reportedUser: widget.otherUser,
                                        chatID: widget.chatID,
                                      );
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value: null,
                                    child: Text(RCCubit.instance.getText(R.block)),
                                    onTap: () async {
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      // show dialog to confirm
                                      Utils.showBlurredDialog(
                                          child: AlertDialog(
                                        title: Text(RCCubit.instance.getText(R.block)),
                                        content:
                                            Text(RCCubit.instance.getText(R.blockUserDescription)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(RCCubit.instance.getText(R.cancel)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await Future.delayed(
                                                  const Duration(milliseconds: 500));
                                              Get.back();
                                              BlocProvider.of<RelationsCubit>(Get.context!).onBlock(
                                                currentUser: _currentUser!,
                                                otherUser: widget.otherUser,
                                              );
                                              Get.back();
                                            },
                                            child: Text(RCCubit.instance.getText(R.block)),
                                          ),
                                        ],
                                      ));
                                    },
                                  ),
                                ];
                              },
                            ),
                          ),
                        ],
                      ),
                      body: buildBody(),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
                      bottomNavigationBar: BottomAppBar(
                        child: MessagingTextField(
                          type: widget.type,
                          chatID: widget.chatID,
                          otherUser: widget.otherUser,
                          receiverName: widget.otherUser.name,
                          receiverPhoto: widget.otherUser.photoUrl,
                        ),
                      ),
                    ),
                  ),
                );
              });
        }

        return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        if (widget.type == ChatTypes.shopping)
          ChatOrdersCard(
            storeID: widget.otherUser.uid,
            chatID: widget.chatID,
            clientID: _currentUser!.uid,
            color: Colors.grey.shade200,
          ),
        if (widget.type == ChatTypes.swapIt)
          MakeSwapCard(
            chatID: widget.chatID,
            receiverID: widget.otherUser.uid,
            receiverName: widget.otherUser.name,
            receiverPhoto: widget.otherUser.photoUrl,
          ),
        Expanded(
          child: FirestoreListView<Message>(
            query: Message.ref(chatID: widget.chatID)
                .orderBy(MessageLabels.timestamp.name, descending: true),
            pageSize: 20,
            padding: const EdgeInsets.only(bottom: 8),
            reverse: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, snapshot) {
              final message = snapshot.data();
              return Align(
                alignment: _currentUser!.uid == message.senderID
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: MessageBubble(
                  currentUserId: _currentUser!.uid,
                  message: message,
                  hasPendingWrites: snapshot.metadata.hasPendingWrites,
                  // isShowTimestamp: checkIfShowTimestamp(snapshot, snapshot, _message),
                  isShowTimestamp: false,
                  receiverName: widget.otherUser.name,
                  receiverPhoto: widget.otherUser.photoUrl,
                ),
              );
            },
          ),
        ),
        const Divider(height: 0, color: Colors.grey),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (widget.type == ChatTypes.personal) {
              UserProfilePage.showPage(userID: widget.otherUser.uid);
            }
            if (widget.type == ChatTypes.swapIt) {
              SwapUserProfilePage.showPage(userID: widget.otherUser.uid);
            }
            if (widget.type == ChatTypes.shopping) {
              StorePage.show(storeID: widget.otherUser.uid);
            }
          },
          child: PhotoWidget.network(
            photoUrl: widget.otherUser.photoUrl,
            boxShape: BoxShape.circle,
            height: 45,
            width: 45,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(child: Text(widget.otherUser.name)),
      ],
    );
  }

  bool checkIfShowTimestamp(
      int index, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, Message message) {
    if (index > 0) {
      final prevMessage = Message.fromFirestore(
        snapshot.data!.docs[index - 1].data(),
      );
      return (prevMessage.timestamp?.toDate() ?? DateTime.now())
              .difference(message.timestamp?.toDate() ?? DateTime.now())
              .inMinutes >
          1;
    }
    return false;
  }
}

class _ChatNotFoundWidget extends StatefulWidget {
  const _ChatNotFoundWidget();

  @override
  State<_ChatNotFoundWidget> createState() => _ChatNotFoundWidgetState();
}

class _ChatNotFoundWidgetState extends State<_ChatNotFoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PopButton(),
        elevation: 0.5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.search_off,
            size: Get.width * 0.7,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: Get.size.width / 10,
              right: Get.size.width / 10,
              bottom: Get.size.height / 50,
            ),
            child: Text(
              RCCubit.instance.getText(R.chatNotFound),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic>? showMessagingPage({
  required ChatTypes type,
  required String chatID,
  required String otherUserID,
}) {
  return Get.to(
    () => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MessagingBloc()),
      ],
      child: StreamBuilder<DocumentSnapshot<AppUser>>(
        stream: AppUser.ref.doc(otherUserID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) return const SizedBox();

          if (snapshot.data?.exists == false) {
            return const _ChatNotFoundWidget();
          }

          if (snapshot.data?.data() != null) {
            final otherUser = snapshot.data!.data()!;
            return MessagingPage(
              type: type,
              chatID: chatID,
              otherUser: otherUser,
            );
          }

          return const _ChatNotFoundWidget();
        },
      ),
    ),
  );
}
