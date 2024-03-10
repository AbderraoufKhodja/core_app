import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/item_category_dropdown.dart';
import 'package:fibali/ui/widgets/divider_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

//TODO: check images picker missmatch images
class FillItemListingTabTwo extends StatefulWidget {
  const FillItemListingTabTwo({super.key});

  @override
  FillItemListingTabTwoState createState() => FillItemListingTabTwoState();
}

class FillItemListingTabTwoState extends State<FillItemListingTabTwo>
    with AutomaticKeepAliveClientMixin<FillItemListingTabTwo> {
  final _categoriesDropdown = const ItemCategoriesDropdown();

  List<String> _keywords = [];

  bool get wantKeepAlive => true;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _keywords = _itemFactoryBloc.item.keywords?.cast<String>() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widgets
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: widget,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        DividerTile(
          title: RCCubit.instance.getText(R.category),
          subtitle: RCCubit.instance.getText(R.pleaseAddCategory),
        ),
        _categoriesDropdown,
      ];
}
