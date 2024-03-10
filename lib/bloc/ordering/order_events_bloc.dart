import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/models/order_event.dart';

import './bloc.dart';

class OrderEventsBloc extends Bloc<OrderEventsEvent, OrderEventsState> {
  final _db = FirebaseFirestore.instance;

  OrderEventsBloc() : super(OrderEventsInitial()) {
    on<LoadOrderEvents>((event, emit) {
      emit(OrderEventsLoading());
      final orderEvents = getOrderEvents(orderID: event.orderID);
      emit(OrderEventsLoaded(orderEvents: orderEvents));
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStore({required String storeID}) {
    return _db.collection('stores').doc(storeID).get();
  }

  Future<void> markAsSeen({
    required String currentUserID,
    required String orderID,
  }) {
    return ShoppingOrder.ref.doc(orderID).update({
      'isSeen.$currentUserID': true,
    });
  }

  Stream<QuerySnapshot<OrderEvent>> getOrderEvents({
    required String orderID,
  }) {
    final orderEventRef = OrderEvent.ref(orderID: orderID);
    return orderEventRef
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);
  }
}
