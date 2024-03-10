import 'package:ae_api/ae_api.dart';
import 'package:ae_api/ds_api.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ali_Item_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/product_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AeHotProductCard extends StatefulWidget {
  const AeHotProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<AeHotProductCard> createState() => AeHotProductCardState();
}

class AeHotProductCardState extends State<AeHotProductCard>
    with AutomaticKeepAliveClientMixin<AeHotProductCard> {
  @override
  bool get wantKeepAlive => true;

  get width => 140.0;
  get hight => 140.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => AeProductPage.show(product: widget.product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade100, // Specify the color of the border here
                width: 1, // Specify the width of the border here
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0.0,
              margin: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  PhotoWidgetNetwork(
                    label: null,
                    photoUrl: widget.product.productMainImageUrl,
                    photoUrl100x100: widget.product.productSmallImageUrls?.string?[0],
                    loadingWidth: width,
                    loadingHeight: hight,
                  ),
                  if (widget.product.targetSalePrice != null &&
                      widget.product.targetOriginalPrice != null)
                    if (num.tryParse(widget.product.targetSalePrice!) != null &&
                        num.tryParse(widget.product.targetOriginalPrice!) != null)
                      // Calculate percentage
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          '-${((num.parse(widget.product.targetOriginalPrice!) - num.parse(widget.product.targetSalePrice!)) / num.parse(widget.product.targetOriginalPrice!) * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.targetOriginalPrice != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.product.targetOriginalPriceCurrency?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            Utils.formatCurrency(widget.product.targetOriginalPriceCurrency!),
                            maxLines: 1,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
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
                                style: labelSmall?.copyWith(color: Colors.redAccent),
                              ),
                            ),
                            if (priceBeforeDot?.isNotEmpty == true)
                              Text(
                                priceBeforeDot!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.redAccent),
                              ),
                            if (priceAfterDot?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Text(
                                  '.$priceAfterDot',
                                  style: labelSmall?.copyWith(color: Colors.redAccent),
                                ),
                              ),
                          ],
                        ),

                      const Gap(4),
                      // Sale price
                      if (widget.product.targetSalePrice != null)
                        Expanded(
                          child: Text(
                            '\$${widget.product.targetSalePrice!} ',
                            maxLines: 1,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                    ],
                  ),
                Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    if (num.tryParse(widget.product.evaluateRate?.replaceFirst('%', '') ?? '1f') !=
                        null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${num.tryParse(widget.product.evaluateRate!.replaceFirst('%', ''))! * 5 / 100}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 12,
                          ),
                        ],
                      ),
                    ProductSalesNoWidget(
                      productId: widget.product.productId.toString(),
                      builder: (ProductInfo? productInfo) {
                        final salesCount = productInfo?.aeItemBaseInfoDto?.salesCount;
                        if (salesCount == null) {
                          return const SizedBox();
                        }

                        return Text(
                          '$salesCount sold ',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                        );
                      },
                    ),
                  ],
                ),
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
