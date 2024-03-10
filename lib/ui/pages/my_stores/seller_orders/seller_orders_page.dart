import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/all_seller_orders_tab.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/pending_seller_orders_tab.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/received_seller_orders_tab.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/refund_seller_orders_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerOrdersPage extends StatelessWidget {
  final Store store;

  const SellerOrdersPage({super.key, required this.store});

  static Future<dynamic>? show({required Store store}) async {
    return Get.to(() => SellerOrdersPage(store: store));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.orders)),
          leading: const PopButton(),
          bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Text(RCCubit.instance.getText(R.all)),
              Text(RCCubit.instance.getText(R.pending)),
              Text(RCCubit.instance.getText(R.received)),
              Text(RCCubit.instance.getText(R.refund)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllSellerOrdersTab(),
            PendingSellerOrdersTab(),
            ReceivedSellerOrdersTab(),
            RefundSellerOrdersTab(),
          ],
        ),
      ),
    );
  }
}
