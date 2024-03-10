import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/ui/widgets/categories_list_view_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  CategoriesListViewState createState() => CategoriesListViewState();
}

class CategoriesListViewState extends State<CategoriesListView> {
  BusinessCubit get _searchCubit => BlocProvider.of<BusinessCubit>(context);

  @override
  Widget build(BuildContext context) {
    initCategories();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CategoriesListViewItem(
            items: _searchCubit.categories1,
            labels: _searchCubit.categoriesLabels1,
            hint: RCCubit.instance.getText(R.addSubCategory),
            value: _searchCubit.category1,
            onChanged: (value) {
              if (value != null) {
                _searchCubit.category1 = value;
                _searchCubit.categories2 = _searchCubit.getSubCategories(value);
                _searchCubit.categoriesLabels2 =
                    _searchCubit.getSubLabelsCategories(context, value: value);
                _searchCubit.category2 = null;
                _searchCubit.categories3 = [];
                _searchCubit.categoriesLabels3 = [];
                _searchCubit.category3 = null;
                _searchCubit.categories4 = [];
                _searchCubit.categoriesLabels4 = [];
                _searchCubit.category4 = null;
                _searchCubit.categories5 = [];
                _searchCubit.categoriesLabels5 = [];
                _searchCubit.category5 = null;
                _searchCubit.categories6 = [];
                _searchCubit.categoriesLabels6 = [];
                _searchCubit.category6 = null;
              }
            }),
        // if (_searchCubit.categories2.isNotEmpty)
        //   CategoriesListViewItem(
        //       items: _searchCubit.categories2,
        //       labels: _searchCubit.categoriesLabels2,
        //       hint: RCCubit.instance.getText(R.addSubCategory),
        //       value: _searchCubit.category2,
        //       onChanged: (value) {
        //         if (value != null) {
        //           _searchCubit.category2 = value;
        //           _searchCubit.categories3 = _searchCubit.getSubCategories(value);
        //           _searchCubit.categoriesLabels3 = _searchCubit.getSubLabelsCategories(context, value: value);
        //           _searchCubit.category3 = null;
        //           _searchCubit.categories4 = [];
        //           _searchCubit.categoriesLabels4 = [];
        //           _searchCubit.category4 = null;
        //           _searchCubit.categories5 = [];
        //           _searchCubit.categoriesLabels5 = [];
        //           _searchCubit.category5 = null;
        //           _searchCubit.categories6 = [];
        //           _searchCubit.categoriesLabels6 = [];
        //           _searchCubit.category6 = null;
        //         }
        //         setState(() {});
        //       }),
        if (_searchCubit.categories3.isNotEmpty)
          CategoriesListViewItem(
              items: _searchCubit.categories3,
              labels: _searchCubit.categoriesLabels3,
              hint: RCCubit.instance.getText(R.addSubCategory),
              value: _searchCubit.category3,
              onChanged: (value) {
                if (value != null) {
                  _searchCubit.category3 = value;
                  _searchCubit.categories4 = _searchCubit.getSubCategories(value);
                  _searchCubit.categoriesLabels4 =
                      _searchCubit.getSubLabelsCategories(context, value: value);
                  _searchCubit.category4 = null;
                  _searchCubit.categories5 = [];
                  _searchCubit.categoriesLabels5 = [];
                  _searchCubit.category5 = null;
                  _searchCubit.categories6 = [];
                  _searchCubit.categoriesLabels6 = [];
                  _searchCubit.category6 = null;
                }
                setState(() {});
              }),
        if (_searchCubit.categories4.isNotEmpty)
          CategoriesListViewItem(
              items: _searchCubit.categories4,
              labels: _searchCubit.categoriesLabels4,
              hint: RCCubit.instance.getText(R.addSubCategory),
              value: _searchCubit.category4,
              onChanged: (value) {
                if (value != null) {
                  _searchCubit.category4 = value;
                  _searchCubit.categories5 = _searchCubit.getSubCategories(value);
                  _searchCubit.categoriesLabels5 =
                      _searchCubit.getSubLabelsCategories(context, value: value);
                  _searchCubit.category5 = null;
                  _searchCubit.categories6 = [];
                  _searchCubit.categoriesLabels6 = [];
                  _searchCubit.category6 = null;
                }
                setState(() {});
              }),
        if (_searchCubit.categories5.isNotEmpty)
          CategoriesListViewItem(
              items: _searchCubit.categories5,
              labels: _searchCubit.categoriesLabels5,
              hint: RCCubit.instance.getText(R.addSubCategory),
              value: _searchCubit.category5,
              onChanged: (value) {
                if (value != null) {
                  _searchCubit.category5 = value;
                  _searchCubit.categories6 = _searchCubit.getSubCategories(value);
                  _searchCubit.categoriesLabels6 =
                      _searchCubit.getSubLabelsCategories(context, value: value);
                  _searchCubit.category6 = null;
                }
                setState(() {});
              }),
        if (_searchCubit.categories6.isNotEmpty)
          CategoriesListViewItem(
              items: _searchCubit.categories6,
              labels: _searchCubit.categoriesLabels6,
              hint: RCCubit.instance.getText(R.addSubCategory),
              value: _searchCubit.category6,
              onChanged: (value) {
                if (value != null) {
                  _searchCubit.category6 = value;
                }
                setState(() {});
              }),
      ],
    );
  }

  void initCategories() {
    if (_searchCubit.category1 is String) {
      _searchCubit.categories2 = _searchCubit.getSubCategories(_searchCubit.category1!);
      _searchCubit.categoriesLabels2 =
          _searchCubit.getSubLabelsCategories(context, value: _searchCubit.category1!);
    }
    if (_searchCubit.category2 is String) {
      _searchCubit.categories3 = _searchCubit.getSubCategories(_searchCubit.category2!);
      _searchCubit.categoriesLabels3 =
          _searchCubit.getSubLabelsCategories(context, value: _searchCubit.category2!);
    }
    if (_searchCubit.category3 is String) {
      _searchCubit.categories4 = _searchCubit.getSubCategories(_searchCubit.category3!);
      _searchCubit.categoriesLabels4 =
          _searchCubit.getSubLabelsCategories(context, value: _searchCubit.category3!);
    }
    if (_searchCubit.category4 is String) {
      _searchCubit.categories5 = _searchCubit.getSubCategories(_searchCubit.category4!);
      _searchCubit.categoriesLabels5 =
          _searchCubit.getSubLabelsCategories(context, value: _searchCubit.category4!);
    }
    if (_searchCubit.category5 is String) {
      _searchCubit.categories6 = _searchCubit.getSubCategories(_searchCubit.category5!);
      _searchCubit.categoriesLabels6 =
          _searchCubit.getSubLabelsCategories(context, value: _searchCubit.category5!);
    }
  }
}
