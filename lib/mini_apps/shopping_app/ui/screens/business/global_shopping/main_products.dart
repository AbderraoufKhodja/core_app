import 'package:ae_api/ae_api.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_sale_main_product_card.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:flutter/material.dart';

class MainProducts extends StatelessWidget {
  const MainProducts({
    super.key,
    required this.promotionName,
  });

  final String promotionName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FeaturedPromoProductsResponse>(
        future:
            AeBusinessCubit.instance.getFeaturedPromoProducts(FeaturedPromoProductsRequestParams(
          promotionName: promotionName,
          sort: 'LAST_VOLUME_DESC',
          pageSize: '3',
        )),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final products = snapshot.data?.aliexpressAffiliateFeaturedpromoProductsGetResponse
                ?.respResult?.result?.products?.product;

            if (products?.isNotEmpty == true) {
              return Row(
                children: products!
                    .map((product) => Expanded(
                          child: AeSaleMainProductCard(product: product),
                        ))
                    .toList(),
              );
            } else {
              return const Center(
                child: Text('No products found'),
              );
            }
          } else {
            return const Center(
              child: Text('No products found'),
            );
          }
        });
  }
}
