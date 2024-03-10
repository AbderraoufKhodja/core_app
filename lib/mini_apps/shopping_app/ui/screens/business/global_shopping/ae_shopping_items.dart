import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_product_card.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_vertical_sub_categories.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AeShoppingItems extends StatefulWidget {
  const AeShoppingItems({super.key});

  @override
  AeShoppingItemsState createState() => AeShoppingItemsState();
}

class AeShoppingItemsState extends State<AeShoppingItems> {
  AeBusinessCubit get _searchCubit => BlocProvider.of<AeBusinessCubit>(context);

  @override
  void initState() {
    super.initState();
    if (_searchCubit.state is AeBusinessInitial) _searchCubit.initGetMainAeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AeBusinessCubit, AeBusinessState>(
      listener: _listener,
      buildWhen: _buildWhen,
      builder: _builder,
    );
  }

  Widget _builder(context, state) {
    if (state is AeBusinessError) {
      debugPrint(state.message);
      return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
    }

    return Stack(
      children: [
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (_searchCubit.aeSubCategoryID != null) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity!.compareTo(800) > 0) {
                  setState(() {
                    _searchCubit.showGlobalRail = true;
                    _searchCubit.updateAeCategoriesWidget();
                  });
                }
                if (details.primaryVelocity!.compareTo(-800) < 0) {
                  setState(() {
                    _searchCubit.showGlobalRail = false;
                    _searchCubit.updateAeCategoriesWidget();
                  });
                }
              }
            }
          },
          child: Row(
            children: [
              AnimatedContainer(
                width: _searchCubit.showGlobalRail ? Get.width / 6 : 0,
                duration: const Duration(milliseconds: 500),
                child: const AeVerticalSubCategories(),
              ),
              Expanded(
                child: MasonryGridView.count(
                  mainAxisSpacing: 4.0,
                  padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
                  itemBuilder: (context, index) {
                    if (_searchCubit.state is AeMainProductsLoaded) {
                      if ((_searchCubit.hasMore == true) &&
                          index + 1 == _searchCubit.displayedProducts.length) {
                        _searchCubit.getMainMoreAeProducts();
                      }
                    }
                    if (_searchCubit.state is AeQueryProductsLoaded) {
                      if ((_searchCubit.query1HasMore == true) &&
                          index + 1 == _searchCubit.displayedProducts.length) {
                        _searchCubit.getQueryMoreAeProducts();
                      }
                    }

                    return AeProductCard(product: _searchCubit.displayedProducts[index]);
                  },
                  itemCount: _searchCubit.displayedProducts.length,
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
        if (state is AeBusinessLoading) const LoadingGrid(),
      ],
    );
  }

  bool _buildWhen(previous, current) =>
      current is AeMainProductsLoaded ||
      current is AeQueryProductsLoaded ||
      current is AeBusinessLoading;

  void _listener(context, state) {
    if (_searchCubit.showGlobalRail) {
      _searchCubit.globalTabController?.reverse();
    } else {
      _searchCubit.globalTabController?.forward();
    }
  }
}
