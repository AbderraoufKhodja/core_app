import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/Theme.dart';
import 'package:fibali/ui/pages/client_order_events_page.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:flutter/material.dart';

//TODO: add badge and color change on new order

class CardShopping extends StatefulWidget {
  const CardShopping({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  final ShoppingOrder order;
  final Function? onTap;

  @override
  State<CardShopping> createState() => _CardShoppingState();
}

class _CardShoppingState extends State<CardShopping> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ClientOrderEventsPage.show(
        orderID: widget.order.orderID!,
      ),
      child: Card(
        child: Container(
          height: 136,
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
                          child: PhotoWidgetNetwork(
                            label: null,
                            photoUrl: widget.order.itemPhoto ?? '',
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
                                  "${widget.order.currency ?? ''} ${widget.order.finalPrice}",
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
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 8, bottom: 8),
                                  child: Text(
                                    RCCubit.instance.getText(R.contact).toUpperCase(),
                                    style: const TextStyle(
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
    switch (Utils.enumFromString(OrEvTypes.values, widget.order.lastOrderEvent?['type'])) {
      case OrEvTypes.newOrder:
        return R.newOrder;
      case OrEvTypes.remindSeller:
        return R.remindSeller;
      case OrEvTypes.orderReceived:
        return R.orderReceived;
      case OrEvTypes.refundApplication:
        return R.refundApplication;
      case OrEvTypes.itemPackaged:
        return R.itemPackaged;
      case OrEvTypes.packageSent:
        return R.packageSent;
      case OrEvTypes.confirmOrder:
        return R.confirmOrder;
      case OrEvTypes.addReview:
        return R.addReview;
      case OrEvTypes.acceptRefund:
        return R.acceptRefund;
      case OrEvTypes.declineRefund:
        return R.declineRefund;

      case null:
        return R.unknown;
    }
  }
}
