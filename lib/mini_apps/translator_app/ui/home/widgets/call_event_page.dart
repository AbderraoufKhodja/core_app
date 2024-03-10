import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/messaging/bloc.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/chat_event_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CallEventsPage extends StatefulWidget {
  final String callID;
  final String receiverID;
  final String clientID;
  final String? clientName;
  final String? clientPhoto;
  final String? translatorName;
  final String? translatorPhoto;
  final String translatorID;

  const CallEventsPage({
    super.key,
    required this.callID,
    required this.receiverID,
    required this.clientID,
    required this.clientName,
    required this.clientPhoto,
    required this.translatorName,
    required this.translatorPhoto,
    required this.translatorID,
  });

  @override
  CallEventsPageState createState() => CallEventsPageState();
}

class CallEventsPageState extends State<CallEventsPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: PopButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: buildHeader(),
        ),
        body: buildBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    );
  }

  Widget buildBody() {
    return FirestoreListView<Message>(
      query: Message.ref(chatID: widget.callID).where(
          '${ChatLabels.lastMessage.name}.${MessageLabels.type.name}',
          isEqualTo: MessageTypes.call.name),
      pageSize: 20,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, snapshot) {
        final message = snapshot.data();
        return CallEventTile(
          currentUserId: _currentUser!.uid,
          message: message,
          hasPendingWrites: snapshot.metadata.hasPendingWrites,
        );
      },
    );
  }

  Widget buildHeader() {
    return widget.translatorID == _currentUser!.uid
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PhotoWidgetNetwork(
                label: Utils.getInitial(widget.clientName),
                photoUrl: widget.clientPhoto ?? '',
                boxShape: BoxShape.circle,
                height: Get.height * 0.06,
                width: Get.height * 0.06,
              ),
              SizedBox(
                width: Get.width * 0.03,
              ),
              if (widget.clientName != null)
                Expanded(
                  child: Text(widget.clientName!),
                ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PhotoWidgetNetwork(
                label: Utils.getInitial(widget.translatorName),
                photoUrl: widget.translatorPhoto ?? '',
                boxShape: BoxShape.circle,
                height: Get.height * 0.06,
                width: Get.height * 0.06,
              ),
              SizedBox(
                width: Get.width * 0.03,
              ),
              if (widget.translatorName != null)
                Expanded(
                  child: Text(widget.translatorName!),
                ),
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

Future<void> showCallEventsPage(
  BuildContext context, {
  required String callID,
  required String receiverID,
  required String clientID,
  required String? clientName,
  required String? clientPhoto,
  required String? translatorName,
  required String? translatorPhoto,
  required String translatorID,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MessagingBloc()),
        ],
        child: CallEventsPage(
          callID: callID,
          receiverID: receiverID,
          clientID: clientID,
          clientName: clientName,
          clientPhoto: clientPhoto,
          translatorName: translatorName,
          translatorPhoto: translatorPhoto,
          translatorID: translatorID,
        ),
      ),
    ),
  );
}
