import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/item.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();
  @override
  List<Object> get props => [];
}

class BusinessInitial extends BusinessState {}

class BusinessCategoryUpdated extends BusinessState {}

class BusinessRefUpdated extends BusinessState {}

class BusinessLoading extends BusinessState {}

class BusinessLoaded extends BusinessState {
  final Future<QuerySnapshot<Item>> items;

  const BusinessLoaded({required this.items});

  @override
  List<Object> get props => [items];
}
