import 'dart:io';

import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/factory_item_categories_dropdown.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

//TODO: check images picker missmatch images
class ItemInfoPage extends StatefulWidget {
  const ItemInfoPage({super.key});

  @override
  ItemInfoPageState createState() => ItemInfoPageState();
}

class ItemInfoPageState extends State<ItemInfoPage>
    with AutomaticKeepAliveClientMixin<ItemInfoPage> {
  final _descriptionController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _titleController = TextEditingController();
  final _picker = ImagePicker();
  final _categoriesDropdown = const FactoryItemCategoriesDropdown();

  List<String> _keywords = [];

  @override
  bool get wantKeepAlive => true;

  Size get _size => MediaQuery.of(context).size;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController.text = _itemFactoryBloc.item.description ?? '';
    _keywords = _itemFactoryBloc.item.keywords?.cast<String>() ?? [];
    _priceController.text = _itemFactoryBloc.item.price?.toString() ?? '';
    _salePriceController.text = _itemFactoryBloc.item.salePrice?.toString() ?? '';
    _titleController.text = _itemFactoryBloc.item.title ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(padding: const EdgeInsets.all(8), children: [
      _itemFactoryBloc.item.isActive == false
          ? ListTile(
              title: Text(RCCubit.instance.getText(R.restoreItem)),
              trailing: const FaIcon(FontAwesomeIcons.circleInfo),
              onTap: () {
                _itemFactoryBloc.handleRestoreStoreItem(
                  itemID: _itemFactoryBloc.item.itemID!,
                );
              },
              tileColor: Colors.amberAccent,
            )
          : const SizedBox(),
      ListTile(
        title: Text(
          RCCubit.instance.getText(R.titleInfo),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const FaIcon(FontAwesomeIcons.infoCircle),
          onPressed: () {},
        ),
        dense: true,
      ),
      Card(elevation: 0, child: _buildAddImagesCard()),
      Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _titleController,
              title: RCCubit.instance.getText(R.title),
              hint: RCCubit.instance.getText(R.titleHint),
              onChanged: (value) => _itemFactoryBloc.item.title = value,
              validator: (value) =>
                  value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.fillDescription),
            ),
            const PaddedDivider(),
            CustomTextField(
              controller: _descriptionController,
              title: RCCubit.instance.getText(R.description),
              hint: RCCubit.instance.getText(R.descriptionHint),
              onChanged: (value) => _itemFactoryBloc.item.description = value,
              validator: (value) =>
                  value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.fillDescription),
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: _keywordsController,
                    title: RCCubit.instance.getText(R.keywords),
                    hint: RCCubit.instance.getText(R.tagsHint),
                    validator: (value) =>
                        _keywords.isNotEmpty ? null : RCCubit.instance.getText(R.addKeyword),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_keywordsController.text.isNotEmpty) {
                      setState(() {
                        _keywords.add(_keywordsController.text);
                        _keywords = _keywords.toSet().toList();
                        _itemFactoryBloc.item.keywords = _keywords;
                        _keywordsController.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.start,
                children: _keywords
                    .map((label) => Chip(
                          label: Text(label),
                          onDeleted: () {
                            setState(() {
                              _keywords.remove(label);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      Card(elevation: 0, child: _categoriesDropdown),
      Card(
        elevation: 0,
        child: Column(
          children: [
            CustomTextField(
              controller: _priceController,
              title: RCCubit.instance.getText(R.price),
              hint: RCCubit.instance.getText(R.priceHint),
              onChanged: (value) => _itemFactoryBloc.item.price = double.parse(value),
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.fillPrice),
            ),
            const PaddedDivider(),
            CustomTextField(
              controller: _salePriceController,
              title: RCCubit.instance.getText(R.salePrice),
              hint: RCCubit.instance.getText(R.salePriceHint),
              onChanged: (value) => _itemFactoryBloc.item.salePrice = double.parse(value),
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    ]);
  }

  List<Widget> get widgets => <Widget>[];

  Widget _buildAddImagesCard() {
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
          } else {
            _itemFactoryBloc.item.photoUrls = imageFiles;
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
        suffixIcon: (_itemFactoryBloc.item.photoUrls is List<dynamic> &&
                _itemFactoryBloc.item.photoUrls?.isNotEmpty == true)
            ? GridView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: _size.width / 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                key: UniqueKey(),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final _dynamicPhoto = _itemFactoryBloc.item.photoUrls![index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _dynamicPhoto is XFile
                        ? kIsWeb
                            ? Image.network(
                                _dynamicPhoto.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_dynamicPhoto.path),
                                fit: BoxFit.cover,
                              )
                        : PhotoWidget.network(photoUrl: _dynamicPhoto),
                  );
                },
                itemCount: _itemFactoryBloc.item.photoUrls!.length,
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.grey.shade400,
                  size: _size.height / 8,
                ),
              ),
      ),
      validator: (value) => _itemFactoryBloc.item.photoUrls?.isNotEmpty == true
          ? null
          : RCCubit.instance.getText(R.addOneImage),
    );
  }
}
