part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreInitial extends StoreState {
  @override
  List<Object> get props => [];
}

class StoreLoading extends StoreState {
  @override
  List<Object> get props => [];
}

class StoreLoaded extends StoreState {
  final Future<DocumentSnapshot<Store>> store;
  const StoreLoaded({required this.store});

  @override
  List<Object> get props => [store];
}
