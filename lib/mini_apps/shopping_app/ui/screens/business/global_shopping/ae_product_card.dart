import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ali_Item_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/product_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AeProductCard extends StatefulWidget {
  const AeProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<AeProductCard> createState() => AeProductCardState();
}

class AeProductCardState extends State<AeProductCard>
    with AutomaticKeepAliveClientMixin<AeProductCard> {
  @override
  bool get wantKeepAlive => true;

  get width => Get.width / 2.5;
  get hight => Get.width / 2.5;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => AeProductPage.show(product: widget.product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(0),
              elevation: 0,
              child: PhotoWidgetNetwork(
                label: null,
                photoUrl: widget.product.productMainImageUrl,
                loadingWidth: width,
                loadingHeight: width,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.productTitle != null)
                  Text(widget.product.productTitle!, style: labelSmall, maxLines: 2),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      if (widget.product.targetOriginalPriceCurrency?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            widget.product.targetOriginalPriceCurrency!.substring(0, 2),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      if (widget.product.targetOriginalPrice?.isNotEmpty == true)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                '\$',
                                maxLines: 1,
                                style: labelSmall,
                              ),
                            ),
                            if (priceBeforeDot?.isNotEmpty == true) Text(priceBeforeDot!),
                            if (priceAfterDot?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Text(
                                  '.$priceAfterDot',
                                  style: labelSmall,
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: ProductSalesNoWidget(
                          productId: widget.product.productId.toString(),
                          builder: (productInfo) {
                            final salesCount = productInfo?.aeItemBaseInfoDto?.salesCount;
                            if (salesCount == null) {
                              return const SizedBox();
                            }

                            return Text(
                              '$salesCount sold ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 12,
                          ),
                          if (num.tryParse(
                                  widget.product.evaluateRate?.replaceFirst('%', '') ?? '1f') !=
                              null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                (num.tryParse(widget.product.evaluateRate!.replaceFirst('%', ''))! *
                                        5 /
                                        100)
                                    .toStringAsFixed(1),
                                style: labelSmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // evaluation
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle? get labelSmall => Theme.of(context).textTheme.labelSmall;

  String? get priceBeforeDot => widget.product.targetOriginalPrice?.split('.')[0];

  String? get priceAfterDot => widget.product.targetOriginalPrice?.split('.')[1];
}
