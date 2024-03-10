import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/store.dart';

abstract class ItemFactoryEvent extends Equatable {
  const ItemFactoryEvent();

  @override
  List<Object?> get props => [];
}

class Submit extends ItemFactoryEvent {
  final Store store;
  final List<XFile> photoFiles;
  final Item item;

  const Submit({
    required this.store,
    required this.photoFiles,
    required this.item,
  });

  @override
  List<Object> get props => [store, photoFiles, item];
}

class LoadItem extends ItemFactoryEvent {
  final String? itemID;

  const LoadItem({required this.itemID});

  @override
  List<Object?> get props => [itemID];
}
