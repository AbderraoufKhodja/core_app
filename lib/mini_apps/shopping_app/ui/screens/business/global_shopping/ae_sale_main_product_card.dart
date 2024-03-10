import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ali_Item_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AeSaleMainProductCard extends StatefulWidget {
  const AeSaleMainProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<AeSaleMainProductCard> createState() => AeSaleMainProductCardState();
}

class AeSaleMainProductCardState extends State<AeSaleMainProductCard>
    with AutomaticKeepAliveClientMixin<AeSaleMainProductCard> {
  @override
  bool get wantKeepAlive => true;

  get width => 140.0;
  get hight => 140.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => AeProductPage.show(product: widget.product),
      child: ColoredBox(
        color: Colors.black,
        child: SizedBox(
          width: width,
          height: hight + 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.redAccent,
                elevation: 0.0,
                margin: const EdgeInsets.only(
                  left: 4.0,
                  right: 4.0,
                  top: 4.0,
                  bottom: 10.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0.0,
                  child: Stack(
                    children: [
                      PhotoWidgetNetwork(
                        label: null,
                        photoUrl: widget.product.productMainImageUrl,
                        photoUrl100x100: widget.product.productSmallImageUrls?.string?[0],
                        width: width,
                        height: hight,
                        loadingWidth: width,
                        loadingHeight: hight,
                      ),
                      if (widget.product.salePrice != null && widget.product.originalPrice != null)
                        if (num.tryParse(widget.product.salePrice!) != null &&
                            num.tryParse(widget.product.originalPrice!) != null)
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
                              '-${((num.parse(widget.product.originalPrice!) - num.parse(widget.product.salePrice!)) / num.parse(widget.product.originalPrice!) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.product.originalPrice != null)
                      Row(
                        children: [
                          if (widget.product.originalPriceCurrency != null)
                            if (widget.product.originalPriceCurrency!.length > 2)
                              Text(
                                widget.product.originalPriceCurrency.toString().substring(0, 2),
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: Colors.redAccent),
                              ),
                          const Gap(2),
                          // dollar sign

                          Text(
                            '\$${widget.product.originalPrice!}',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.redAccent),
                          ),
                          const Gap(4),
                          // Sale price
                          if (widget.product.salePrice != null)
                            Expanded(
                              child: Text(
                                '\$${widget.product.salePrice!}} ',
                                maxLines: 1,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    if (num.tryParse(widget.product.evaluateRate?.replaceFirst('%', '') ?? '1f') !=
                        null)
                      Row(
                        children: [
                          Text(
                            '${num.tryParse(widget.product.evaluateRate!.replaceFirst('%', ''))! * 5 / 100}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
