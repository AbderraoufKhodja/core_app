import 'package:ae_api/ae_api.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/main_products.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedPromoProductsPage extends StatefulWidget {
  const FeaturedPromoProductsPage({super.key, required this.promotionName, required this.product});

  final Product product;
  final String promotionName;

  static show({required String promoName, required Product product}) =>
      Get.to(() => FeaturedPromoProductsPage(
            promotionName: promoName,
            product: product,
          ));

  @override
  FeaturedPromoProductsPageState createState() => FeaturedPromoProductsPageState();
}

class FeaturedPromoProductsPageState extends State<FeaturedPromoProductsPage> {
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final tabs = AeCategories.parentCategories;

    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          key: key,
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    expandedHeight: 260.0,
                    collapsedHeight: 0.0,
                    toolbarHeight: 0.0,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      background: Column(
                        children: [
                          ColoredBox(
                              color: Colors.red.shade400,
                              child: SizedBox(
                                height: 240,
                                width: Get.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Sale ends in 2 days',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              )),
                          MainProducts(promotionName: widget.promotionName),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: ColoredBox(
                        color: Get.theme.cardColor,
                        child: TabBar(
                          isScrollable: true,
                          tabs: tabs
                              .map((category) => Tab(text: category['category_name'].toString()))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: tabs.map((category) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>(category['category_id'].toString()),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          ProductsGrid(
                            promotionName: widget.promotionName,
                            categoryName: category['category_id'].toString(),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
