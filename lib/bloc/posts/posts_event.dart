part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostsEvent {
  final String? userID;

  const LoadPosts({required this.userID});

  @override
  List<Object?> get props => [userID];
}
