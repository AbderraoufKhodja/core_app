import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/chat.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();
  @override
  List<Object> get props => [];
}

class ChatsInitialState extends ChatsState {}

class ChatLoadingState extends ChatsState {}

class ChatLoadedState extends ChatsState {
  final Stream<QuerySnapshot<Chat>> chats;

  const ChatLoadedState({
    required this.chats,
  });

  @override
  List<Object> get props => [chats];
}
