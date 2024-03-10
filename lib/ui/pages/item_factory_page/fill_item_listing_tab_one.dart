import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/item_tags_list_generator.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/ui/module/multiple_media_selector.dart.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

//TODO: check images picker missmatch images
class FillItemListingTabOne extends StatefulWidget {
  const FillItemListingTabOne({super.key});

  @override
  FillItemListingTabOneState createState() => FillItemListingTabOneState();
}

class FillItemListingTabOneState extends State<FillItemListingTabOne>
    with AutomaticKeepAliveClientMixin<FillItemListingTabOne> {
  final _descriptionController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _keywordsController = TextEditingController();

  List<String> _keywords = [];

  bool get wantKeepAlive => true;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _additionalInfoController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController.text = _itemFactoryBloc.item.description ?? '';
    _additionalInfoController.text = _itemFactoryBloc.item.additionalInfo ?? '';
    _titleController.text = _itemFactoryBloc.item.title ?? '';
    _priceController.text = _itemFactoryBloc.item.price?.toString() ?? '';
    _salePriceController.text = _itemFactoryBloc.item.salePrice?.toString() ?? '';
    _keywords = _itemFactoryBloc.item.keywords?.cast<String>() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(children: widgets),
    );
  }

  List<Widget> get widgets => <Widget>[
        MultipleMediaSelector(
          images: _itemFactoryBloc.item.photoUrls,
          video: _itemFactoryBloc.item.videoUrl,
          onSave: (imageChanges, videoChange) {
            _itemFactoryBloc.item.photoUrls = imageChanges;
            _itemFactoryBloc.item.videoUrl = videoChange;
          },
          heightRation: 2.5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            children: [
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      title: RCCubit.instance.getText(R.title),
                      hint: RCCubit.instance.getText(R.titleHint),
                      description: RCCubit.instance.getText(R.pleaseAddTitle),
                      onChanged: (value) => _itemFactoryBloc.item.title = value,
                      validator: (value) => value?.isNotEmpty == true
                          ? null
                          : RCCubit.instance.getText(R.pleaseFillName),
                      maxLength: 80,
                    ),
                    const PaddedDivider(hight: 4.0),
                    CustomTextField(
                      controller: _descriptionController,
                      title: RCCubit.instance.getText(R.description),
                      hint: RCCubit.instance.getText(R.descriptionHint),
                      description: RCCubit.instance.getText(R.pleaseAddDescription),
                      maxLines: 8,
                      maxLength: 500,
                      onChanged: (value) => _itemFactoryBloc.item.description = value,
                      validator: (value) => value?.isNotEmpty == true
                          ? null
                          : RCCubit.instance.getText(R.fillDescription),
                    ),
                    const PaddedDivider(hight: 4.0),
                    CustomTextField(
                      controller: _additionalInfoController,
                      title: RCCubit.instance.getText(R.additionalInfo),
                      hint: RCCubit.instance.getText(R.additionalInfoHint),
                      description: RCCubit.instance.getText(R.pleaseAddAdditionalInfo),
                      maxLines: 8,
                      maxLength: 1500,
                      onChanged: (value) => _itemFactoryBloc.item.additionalInfo = value,
                    ),
                    ItemTagsListCreator(
                      controller: _keywordsController,
                      title: RCCubit.instance.getText(R.keywords),
                      hint: RCCubit.instance.getText(R.keywordsHint),
                      description: RCCubit.instance.getText(R.pleaseAddTags),
                      validator: (value) => _itemFactoryBloc.item.keywords?.isNotEmpty == true
                          ? null
                          : RCCubit.instance.getText(R.addKeyword),
                      onAdd: () {
                        if (_keywordsController.text.isNotEmpty) {
                          _itemFactoryBloc.item.keywords ??= [];
                          final theseTags =
                              _keywordsController.text.toLowerCase().split(' ').toList();
                          _itemFactoryBloc.item.keywords?.addAll(theseTags);
                          _itemFactoryBloc.item.keywords =
                              _itemFactoryBloc.item.keywords?.toSet().toList();
                          _itemFactoryBloc.item.keywords?.remove('');
                          _keywordsController.clear();
                        }
                      },
                    ),
                    if (_itemFactoryBloc.item.keywords?.isNotEmpty == true)
                      Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.start,
                        children: _itemFactoryBloc.item.keywords!
                            .map(
                              (label) => Chip(
                                label: Text(label),
                                onDeleted: () {
                                  setState(() {
                                    _itemFactoryBloc.item.keywords?.remove(label);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _priceController,
                      title: RCCubit.instance.getText(R.price),
                      hint: RCCubit.instance.getText(R.priceHint),
                      description: RCCubit.instance.getText(R.pleaseAddPrice),
                      onChanged: (value) => _itemFactoryBloc.item.price = double.parse(value),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.fillPrice),
                    ),
                    const PaddedDivider(hight: 4.0),
                    CustomTextField(
                      controller: _salePriceController,
                      title: RCCubit.instance.getText(R.salePrice),
                      hint: RCCubit.instance.getText(R.salePriceHint),
                      description: RCCubit.instance.getText(R.pleaseAddSalePrice),
                      onChanged: (value) => _itemFactoryBloc.item.salePrice = double.parse(value),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ];
}
