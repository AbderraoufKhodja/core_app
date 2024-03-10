import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/store.dart';

abstract class StoreFactoryState extends Equatable {
  const StoreFactoryState();

  @override
  List<Object> get props => [];
}

class StoreFactoryInitial extends StoreFactoryState {}

class LoadingStoreFactory extends StoreFactoryState {}

class StoreFactoryLoaded extends StoreFactoryState {
  final Stream<QuerySnapshot<Store>> userStores;

  const StoreFactoryLoaded({required this.userStores});

  @override
  List<Object> get props => [userStores];
}
