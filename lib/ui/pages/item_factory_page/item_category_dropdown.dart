import 'package:fibali/bloc/item_factory/item_factory_bloc.dart';
import 'package:fibali/categories.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/all_categories.dart';
import 'package:fibali/ui/widgets/categories_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:get/get.dart';

class ItemCategoriesDropdown extends StatefulWidget {
  const ItemCategoriesDropdown({super.key});

  @override
  ItemCategoriesDropdownState createState() => ItemCategoriesDropdownState();
}

class ItemCategoriesDropdownState extends State<ItemCategoriesDropdown> {
  late final _categories1 = mainCategories['en'] as List<String>;
  List<String> _categories2 = [];
  List<String> _categories3 = [];
  List<String> _categories4 = [];
  List<String> _categories5 = [];
  List<String> _categories6 = [];

  late final _labelsCategories1 = getLocalCategories();
  List<String> _categoriesLabels2 = [];
  List<String> _categoriesLabels3 = [];
  List<String> _categoriesLabels4 = [];
  List<String> _categoriesLabels5 = [];
  List<String> _categoriesLabels6 = [];

  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    initCategories();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CategoriesDropdownItem(
              items: _categories1,
              labels: _labelsCategories1,
              hint: RCCubit.instance.getText(R.category),
              value: _itemFactoryBloc.item.category1,
              onChanged: (value) {
                if (value != null) {
                  _itemFactoryBloc.item.category1 = value;
                  _categories2 = _getSubCategories(value);
                  _categoriesLabels2 = _getSubLabelsCategories(value);
                  _itemFactoryBloc.item.category2 = null;
                  _categories3 = [];
                  _categoriesLabels3 = [];
                  _itemFactoryBloc.item.category3 = null;
                  _categories4 = [];
                  _categoriesLabels4 = [];
                  _itemFactoryBloc.item.category4 = null;
                  _categories5 = [];
                  _categoriesLabels5 = [];
                  _itemFactoryBloc.item.category5 = null;
                  _categories6 = [];
                  _categoriesLabels6 = [];
                  _itemFactoryBloc.item.category6 = null;
                }
                setState(() {});
              }),
        ),
        if (_categories2.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Get.width * 1 / 10, bottom: 8.0),
            child: CategoriesDropdownItem(
                items: _categories2,
                labels: _categoriesLabels2,
                hint: RCCubit.instance.getText(R.addSubCategory),
                value: _itemFactoryBloc.item.category2,
                onChanged: (value) {
                  if (value != null) {
                    _itemFactoryBloc.item.category2 = value;
                    _categories3 = _getSubCategories(value);
                    _categoriesLabels3 = _getSubLabelsCategories(value);
                    _itemFactoryBloc.item.category3 = null;
                    _categories4 = [];
                    _categoriesLabels4 = [];
                    _itemFactoryBloc.item.category4 = null;
                    _categories5 = [];
                    _categoriesLabels5 = [];
                    _itemFactoryBloc.item.category5 = null;
                    _categories6 = [];
                    _categoriesLabels6 = [];
                    _itemFactoryBloc.item.category6 = null;
                  }
                  setState(() {});
                }),
          ),
        if (_categories3.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Get.width * 2 / 10, bottom: 8.0),
            child: CategoriesDropdownItem(
                items: _categories3,
                labels: _categoriesLabels3,
                hint: RCCubit.instance.getText(R.addSubCategory),
                value: _itemFactoryBloc.item.category3,
                onChanged: (value) {
                  if (value != null) {
                    _itemFactoryBloc.item.category3 = value;
                    _categories4 = _getSubCategories(value);
                    _categoriesLabels4 = _getSubLabelsCategories(value);
                    _itemFactoryBloc.item.category4 = null;
                    _categories5 = [];
                    _categoriesLabels5 = [];
                    _itemFactoryBloc.item.category5 = null;
                    _categories6 = [];
                    _categoriesLabels6 = [];
                    _itemFactoryBloc.item.category6 = null;
                  }
                  setState(() {});
                }),
          ),
        if (_categories4.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Get.width * 3 / 10, bottom: 8.0),
            child: CategoriesDropdownItem(
                items: _categories4,
                labels: _categoriesLabels4,
                hint: RCCubit.instance.getText(R.addSubCategory),
                value: _itemFactoryBloc.item.category4,
                onChanged: (value) {
                  if (value != null) {
                    _itemFactoryBloc.item.category4 = value;
                    _categories5 = _getSubCategories(value);
                    _categoriesLabels5 = _getSubLabelsCategories(value);
                    _itemFactoryBloc.item.category5 = null;
                    _categories6 = [];
                    _categoriesLabels6 = [];
                    _itemFactoryBloc.item.category6 = null;
                  }
                  setState(() {});
                }),
          ),
        if (_categories5.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Get.width * 4 / 10, bottom: 8.0),
            child: CategoriesDropdownItem(
                items: _categories5,
                labels: _categoriesLabels5,
                hint: RCCubit.instance.getText(R.addSubCategory),
                value: _itemFactoryBloc.item.category5,
                onChanged: (value) {
                  if (value != null) {
                    _itemFactoryBloc.item.category5 = value;
                    _categories6 = _getSubCategories(value);
                    _categoriesLabels6 = _getSubLabelsCategories(value);
                    _itemFactoryBloc.item.category6 = null;
                  }
                  setState(() {});
                }),
          ),
        if (_categories6.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Get.width * 5 / 10, bottom: 8.0),
            child: CategoriesDropdownItem(
                items: _categories6,
                labels: _categoriesLabels6,
                hint: RCCubit.instance.getText(R.addSubCategory),
                value: _itemFactoryBloc.item.category6,
                onChanged: (value) {
                  if (value != null) {
                    _itemFactoryBloc.item.category6 = value;
                  }
                  setState(() {});
                }),
          ),
      ],
    );
  }

  void initCategories() {
    if (_itemFactoryBloc.item.category1 is String) {
      _categories2 = _getSubCategories(_itemFactoryBloc.item.category1!);
      _categoriesLabels2 = _getSubLabelsCategories(_itemFactoryBloc.item.category1!);
    }
    if (_itemFactoryBloc.item.category2 is String) {
      _categories3 = _getSubCategories(_itemFactoryBloc.item.category2!);
      _categoriesLabels3 = _getSubLabelsCategories(_itemFactoryBloc.item.category2!);
    }
    if (_itemFactoryBloc.item.category3 is String) {
      _categories4 = _getSubCategories(_itemFactoryBloc.item.category3!);
      _categoriesLabels4 = _getSubLabelsCategories(_itemFactoryBloc.item.category3!);
    }
    if (_itemFactoryBloc.item.category4 is String) {
      _categories5 = _getSubCategories(_itemFactoryBloc.item.category4!);
      _categoriesLabels5 = _getSubLabelsCategories(_itemFactoryBloc.item.category4!);
    }
    if (_itemFactoryBloc.item.category5 is String) {
      _categories6 = _getSubCategories(_itemFactoryBloc.item.category5!);
      _categoriesLabels6 = _getSubLabelsCategories(_itemFactoryBloc.item.category5!);
    }
  }

  List<String> _getSubCategories(String value) {
    return allCategories.values
        .map((categoryMap) => categoryMap.map(
              (key, value) => MapEntry(key, value!.split(' > ')),
            ))
        .where((e1) => e1.values.any((element) => element.contains(value)))
        .map((e2) {
          final idx = e2["en"]!.indexOf(value) + 1;
          if (e2["en"]!.length == idx) {
            return <String>[];
          } else {
            return e2["en"]!.sublist(idx);
          }
        })
        .where((element) => element.isNotEmpty)
        .map((element) => element.first)
        .toSet()
        .toList();
  }

  List<String> _getSubLabelsCategories(String value) {
    final appLanguage = BlocProvider.of<SettingsCubit>(Get.context!).state.appLanguage;
    if (appLanguage == 'fr') {
      return allCategories.values
          .map((categoryMap) => categoryMap.map(
                (key, value) => MapEntry(key, value!.split(' > ')),
              ))
          .where((e1) => e1.values.any((element) => element.contains(value)))
          .map((e2) {
            final idx = e2["en"]!.indexOf(value) + 1;
            if (e2["en"]!.length == idx) {
              return <String>[];
            } else {
              return e2["fr"]!.sublist(idx);
            }
          })
          .where((element) => element.isNotEmpty)
          .map((element) => element.first)
          .toSet()
          .toList();
    } else if (appLanguage == 'ar') {
      return allCategories.values
          .map((categoryMap) => categoryMap.map(
                (key, value) => MapEntry(key, value!.split(' > ')),
              ))
          .where((e1) => e1.values.any((element) => element.contains(value)))
          .map((e2) {
            final idx = e2["en"]!.indexOf(value) + 1;
            if (e2["en"]!.length == idx) {
              return <String>[];
            } else {
              return e2["ar"]!.sublist(idx);
            }
          })
          .where((element) => element.isNotEmpty)
          .map((element) => element.first)
          .toSet()
          .toList();
    }

    // Default (english)
    return allCategories.values
        .map((categoryMap) => categoryMap.map(
              (key, value) => MapEntry(key, value!.split(' > ')),
            ))
        .where((e1) => e1.values.any((element) => element.contains(value)))
        .map((e2) {
          final idx = e2["en"]!.indexOf(value) + 1;
          if (e2["en"]!.length == idx) {
            return <String>[];
          } else {
            return e2["en"]!.sublist(idx);
          }
        })
        .where((element) => element.isNotEmpty)
        .map((element) => element.first)
        .toSet()
        .toList();
  }
}
