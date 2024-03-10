import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/item_factory_page/add_item_variants_page.dart';
import 'package:fibali/ui/pages/item_factory_page/fill_item_source_page.dart';
import 'package:fibali/ui/pages/item_factory_page/item_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class UpdateItemPage extends StatefulWidget {
  const UpdateItemPage({super.key});

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.updateInfo)),
          leading: const PopButton(),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            tabs: [
              Text(RCCubit.instance.getText(R.item)),
              Text(RCCubit.instance.getText(R.variants)),
              Text(RCCubit.instance.getText(R.source)),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: _itemFactoryBloc.item.isActive == true
                        ? RCCubit.instance.getText(R.hideItem)
                        : RCCubit.instance.getText(R.restoreItem),
                    child: Text(_itemFactoryBloc.item.isActive == true
                        ? RCCubit.instance.getText(R.hideItem)
                        : RCCubit.instance.getText(R.restoreItem)),
                    onTap: () {
                      if (_itemFactoryBloc.item.isActive == true) {
                        _itemFactoryBloc.handleHideStoreItem(
                          itemID: _itemFactoryBloc.item.itemID!,
                        );
                      } else {
                        _itemFactoryBloc.handleRestoreStoreItem(
                          itemID: _itemFactoryBloc.item.itemID!,
                        );
                      }
                    },
                  ),
                  PopupMenuItem<String>(
                    value: RCCubit.instance.getText(R.remove),
                    child: Text(RCCubit.instance.getText(R.remove)),
                    onTap: () {
                      _itemFactoryBloc.handleRemoveStoreItem(itemID: _itemFactoryBloc.item.itemID!);
                    },
                  ),
                ];
              },
            ),
          ],
          centerTitle: true,
          elevation: 1,
        ),
        body: const TabBarView(
          children: [
            ItemInfoPage(),
            AddItemVariantsPage(),
            FillItemSourcePage(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _itemFactoryBloc.handleUpdateExistingItem(
                    context,
                    item: _itemFactoryBloc.item,
                    store: _itemFactoryBloc.store,
                  ),
                  child: Text(RCCubit.instance.getText(R.updateInfo)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
