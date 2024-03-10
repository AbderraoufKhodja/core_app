import 'package:fibali/bloc/search/bloc.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class RegionsChoice extends StatefulWidget {
  final List<String> searchList;

  final String label;

  const RegionsChoice({
    super.key,
    required this.searchList,
    required this.label,
  });

  @override
  State<RegionsChoice> createState() => _RegionsChoiceState();
}

class _RegionsChoiceState extends State<RegionsChoice> {
  SearchCubit get _searchBloc => BlocProvider.of<SearchCubit>(context);

  @override
  Widget build(BuildContext context) {
    return _searchBloc.selectedRegions == null || _searchBloc.selectedRegions!.isEmpty
        ? ListTile(
            title: Text(RCCubit.instance.getText(R.selected)),
            trailing: Text(widget.label),
            onTap: _openFilterDialog,
          )
        : ListTile(
            title: Wrap(
              children: _searchBloc.selectedRegions!
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
      selectedListData: _searchBloc.selectedRegions,
      height: 480,
      headlineText: RCCubit.instance.getText(R.selectRegions),
      themeData: FilterListThemeData(
        context,
        headerTheme: HeaderThemeData(
          searchFieldHintText: RCCubit.instance.getText(R.searchHere),
        ),
      ),
      enableOnlySingleSelection: true,
      choiceChipLabel: (item) {
        return item;
      },
      validateSelectedItem: (list, val) {
        return list?.contains(val) == true;
      },
      onItemSearch: (region, query) {
        if (region.toLowerCase() == query.toLowerCase()) return true;
        return false;
      },
      onApplyButtonClick: (list) {
        setState(() {
          if (list != null) _searchBloc.selectedRegions = list;
        });
        Navigator.pop(context);
      },
    );
  }
}
