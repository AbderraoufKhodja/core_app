part of 'swap_item_bloc.dart';

abstract class SwapItemEvent extends Equatable {
  const SwapItemEvent();

  @override
  List<Object> get props => [];
}

class LoadSwapItem extends SwapItemEvent {
  final String itemID;

  const LoadSwapItem({
    required this.itemID,
  });

  @override
  List<Object> get props => [itemID];
}
