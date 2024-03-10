part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class LoadStore extends StoreEvent {
  final String storeID;

  const LoadStore({required this.storeID});

  @override
  List<Object> get props => [storeID];
}
