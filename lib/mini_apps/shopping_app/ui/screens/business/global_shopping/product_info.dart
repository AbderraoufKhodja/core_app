import 'package:ae_api/ds_api.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/global_business_cubit.dart';
import 'package:flutter/material.dart';

class ProductSalesNoWidget extends StatefulWidget {
  const ProductSalesNoWidget({
    super.key,
    required this.productId,
    required this.builder,
  });

  final String productId;
  final Widget Function(ProductInfo? productInfo) builder;

  @override
  State<ProductSalesNoWidget> createState() => _ProductSalesNoWidgetState();
}

class _ProductSalesNoWidgetState extends State<ProductSalesNoWidget> {
  late final productDetails = AeBusinessCubit.instance.getProductInfo(ProductInfoQuery(
    productId: widget.productId,
  ));
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AeDSProductGetResponse>(
        future: productDetails,
        builder: (context, snapshot) {
          final productInfo = snapshot.data?.result;
          return widget.builder(productInfo);
        });
  }
}
