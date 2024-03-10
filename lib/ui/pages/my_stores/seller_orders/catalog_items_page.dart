import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/item_factory_page/item_factory_page.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/seller_store_items_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CatalogItemsPage extends StatelessWidget {
  final Store store;

  const CatalogItemsPage({super.key, required this.store});

  static Future<dynamic>? show({required Store store}) {
    return Get.to(() => CatalogItemsPage(store: store));
  }

  @override
  Widget build(BuildContext context) {
    final RCCubit rc = BlocProvider.of<RCCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.catalog)),
        leading: const PopButton(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => ItemFactoryPage.show(
          store: store,
          storeID: null,
          itemID: null,
        ),
      ),
      body: SellerStoreItemsListWidget(store: store),
    );
  }
}
