import 'dart:ui';

import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/item_factory_page/item_factory_page.dart';
import 'package:fibali/ui/pages/my_stores/edit_my_store_info_page.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/seller_orders_page.dart';

import 'package:fibali/ui/pages/my_stores/seller_orders/seller_store_items_list_widget.dart';
import 'package:fibali/ui/pages/my_stores/store_drawer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:iconify_flutter/icons/mi.dart';

class MySellerStorePage extends StatefulWidget {
  final Store store;

  const MySellerStorePage({super.key, required this.store});

  static Future<dynamic>? show({required Store store}) async {
    return Get.to(() => MySellerStorePage(store: store));
  }

  @override
  MySellerStorePageState createState() => MySellerStorePageState();
}

class MySellerStorePageState extends State<MySellerStorePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _key,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => ItemFactoryPage.show(
            store: widget.store,
            storeID: null,
            itemID: null,
          ),
        ),
        endDrawer: Drawer(child: StoreDrawer(store: widget.store)),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: const PopButton(),
              actions: [
                IconButton(
                  icon: const Iconify(Mi.three_rows, color: Colors.white70),
                  onPressed: () => _key.currentState!.openEndDrawer(),
                )
              ],
              pinned: true,
              snap: true,
              floating: true,
              elevation: 0,
              backgroundColor: const Color(0xFF142526),
              expandedHeight: 290.0,
              toolbarHeight: 60.0,
              leadingWidth: 60.0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          icon: Iconify(
                            Jam.tag,
                            color: Colors.grey.shade300,
                          ),
                          label: Text(RCCubit.instance.getText(R.orders),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.grey.shade300)),
                          onPressed: () {
                            SellerOrdersPage.show(store: widget.store);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                background: Stack(
                  children: [
                    if (widget.store.background != null)
                      PhotoWidget.network(
                        photoUrl: widget.store.background!,
                        fit: BoxFit.cover,
                        width: _size.width,
                        height: _size.height / 2,
                      ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 60,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildHeader(),
                          const Divider(color: Colors.white),
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.store.description != null)
                                    Text(
                                      widget.store.description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      CurvedButton(
                                        onTap: () => EditMyStoreInfoPage.show(
                                          store: widget.store,
                                          onSubmitted: () {},
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          RCCubit.instance.getText(R.editStore),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Text(RCCubit.instance.getText(R.catalog)),
                  ],
                ),
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height: _size.height - 180,
                  width: _size.width,
                  child: TabBarView(
                    children: [
                      SellerStoreItemsListWidget(store: widget.store),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Row buildLocationTile() {
    return Row(
      children: [
        const Iconify(
          EmojioneMonotone.flag_for_algeria,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(width: 8.0),
        CurvedButton(
          height: 30,
          child: Row(
            children: [
              const Icon(
                FluentIcons.location_16_regular,
                size: 15,
                color: Colors.white,
              ),
              Text(
                  widget.store.province != null
                      ? ' ${widget.store.province!}'
                      : ' add service region',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Row buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 64.0, bottom: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.store.name ?? '',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Status: ${widget.store.status}',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: PhotoWidget.network(
            photoUrl: widget.store.logo,
            boxShape: BoxShape.circle,
            height: 80,
            width: 80,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // margin: EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      // padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
