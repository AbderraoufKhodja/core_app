import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {}

class MessagingLoadingState extends MessagingState {}

class MessagingLoadedState extends MessagingState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> messagingStream;

  const MessagingLoadedState({required this.messagingStream});

  @override
  List<Object> get props => [messagingStream];
}
