import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessagingEvent {
  final String chatID;
  final DocumentSnapshot? prevDoc;

  const LoadMessages({
    required this.chatID,
    required this.prevDoc,
  });

  @override
  List<Object?> get props => [chatID, prevDoc];
}
