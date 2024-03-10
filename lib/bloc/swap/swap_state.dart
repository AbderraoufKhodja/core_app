import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/swap_event.dart';

abstract class SwapLogicState extends Equatable {
  const SwapLogicState();
  @override
  List<Object> get props => [];
}

class SwapLogicInitial extends SwapLogicState {}

class SwapLogicLoading extends SwapLogicState {}

class SwapLogicLoaded extends SwapLogicState {
  final Stream<QuerySnapshot<SwapEvent>> swapEvents;

  const SwapLogicLoaded({required this.swapEvents});

  @override
  List<Object> get props => [swapEvents];
}
