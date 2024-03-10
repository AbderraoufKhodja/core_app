import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_product_card.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/hot_products_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AeShoppingTab extends StatefulWidget {
  const AeShoppingTab({super.key});

  @override
  AeShoppingTabState createState() => AeShoppingTabState();
}

class AeShoppingTabState extends State<AeShoppingTab> {
  AeBusinessCubit get _searchCubit => BlocProvider.of<AeBusinessCubit>(context);

  @override
  void initState() {
    super.initState();
    if (_searchCubit.state is AeBusinessInitial) {
      _searchCubit.initGetMainAeProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AeBusinessCubit, AeBusinessState>(
      buildWhen: _buildWhen,
      builder: _builder,
    );
  }

  Widget _builder(context, state) {
    final widgets = <Widget>[
      ..._searchCubit.displayedProducts.map((product) => AeProductCard(product: product)),
    ];

    if (state is AeBusinessError) {
      debugPrint(state.message);
      return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
    }

    final tabs = <String>['For you', 'New'];
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: false,
                  // expandedHeight: 450.0,
                  expandedHeight: 400.0,
                  collapsedHeight: 0.0,
                  toolbarHeight: 0.0,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: _buildBackground(),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight + 60),
                    child: ColoredBox(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                            height: 0,
                            thickness: 4,
                            color: Colors.grey.shade100,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                            child: Text('We think you\'ll like these too',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      wordSpacing: 0,
                                      letterSpacing: 0,
                                    )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                            child: TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(letterSpacing: 0.1, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(letterSpacing: 0.0),
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black,
                              padding: const EdgeInsets.all(0),
                              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                              indicatorPadding: const EdgeInsets.all(0),
                              indicator: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              tabs: tabs
                                  .map((String name) => Tab(
                                        text: name,
                                        height: 30,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            // These are the contents of the tab views, below the tabs.
            children: tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  // This Builder is needed to provide a BuildContext that is
                  // "inside" the NestedScrollView, so that
                  // sliverOverlapAbsorberHandleFor() can find the
                  // NestedScrollView.
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      // The "controller" and "primary" members should be left
                      // unset, so that the NestedScrollView can control this
                      // inner scroll view.
                      // If the "controller" property is set, then this scroll
                      // view will not be associated with the NestedScrollView.
                      // The PageStorageKey should be unique to this ScrollView;
                      // it allows the list to remember its scroll position when
                      // the tab view is not on the screen.
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverMasonryGrid.count(
                          itemBuilder: (context, index) {
                            if (_searchCubit.state is AeMainProductsLoaded) {
                              if ((_searchCubit.hasMore == true) && index + 1 == widgets.length) {
                                _searchCubit.getMainMoreAeProducts();
                              }
                            }
                            if (_searchCubit.state is AeQueryProductsLoaded) {
                              if ((_searchCubit.query1HasMore == true) &&
                                  index + 1 == widgets.length) {
                                _searchCubit.getQueryMoreAeProducts();
                              }
                            }

                            return widgets[index];
                          },
                          childCount: widgets.length,
                          crossAxisCount: 2,
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
    );
  }

  Column _buildBackground() {
    const categoriesImages = {
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/Sa60c45c7822f4b90a3b3933121fbbcbcN/440x440.png_480x480.png_.webp",
        "name": "Electronics",
        'category_ids': [44]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S1a23b2690ccb4bf184a36abfe2b84e10A/440x440.png_480x480.png_.webp",
        "name": "Men's Clothing",
        'category_ids': [200000343]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S7d7842a1811c40d381b291093e7e6b44i/440x440.png_480x480.png_.webp",
        "name": "Jewelry, Watches & Accessories",
        "category_ids": [36, 1511]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/Scf0db78b715440389d2793da087c89d24/440x440.png_480x480.png_.webp",
        "name": "Sports & Entertainment",
        "category_ids": [18]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/Scff639e6d81b4ad98b694873cac35d7db/440x440.png_480x480.png_.webp",
        "name": "Luggage, Bags & Shoes",
        "category_ids": [1524, 322]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S8243e69aaf1c423682fc614a60b957bbn/440x440.png_480x480.png_.webp",
        "name": "Home Improvement & Lighting",
        "category_ids": [13, 39]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S3b6c9b38f6a84e648d61204846191266t/440x440.png_480x480.png_.webp",
        "name": "Home & Garden",
        "category_ids": [15]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S182769c2595148ed93a2dc78b31dc96a5/440x440.png_480x480.png_.webp",
        "name": "Beauty & Health",
        "category_ids": [66]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S44f59311d0f7498f8a1d5c997e854dd0i/440x440.png_480x480.png_.webp",
        "name": "Toys & Games",
        "category_ids": [26]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S14bc071ed2414249b7d49f875f4dd486T/440x440.png_480x480.png_.webp",
        "name": "Automotive & Motorcycle",
        "category_ids": [34, 201355758]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/Sf590feda1750435a920b49ca09f75220W/440x440.png_480x480.png_.webp",
        "name": "Pet Supplies",
        "category_ids": [100006664]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/Sd5e7b5601c78458d8a4b4a024602e327S/440x440.png_480x480.png_.webp",
        "name": "Plus Sized Clothing",
        "category_ids": [201524501]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S4848a64a51c4419f8ba97f8573ae80e2D/440x440.png_480x480.png_.webp",
        "name": "Hair Extensions & Wigs",
        "category_ids": [200245144]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S1d99ec8263754e49a138aa37ac6585f4E/440x440.png_480x480.png_.webp",
        "name": "Computer, Office & Education",
        "category_ids": [7, 21]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S58b9811454e14026b7261cc264cfff3fY/440x440.png_480x480.png_.webp",
        "name": "Phones & Telecommunications",
        "category_ids": [509]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S09f53523788f4b7f82a56e8bc7684b1dh/440x440.png_480x480.png_.webp",
        "name": "Babies & Kids",
        "category_ids": [1501]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S8d22e67f26b546478403f0b427d8cd19j/440x440.png_480x480.png_.webp",
        "name": "Furniture",
        "category_ids": [1503]
      },
      {
        "imageUrl":
            "https://ae01.alicdn.com/kf/S4731795737da45c09cc23bbc25f1bdf1I/440x440.png_480x480.png_.webp",
        "name": "Women's Clothing",
        "category_ids": [200000345]
      }
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final widget = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: PhotoWidget.network(
                        photoUrl: categoriesImages.elementAt(index)['imageUrl'].toString(),
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 65,
                    child: Text(
                      categoriesImages.elementAt(index)['name'].toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );

              return Padding(
                padding: index == 0
                    ? const EdgeInsets.only(left: 16.0, right: 8.0)
                    : const EdgeInsets.symmetric(horizontal: 8.0),
                child: widget,
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('TRENDING',
                          style: GoogleFonts.righteousTextTheme().titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              )),
                      const Gap(2),
                      Text('NOW',
                          style: GoogleFonts.righteousTextTheme().titleLarge?.copyWith(
                                color: Colors.red[600],
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              )),
                    ],
                  ),
                  Text('Top products, Incredible prices.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          )),
                ],
              ),
            ),
            const SizedBox(
              height: 210,
              child: HotProductsListView(),
            ),
          ],
        ),
      ],
    );
  }

  bool _buildWhen(previous, current) =>
      previous is AeBusinessLoading && current is AeMainProductsLoaded;
}
