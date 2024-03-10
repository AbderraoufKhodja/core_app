import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/store.dart';

abstract class VideoPostFactoryEvent extends Equatable {
  const VideoPostFactoryEvent();

  @override
  List<Object?> get props => [];
}

class Submit extends VideoPostFactoryEvent {
  final Store store;
  final List<XFile> photoFiles;
  final Post post;

  const Submit({
    required this.store,
    required this.photoFiles,
    required this.post,
  });

  @override
  List<Object> get props => [store, photoFiles, post];
}

class LoadPost extends VideoPostFactoryEvent {
  final String? postID;
  final File? video;

  const LoadPost({required this.postID, required this.video});

  @override
  List<Object?> get props => [postID];
}
