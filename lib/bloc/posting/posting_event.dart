import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PostingEvent extends Equatable {
  const PostingEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostes extends PostingEvent {
  final String postID;
  final DocumentSnapshot? prevDoc;

  const LoadPostes({
    required this.postID,
    required this.prevDoc,
  });

  @override
  List<Object?> get props => [postID, prevDoc];
}
