import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_list_tile.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/catalog_items_page.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/seller_orders_page.dart';
import 'package:fibali/ui/pages/my_stores/view_my_store_info_page.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';

class StoreDrawer extends StatefulWidget {
  const StoreDrawer({super.key, required this.store});
  final Store store;
  @override
  State<StoreDrawer> createState() => _StoreDrawerState();
}

class _StoreDrawerState extends State<StoreDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomListTile(
                leading: Iconify(
                  Jam.user,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.storeInfo), //Personal information
                onTap: () => ViewMyStoreInfoPage.show(store: widget.store),
              ),
              CustomListTile(
                leading: Iconify(
                  Jam.grid,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.catalog), //History
                onTap: () => CatalogItemsPage.show(store: widget.store),
              ),
              CustomListTile(
                leading: Iconify(
                  Jam.tag,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.orders), //Orders
                onTap: () => SellerOrdersPage.show(store: widget.store),
              ),
              // CustomListTile(
              //   leading: const Iconify(Jam.ticket),
              //   title: RCCubit.instance.getText(R.coupons), //Coupons
              // ),
              // CustomListTile(
              //   leading: const Iconify(Mdi.redhat),
              //   title: RCCubit.instance.getText(R.subscriptions), //VIP
              // ),
              const PaddedDivider(),
              // CustomListTile(
              //   leading: const Iconify(Jam.directions),
              //   title: RCCubit.instance.getText(R.guidelines), //Guidelines
              // ),
              // CustomListTile(
              //   leading: const Iconify(Jam.link),
              //   title: RCCubit.instance.getText(R.links), //Links
              // ),
              // CustomListTile(
              //   leading: const Iconify(IconParkOutline.necktie),
              //   title: RCCubit.instance.getText(R.workWithUs),
              //   onTap: () => showRegisterBusinessPage(),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
