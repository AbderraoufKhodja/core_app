import 'package:fibali/bloc/search/bloc.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class CategoriesChoice extends StatefulWidget {
  final List<String> searchList;

  final String label;

  const CategoriesChoice({
    super.key,
    required this.searchList,
    required this.label,
  });

  @override
  State<CategoriesChoice> createState() => _CategoriesChoiceState();
}

class _CategoriesChoiceState extends State<CategoriesChoice> {
  SearchCubit get _searchBloc => BlocProvider.of<SearchCubit>(context);

  @override
  Widget build(BuildContext context) {
    return _searchBloc.selectedSubCategories == null || _searchBloc.selectedSubCategories!.isEmpty
        ? ListTile(
            title: Text(RCCubit.instance.getText(R.selected)),
            trailing: Text(widget.label),
            onTap: _openFilterDialog,
          )
        : ListTile(
            title: Wrap(
              children: _searchBloc.selectedSubCategories!
                  .map(
                    (item) => Chip(label: Text(item)),
                  )
                  .toList(),
            ),
            trailing: Text(widget.label),
            onTap: _openFilterDialog,
          );
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: widget.searchList,
      selectedListData: _searchBloc.selectedSubCategories,
      height: 480,
      enableOnlySingleSelection: true,
      headlineText: RCCubit.instance.getText(R.selectCategories),
      themeData: FilterListThemeData(
        context,
        headerTheme: HeaderThemeData(
          searchFieldHintText: RCCubit.instance.getText(R.searchHere),
        ),
      ),
      choiceChipLabel: (item) {
        return item;
      },
      validateSelectedItem: (list, val) {
        return list?.contains(val) == true;
      },
      onItemSearch: (word, query) {
        if (word.toLowerCase() == query.toLowerCase()) return true;
        return false;
      },
      onApplyButtonClick: (list) {
        setState(() {
          if (list != null) _searchBloc.selectedSubCategories = list;
        });
        Navigator.pop(context);
      },
    );
  }
}
