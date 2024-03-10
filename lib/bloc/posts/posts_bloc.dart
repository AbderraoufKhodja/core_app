import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final _db = FirebaseFirestore.instance;

  PostsBloc() : super(PostsInitial()) {
    on<LoadPosts>((event, emit) {
      emit(PostsLoading());
      final posts =
          _db.collection(usersCollection).doc(event.userID).collection('posts').snapshots();
      emit(PostsLoaded(posts: posts));
    });
  }
}
