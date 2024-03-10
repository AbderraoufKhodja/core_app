import 'package:equatable/equatable.dart';

abstract class StoreItemsEvent extends Equatable {
  const StoreItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadStoreItems extends StoreItemsEvent {
  final String storeID;

  const LoadStoreItems({required this.storeID});

  @override
  List<Object> get props => [storeID];
}
