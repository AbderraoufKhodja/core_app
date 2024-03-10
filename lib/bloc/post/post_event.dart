part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPost extends PostEvent {
  final String postID;

  const LoadPost({
    required this.postID,
  });

  @override
  List<Object> get props => [postID];
}
