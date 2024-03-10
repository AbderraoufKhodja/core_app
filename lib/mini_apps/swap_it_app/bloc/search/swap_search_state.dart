import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';

abstract class SwapSearchState extends Equatable {
  const SwapSearchState();
  @override
  List<Object> get props => [];
}

class SwapSearchInitialState extends SwapSearchState {}

class SwapItemLoadingState extends SwapSearchState {}

class NoSwapAroundState extends SwapSearchState {}

class SwapItemLoadedState extends SwapSearchState {
  final List<SwapItem> swapItems;

  const SwapItemLoadedState({
    required this.swapItems,
  });

  @override
  List<Object> get props => [
        swapItems,
      ];
}
