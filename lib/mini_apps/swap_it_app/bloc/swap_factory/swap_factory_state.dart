import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class SwapFactoryState extends Equatable {
  const SwapFactoryState();

  @override
  List<Object> get props => [];
}

class NewSwap extends SwapFactoryState {
  final List<XFile> images;

  const NewSwap({required this.images});

  @override
  List<Object> get props => [images];
}

class ExistingSwap extends SwapFactoryState {}

class SwapFactoryInitial extends SwapFactoryState {}

class SwapFactoryLoading extends SwapFactoryState {}
