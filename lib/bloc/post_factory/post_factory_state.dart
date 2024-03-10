import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostFactoryState extends Equatable {
  const PostFactoryState();

  @override
  List<Object> get props => [];
}

class NewLivePost extends PostFactoryState {
  final List<XFile> images;

  const NewLivePost({required this.images});

  @override
  List<Object> get props => [images];
}

class ExistingLivePost extends PostFactoryState {}

class PostFactoryInitial extends PostFactoryState {}

class LivePostFactoryLoading extends PostFactoryState {}
