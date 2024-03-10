import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/Theme.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/seller_order_events_page.dart';
import 'package:flutter/material.dart';

//TODO: add badge and color change on new order

class ShoppingCard extends StatefulWidget {
  const ShoppingCard({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  final ShoppingOrder order;
  final Function? onTap;

  @override
  State<ShoppingCard> createState() => _ShoppingCardState();
}

class _ShoppingCardState extends State<ShoppingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SellerOrderEventsPage.show(
        orderID: widget.order.orderID!,
      ),
      child: Card(
        child: SizedBox(
          height: 136,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: GestureDetector(
                          onTap: () => showItemPage(
                                itemID: widget.order.itemID!,
                                photo: widget.order.itemPhoto!,
                                storeID: widget.order.storeID!,
                              ),
                          child: PhotoWidget.network(
                            photoUrl: widget.order.itemPhoto,
                          )),
                    ),
                  ),
                ]),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.itemDescription ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Text(
                                  RCCubit.instance.getText(getFormattedOrderEvent()),
                                  style: const TextStyle(
                                    color: ArgonColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "\$${widget.order.finalPrice}",
                                  style: const TextStyle(
                                      color: ArgonColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: ArgonColors.initial,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              onPressed: () {},
                              child: const Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0, top: 12, bottom: 12),
                                  child: Text(
                                    "CONTACT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11.0,
                                    ),
                                  )),
                            )
                          ],
                        )
                      ]),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  R getFormattedOrderEvent() {
    switch (widget.order.lastOrderEvent?['type']) {
      case 'newOrder':
        return R.newOrder;
      case 'remindSeller':
        return R.remindSeller;
      case 'orderReceived':
        return R.orderReceived;
      case 'refundApplication':
        return R.refundApplication;
      case 'itemPackaged':
        return R.itemPackaged;
      case 'packageSent':
        return R.packageSent;
      case 'confirmOrder':
        return R.confirmOrder;
      case 'addReview':
        return R.addReview;

        break;
      default:
        return R.unknown;
    }
  }
}
