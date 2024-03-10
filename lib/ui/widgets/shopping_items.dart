import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/shopping_not_available.dart';
import 'package:fibali/ui/widgets/categories_navigation.dart';
import 'package:fibali/ui/widgets/item_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ShoppingItems extends StatefulWidget {
  const ShoppingItems({super.key});

  @override
  ShoppingItemsState createState() => ShoppingItemsState();
}

class ShoppingItemsState extends State<ShoppingItems>
    with AutomaticKeepAliveClientMixin<ShoppingItems> {
  @override
  bool get wantKeepAlive => true;

  BusinessCubit get _searchCubit => BlocProvider.of<BusinessCubit>(context);

  @override
  void initState() {
    super.initState();
    _searchCubit.refreshSearchRef();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildItems();
  }

  Widget buildItems() {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {
        if (_searchCubit.showGlobalRail) {
          _searchCubit.controller?.reverse();
        } else {
          _searchCubit.controller?.forward();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (_searchCubit.categories2.isNotEmpty == true) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity!.compareTo(800) > 0) {
                  setState(() {
                    _searchCubit.showGlobalRail = true;
                    _searchCubit.updateCategoriesWidget();
                  });
                }
                if (details.primaryVelocity!.compareTo(-800) < 0) {
                  setState(() {
                    _searchCubit.showGlobalRail = false;
                    _searchCubit.updateCategoriesWidget();
                  });
                }
              }
            }
          },
          child: BlocBuilder<BusinessCubit, BusinessState>(
            buildWhen: (previous, current) => current is BusinessRefUpdated,
            builder: (context, state) {
              return Row(
                children: [
                  AnimatedContainer(
                    width: _searchCubit.showGlobalRail ? Get.width / 6 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: const CategoriesNavigation(),
                  ),
                  Expanded(
                    child: FirestoreQueryBuilder<Item>(
                      query: _searchCubit.searchRef,
                      builder: (context, snapshot, _) {
                        if (snapshot.isFetching) {
                          return LoadingGrid(
                            width: _searchCubit.showGlobalRail
                                ? Get.width - (Get.width / 6)
                                : Get.width,
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('error ${snapshot.error}');
                        }

                        if (snapshot.docs.isEmpty == true) {
                          return const ShoppingNotAvailableWidget();
                        }

                        final widgets = snapshot.docs
                            .map((doc) => doc.data())
                            .where((item) => item.isValid())
                            .map(
                          (item) {
                            return GestureDetector(
                              onTap: () {
                                showItemPage(
                                  itemID: item.itemID!,
                                  photo: item.photoUrls![0],
                                  storeID: item.storeID!,
                                );
                              },
                              child: ItemCard(item: item),
                            );
                          },
                        ).toList();

                        return MasonryGridView.count(
                          mainAxisSpacing: 4.0,
                          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
                          itemBuilder: (context, index) {
                            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                              snapshot.fetchMore();
                            }

                            return widgets[index];
                          },
                          itemCount: widgets.length,
                          crossAxisCount: 2,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
