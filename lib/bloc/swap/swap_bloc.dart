import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/swap.dart';
import 'package:fibali/fibali_core/models/swap_event.dart';

import './bloc.dart';

class SwapLogicBloc extends Bloc<SwapLogicEvent, SwapLogicState> {
  final _db = FirebaseFirestore.instance;

  bool isSubmitting = false;

  SwapLogicBloc() : super(SwapLogicInitial()) {
    on<LoadSwapLogic>((event, emit) {
      emit(SwapLogicLoading());
      final swapEvents = getSwapEvents(swapID: event.swapID);
      emit(SwapLogicLoaded(swapEvents: swapEvents));
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStore({required String storeID}) {
    return _db.collection('stores').doc(storeID).get();
  }

  Future<void> markAsSeen({
    required String currentUserID,
    required String swapID,
  }) {
    return Swap.ref.doc(swapID).update({
      'isSeen.$currentUserID': true,
    });
  }

  Stream<QuerySnapshot<SwapEvent>> getSwapEvents({
    required String swapID,
  }) {
    final swapEventRef = SwapEvent.ref(swapID: swapID);

    return swapEventRef
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);
  }
}
