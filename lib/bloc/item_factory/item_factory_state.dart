import 'package:equatable/equatable.dart';

abstract class ItemFactoryState extends Equatable {
  const ItemFactoryState();

  @override
  List<Object> get props => [];
}

class NewItem extends ItemFactoryState {}

class ExistingItem extends ItemFactoryState {}

class ItemFactoryInitial extends ItemFactoryState {}

class ItemFactoryLoading extends ItemFactoryState {}
