import 'package:equatable/equatable.dart';

abstract class OrderEventsEvent extends Equatable {
  const OrderEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderEvents extends OrderEventsEvent {
  final String orderID;

  const LoadOrderEvents({required this.orderID});

  @override
  List<Object?> get props => [orderID];
}
