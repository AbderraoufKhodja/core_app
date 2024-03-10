import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsInitialState()) {
    on<LoadChatsEvent>((event, emit) {
      emit(ChatLoadingState());

      final Stream<QuerySnapshot<Chat>> chats = BehaviorSubject()
        ..addStream(Chat.ref
            .where(ChatLabels.usersID.name, arrayContains: event.currentUser.uid)
            .orderBy('${ChatLabels.lastMessage.name}.${MessageLabels.timestamp.name}',
                descending: true)
            .snapshots());

      emit(ChatLoadedState(chats: chats));
    });
  }
}
