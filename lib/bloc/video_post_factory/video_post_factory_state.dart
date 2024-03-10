import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class VideoPostFactoryState extends Equatable {
  const VideoPostFactoryState();

  @override
  List<Object> get props => [];
}

class NewPost extends VideoPostFactoryState {
  final File file;

  const NewPost({required this.file});

  @override
  List<Object> get props => [file];
}

class ExistingPost extends VideoPostFactoryState {}

class PostFactoryInitial extends VideoPostFactoryState {}

class PostFactoryLoading extends VideoPostFactoryState {}
