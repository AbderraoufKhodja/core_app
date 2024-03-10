import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/models/store.dart';

abstract class SwapFactoryEvent extends Equatable {
  const SwapFactoryEvent();

  @override
  List<Object?> get props => [];
}

class Submit extends SwapFactoryEvent {
  final Store store;
  final List<XFile> photoFiles;
  final SwapItem swap;

  const Submit({
    required this.store,
    required this.photoFiles,
    required this.swap,
  });

  @override
  List<Object> get props => [store, photoFiles, swap];
}

class LoadSwap extends SwapFactoryEvent {
  final String? itemID;
  final List<XFile>? images;

  const LoadSwap({required this.itemID, required this.images});

  @override
  List<Object?> get props => [itemID];
}
