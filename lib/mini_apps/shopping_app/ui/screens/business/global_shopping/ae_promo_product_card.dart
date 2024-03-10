import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AePromoProductCard extends StatefulWidget {
  const AePromoProductCard({
    super.key,
    required this.product,
    required this.promoName,
  });

  final Product product;
  final String promoName;

  @override
  State<AePromoProductCard> createState() => AePromoProductCardState();
}

class AePromoProductCardState extends State<AePromoProductCard>
    with AutomaticKeepAliveClientMixin<AePromoProductCard> {
  @override
  bool get wantKeepAlive => true;

  get width => Get.width / 8;
  get hight => Get.width / 8;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      width: Get.width / 3,
      child: Card(
        elevation: 0.0,
        color: Colors.red.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 14.0,
                  ),
                  const Gap(2),
                  Expanded(
                    child: Text(
                      widget.promoName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        margin: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0.0,
                        child: PhotoWidgetNetwork(
                          label: null,
                          photoUrl: widget.product.productMainImageUrl,
                          photoUrl100x100: widget.product.productSmallImageUrls?.string?[0],
                          width: width,
                          height: hight,
                          loadingWidth: width,
                          loadingHeight: hight,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.product.originalPrice != null)
                                    if (widget.product.originalPriceCurrency != null)
                                      if (widget.product.originalPriceCurrency!.length > 2)
                                        Text(
                                          widget.product.originalPriceCurrency
                                              .toString()
                                              .substring(0, 2),
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 8,
                                                color: Colors.redAccent,
                                              ),
                                        ),
                                  const Gap(2),
                                  if (widget.product.originalPrice != null)
                                    Text(
                                      '\$${widget.product.originalPrice!}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: Colors.redAccent,
                                        fontSize: 8,
                                      ),
                                    ),
                                ],
                              ),
                              if (widget.product.salePrice != null &&
                                  widget.product.originalPrice != null)
                                if (num.tryParse(widget.product.salePrice!) != null &&
                                    num.tryParse(widget.product.originalPrice!) != null)
                                  // Calculate percentage
                                  Card(
                                    elevation: 0.0,
                                    color: Colors.red.shade50,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),
                                      child: Text(
                                        '${((num.parse(widget.product.originalPrice!) - num.parse(widget.product.salePrice!)) / num.parse(widget.product.originalPrice!) * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
