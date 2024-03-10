import 'dart:io';

import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/widgets/divider_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

//TODO: check images picker missmatch images
class AddItemPhotosTab extends StatefulWidget {
  const AddItemPhotosTab({super.key});

  @override
  AddItemPhotosTabState createState() => AddItemPhotosTabState();
}

class AddItemPhotosTabState extends State<AddItemPhotosTab>
    with AutomaticKeepAliveClientMixin<AddItemPhotosTab> {
  final _picker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // DividerTile(
          //   title: RCCubit.instance.getText( R.itemPhotos),
          //   subtitle: RCCubit.instance.getText( R.pleaseAddItemPhotos),
          // ),
          // _buildAddItemPhotosCard(),
          DividerTile(
            title: RCCubit.instance.getText(R.additionalItemPhotos),
            subtitle: RCCubit.instance.getText(R.pleaseAddAdditionalItemPhotos),
          ),
          _buildAddAdditionalPhotos(),
        ],
      ),
    );
  }

  Widget _buildAddItemPhotosCard() {
    return TextFormField(
      cursorHeight: 0,
      onTap: () async {
        final imageFiles = await _picker.pickMultiImage();
        if (imageFiles.isNotEmpty) {
          if (imageFiles.length > 6) {
            Get.showSnackbar(GetSnackBar(
              messageText: Text(RCCubit.instance.getText(R.sixImagesMax)),
            ));
            _itemFactoryBloc.item.photoUrls = imageFiles.sublist(0, 6);
          } else
            _itemFactoryBloc.item.photoUrls = imageFiles;
          setState(() {});
        }
      },
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: RCCubit.instance.getText(R.addImages),
        suffixIcon: (_itemFactoryBloc.item.photoUrls is List<dynamic> &&
                _itemFactoryBloc.item.photoUrls?.isNotEmpty == true)
            ? Center(
                child: ReorderableWrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  padding: const EdgeInsets.all(8),
                  children: _itemFactoryBloc.item.photoUrls!.map(
                    (dynamicPhoto) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: dynamicPhoto is XFile
                            ? kIsWeb
                                ? PhotoWidget.network(
                                    photoUrl: dynamicPhoto.path,
                                    fit: BoxFit.cover,
                                    height: Get.width / 3.4,
                                    width: Get.width / 3.4,
                                  )
                                : PhotoWidget.file(
                                    file: File(dynamicPhoto.path),
                                    fit: BoxFit.cover,
                                    height: Get.width / 3.4,
                                    width: Get.width / 3.4,
                                  )
                            : PhotoWidget.network(photoUrl: dynamicPhoto),
                      );
                    },
                  ).toList(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final _temp = _itemFactoryBloc.item.photoUrls!.removeAt(oldIndex);
                      _itemFactoryBloc.item.photoUrls!.insert(newIndex, _temp);
                    });
                  },
                  onNoReorder: (int index) {},
                  onReorderStarted: (int index) {},
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.grey.shade400,
                  size: Get.height / 8,
                ),
              ),
      ),
      validator: (value) => _itemFactoryBloc.item.photoUrls?.isNotEmpty == true
          ? null
          : RCCubit.instance.getText(R.addOneImage),
    );
  }

  Widget _buildAddAdditionalPhotos() {
    return TextFormField(
      cursorHeight: 0,
      onTap: () async {
        final imageFiles = await _picker.pickMultiImage();
        if (imageFiles.isNotEmpty) {
          if (imageFiles.length > 10) {
            Get.showSnackbar(GetSnackBar(
              messageText: Text(RCCubit.instance.getText(R.tenImagesMax)),
            ));
            _itemFactoryBloc.item.additionalPhotos = imageFiles.sublist(0, 10);
          } else {
            _itemFactoryBloc.item.additionalPhotos = imageFiles;
          }
          setState(() {});
        }
      },
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: RCCubit.instance.getText(R.addImages),
        suffixIcon: (_itemFactoryBloc.item.additionalPhotos is List<dynamic> &&
                _itemFactoryBloc.item.additionalPhotos?.isNotEmpty == true)
            ? Center(
                child: ReorderableWrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  padding: const EdgeInsets.all(8),
                  children: _itemFactoryBloc.item.additionalPhotos!.map(
                    (dynamicPhoto) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: dynamicPhoto is XFile
                            ? kIsWeb
                                ? PhotoWidget.network(
                                    photoUrl: dynamicPhoto.path,
                                    fit: BoxFit.cover,
                                    height: Get.width / 3.4,
                                    width: Get.width / 3.4,
                                  )
                                : PhotoWidget.file(
                                    file: File(dynamicPhoto.path),
                                    fit: BoxFit.cover,
                                    height: Get.width / 3.4,
                                    width: Get.width / 3.4,
                                  )
                            : PhotoWidget.network(photoUrl: dynamicPhoto),
                      );
                    },
                  ).toList(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final _temp = _itemFactoryBloc.item.additionalPhotos!.removeAt(oldIndex);
                      _itemFactoryBloc.item.additionalPhotos!.insert(newIndex, _temp);
                    });
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.grey.shade400,
                  size: Get.height / 8,
                ),
              ),
      ),
    );
  }
}
