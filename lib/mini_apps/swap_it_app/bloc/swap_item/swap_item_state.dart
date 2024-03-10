part of 'swap_item_bloc.dart';

abstract class SwapItemState extends Equatable {
  const SwapItemState();

  @override
  List<Object> get props => [];
}

class SwapItemInitial extends SwapItemState {}

class SwapItemLoading extends SwapItemState {}

class SwapItemLoaded extends SwapItemState {
  final Stream<DocumentSnapshot<SwapItem>> swapItem;

  const SwapItemLoaded({
    required this.swapItem,
  });

  @override
  List<Object> get props => [swapItem];
}
