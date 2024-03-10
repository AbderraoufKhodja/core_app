import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fibali/fibali_core/models/item.dart';

import 'bloc.dart';

class StoreItemsBloc extends Bloc<StoreItemsEvent, StoreItemsState> {
  final _db = FirebaseFirestore.instance;
  final storeItemsRef = Item.ref;

  StoreItemsBloc() : super(StoreItemsInitial()) {
    on<LoadStoreItems>((event, emit) {
      emit(StoreItemsLoading());

      final Stream<QuerySnapshot<Map<String, dynamic>>> storeItems = BehaviorSubject()
        ..addStream(_db.collection('items').where('storeID', isEqualTo: event.storeID).snapshots());

      emit(StoreItemsLoaded(storeItems: storeItems));
    });
  }
  Future<void> deactivateStoreItem({
    required String storeID,
    required String itemID,
    required String storeOwnerID,
  }) {
    // TODO add check identity and storeID
    return _db.collection('items').doc(itemID).update({'isActive': false});
  }
}
