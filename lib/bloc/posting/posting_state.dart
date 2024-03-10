import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PostingState extends Equatable {
  const PostingState();
  @override
  List<Object> get props => [];
}

class PostingInitial extends PostingState {}

class PostesLoading extends PostingState {}

class PostesLoaded extends PostingState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> messagingStream;

  const PostesLoaded({required this.messagingStream});

  @override
  List<Object> get props => [messagingStream];
}
