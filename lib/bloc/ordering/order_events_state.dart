import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/order_event.dart';

abstract class OrderEventsState extends Equatable {
  const OrderEventsState();
  @override
  List<Object> get props => [];
}

class OrderEventsInitial extends OrderEventsState {}

class OrderEventsLoading extends OrderEventsState {}

class OrderEventsLoaded extends OrderEventsState {
  final Stream<QuerySnapshot<OrderEvent>> orderEvents;

  const OrderEventsLoaded({required this.orderEvents});

  @override
  List<Object> get props => [orderEvents];
}
