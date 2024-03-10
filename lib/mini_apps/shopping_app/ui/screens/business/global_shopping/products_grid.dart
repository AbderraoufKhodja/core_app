import 'dart:async';
import 'dart:io';

import 'package:ae_api/ae_api.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_product_card.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:retry/retry.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    super.key,
    required this.promotionName,
    required this.categoryName,
  });

  final String promotionName;
  final String categoryName;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  static const _pageSize = 20;
  final _pagingController = PagingController<int, Product>(
    firstPageKey: 0,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await retry<FeaturedPromoProductsResponse>(
        // Make a GET request
        () => AeBusinessCubit.instance.getFeaturedPromoProducts(
          FeaturedPromoProductsRequestParams(
            promotionName: widget.promotionName,
            pageNo: (pageKey + 1).toString(),
            categoryId: widget.categoryName,
          ),
        )..timeout(const Duration(seconds: 5)),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      final products = response.aliexpressAffiliateFeaturedpromoProductsGetResponse?.respResult
          ?.result?.products?.product;

      final isLastPage = (products?.length ?? 0) < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(products ?? []);
      } else {
        _pagingController.appendPage(products ?? [], pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, Product>(
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.5,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) => AeProductCard(product: item),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
