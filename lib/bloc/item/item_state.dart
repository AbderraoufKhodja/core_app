part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final Stream<DocumentSnapshot<Item>> item;

  const ItemLoaded({
    required this.item,
  });

  @override
  List<Object> get props => [item];
}
