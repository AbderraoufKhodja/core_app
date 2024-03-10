import 'dart:async';
import 'dart:io';

import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/featured_promo_products_page.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

import 'ae_promo_product_card.dart';
import 'global_business/bloc.dart';

class FeaturedPromosListView extends StatefulWidget {
  const FeaturedPromosListView({
    super.key,
  });

  @override
  State<FeaturedPromosListView> createState() => _FeaturedPromosListViewState();
}

class _FeaturedPromosListViewState extends State<FeaturedPromosListView> {
  Future<FeaturedPromoResponse>? futureHotProducts;

  Future<FeaturedPromoResponse> get getRetryFutureProducts => retry<FeaturedPromoResponse>(
        // Make a GET request
        () => AeBusinessCubit.instance.getFeaturedPromos().timeout(const Duration(seconds: 5)),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

  @override
  void initState() {
    super.initState();
    futureHotProducts ??= getRetryFutureProducts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHotProducts,
      builder: (BuildContext context, AsyncSnapshot<FeaturedPromoResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingGrid();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final respCode =
              snapshot.data!.aliexpressAffiliateFeaturedpromoGetResponse?.respResult?.respCode;
          if (respCode == 200) {
            final promosIsNotEmpty = snapshot.data!.aliexpressAffiliateFeaturedpromoGetResponse!
                .respResult!.result?.promos?.promo?.isNotEmpty;
            if (promosIsNotEmpty == true) {
              final promos = snapshot.data!.aliexpressAffiliateFeaturedpromoGetResponse!.respResult!
                  .result!.promos!.promo!;

              return _buildListView(promos);
            } else {
              return const Text('No products');
            }
          } else {
            return Center(
                child: Column(
              children: [
                // refresh button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureHotProducts = getRetryFutureProducts;
                    });
                  },
                  child: const Text('Refresh'),
                ),
                Text(RCCubit.getT(R.oopsSomethingWentWrong)),
              ],
            ));
          }
        }
      },
    );
  }

  ListView _buildListView(List<Promo> promos) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: promos.map<Widget>((promo) {
        if (promo.promoName == null) return const SizedBox.shrink();

        return FutureBuilder<FeaturedPromoProductsResponse>(
            future: AeBusinessCubit.instance.getFeaturedPromoProducts(
                FeaturedPromoProductsRequestParams(promotionName: promo.promoName!, pageSize: '1')),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingGrid();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final products = snapshot.data?.aliexpressAffiliateFeaturedpromoProductsGetResponse
                  ?.respResult?.result?.products?.product;

              if (products?.isNotEmpty == true) {
                return MaterialButton(
                  onPressed: () {
                    FeaturedPromoProductsPage.show(
                      promoName: promo.promoName!,
                      product: products[0],
                    );
                  },
                  padding: const EdgeInsets.all(0),
                  child: AePromoProductCard(
                    promoName: promo.promoName!,
                    product: products![0],
                  ),
                );
              }

              return const SizedBox.shrink();
            });
      }).toList(),
    );
  }
}
