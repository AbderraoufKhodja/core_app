import 'dart:async';
import 'dart:io';

import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_hot_product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retry/retry.dart';

import 'global_business/bloc.dart';

class HotProductsListView extends StatefulWidget {
  const HotProductsListView({
    super.key,
  });

  @override
  State<HotProductsListView> createState() => _HotProductsListViewState();
}

class _HotProductsListViewState extends State<HotProductsListView> {
  var futureHotProducts = retry<HotProductsResponse>(
    // Make a GET request
    () => AeBusinessCubit.instance.getHotProducts().timeout(const Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException || e is HandshakeException,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHotProducts,
      builder: (BuildContext context, AsyncSnapshot<HotProductsResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingGrid();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final response = snapshot.data?.aliexpressAffiliateHotproductQueryResponse;

          if (response?.respResult?.respCode == 200) {
            if (response?.respResult?.result?.products?.product?.isNotEmpty == true) {
              final products = response!.respResult!.result!.products!.product!;

              return ListView(
                scrollDirection: Axis.horizontal,
                children: products.asMap().entries.map<Widget>((entry) {
                  final idx = entry.key;
                  final product = entry.value;
                  final card = SizedBox(
                    width: Get.width / 2.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: AeHotProductCard(product: product),
                    ),
                  );
                  if (idx == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: card,
                    );
                  } else {
                    return card;
                  }
                }).toList(),
              );
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
                      futureHotProducts = AeBusinessCubit.instance.getHotProducts();
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
}
