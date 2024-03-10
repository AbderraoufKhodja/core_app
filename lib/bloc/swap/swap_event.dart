import 'package:equatable/equatable.dart';

abstract class SwapLogicEvent extends Equatable {
  const SwapLogicEvent();

  @override
  List<Object?> get props => [];
}

class LoadSwapLogic extends SwapLogicEvent {
  final String swapID;

  const LoadSwapLogic({required this.swapID});

  @override
  List<Object?> get props => [swapID];
}
