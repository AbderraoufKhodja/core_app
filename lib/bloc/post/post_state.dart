part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final Stream<DocumentSnapshot<Post>> post;

  const PostLoaded({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
