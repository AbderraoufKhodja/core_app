import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/store.dart';

abstract class PostFactoryEvent extends Equatable {
  const PostFactoryEvent();

  @override
  List<Object?> get props => [];
}

class Submit extends PostFactoryEvent {
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

class LoadPost extends PostFactoryEvent {
  final String? postID;
  final List<XFile>? images;

  const LoadPost({required this.postID, required this.images});

  @override
  List<Object?> get props => [postID];
}
