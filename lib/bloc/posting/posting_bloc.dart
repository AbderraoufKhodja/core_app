import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:uuid/uuid.dart';

import './bloc.dart';

class PostingBloc extends Bloc<PostingEvent, PostingState> {
  final _db = FirebaseFirestore.instance;
  final String uuid = const Uuid().v4();

  PostingBloc() : super(PostingInitial()) {
    on<LoadPostes>((event, emit) async {
      emit(PostesLoading());
      final Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream = BehaviorSubject()
        ..addStream(await getPostes(
          orderID: event.postID,
          prevDoc: event.prevDoc,
        ));
      emit(PostesLoaded(messagingStream: messagesStream));
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStore({required String storeID}) {
    return _db.collection(usersCollection).doc(storeID).get();
  }

  Future<void> addSeen({
    required String postID,
  }) {
    return _db.collection('posts').doc(postID).update({'seenCount': FieldValue.increment(1)});
  }

// TODO: Adding limit to reads here and elsewhere
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPostes({
    required String orderID,
    required DocumentSnapshot? prevDoc,
  }) async {
    if (prevDoc != null) {
      return _db
          .collection('posts')
          .doc(orderID)
          .collection(messagesCollection)
          .orderBy('timestamp', descending: false)
          .endBeforeDocument(prevDoc)
          .limitToLast(20)
          .snapshots(includeMetadataChanges: true);
    } else {
      final querySnapshot = await _db
          .collection('posts')
          .doc(orderID)
          .collection(messagesCollection)
          .orderBy('timestamp', descending: true)
          .limit(15)
          .get();

      if (querySnapshot.docs.length <= 15) {
        return _db
            .collection('posts')
            .doc(orderID)
            .collection(messagesCollection)
            .orderBy('timestamp', descending: false)
            .snapshots(includeMetadataChanges: true);
      } else {
        return _db
            .collection('posts')
            .doc(orderID)
            .collection(messagesCollection)
            .orderBy('timestamp', descending: false)
            .startAtDocument(querySnapshot.docs.last)
            .snapshots(includeMetadataChanges: true);
      }
    }
  }
}
