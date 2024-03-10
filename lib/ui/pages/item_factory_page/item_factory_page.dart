import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/ui/pages/item_factory_page/add_new_item_page.dart';
import 'package:fibali/ui/pages/item_factory_page/update_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:get/get.dart';

class ItemFactoryPage extends StatefulWidget {
  const ItemFactoryPage({super.key, required this.itemID});

  final String? itemID;

  static Future<dynamic>? show({
    required Store? store,
    required String? storeID,
    required String? itemID,
  }) async {
    late Store thisStore;
    if (store != null) {
      thisStore = store;
    } else {
      assert(storeID != null);
      final doc = await Store.ref.doc(storeID).get();
      if (doc.data()?.isValid() != true) {
        return Get.snackbar('Error', 'Store not found');
      }

      thisStore = doc.data()!;
    }

    return Get.to(
      () => BlocProvider(
        create: (context) => ItemFactoryBloc(store: thisStore)..add(LoadItem(itemID: itemID)),
        child: ItemFactoryPage(itemID: itemID),
      ),
    );
  }

  @override
  State<ItemFactoryPage> createState() => _ItemFactoryPageState();
}

class _ItemFactoryPageState extends State<ItemFactoryPage>
    with AutomaticKeepAliveClientMixin<ItemFactoryPage> {
  @override
  bool get wantKeepAlive => true;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ItemFactoryBloc, ItemFactoryState>(
      builder: (context, state) {
        if (state is ItemFactoryInitial) {
          _itemFactoryBloc.add(LoadItem(itemID: widget.itemID));
        }

        if (state is ItemFactoryLoading) {
          return const LoadingGrid();
        }

        if (state is ExistingItem) {
          return const UpdateItemPage();
        }

        if (state is NewItem) {
          return const AddNewItemPage();
        }

        return const SizedBox();
      },
    );
  }
}
