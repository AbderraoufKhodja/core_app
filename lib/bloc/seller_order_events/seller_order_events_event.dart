import 'package:equatable/equatable.dart';

abstract class SellerOrderEventsEvent extends Equatable {
  const SellerOrderEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSellerOrderEvents extends SellerOrderEventsEvent {
  final String orderID;

  const LoadSellerOrderEvents({required this.orderID});

  @override
  List<Object?> get props => [orderID];
}
