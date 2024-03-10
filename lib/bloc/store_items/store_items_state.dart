import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StoreItemsState extends Equatable {
  const StoreItemsState();

  @override
  List<Object> get props => [];
}

class StoreItemsInitial extends StoreItemsState {}

class StoreItemsLoading extends StoreItemsState {}

class StoreItemsLoaded extends StoreItemsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> storeItems;

  const StoreItemsLoaded({required this.storeItems});

  @override
  List<Object> get props => [storeItems];
}
