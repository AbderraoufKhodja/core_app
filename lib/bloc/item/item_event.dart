part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class LoadItem extends ItemEvent {
  final String itemID;

  const LoadItem({
    required this.itemID,
  });

  @override
  List<Object> get props => [itemID];
}
