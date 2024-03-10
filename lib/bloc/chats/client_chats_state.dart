import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();
  @override
  List<Object> get props => [];
}

class ChatsInitialState extends ChatsState {}

class ChatLoadingState extends ChatsState {}

class ChatLoadedState extends ChatsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream;

  const ChatLoadedState({
    required this.chatsStream,
  });

  @override
  List<Object> get props => [chatsStream];
}
