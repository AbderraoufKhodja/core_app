import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/my_seller_store_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: PhotoWidget.network(
                photoUrl: store.logo,
                width: Get.width / 8,
                height: Get.width / 8,
              ),
              title: Text(store.name!, maxLines: 1),
              subtitle: Text(store.description!, maxLines: 1),
              // trailing: PopupMenuButton<String>(
              //   child: Icon(Icons.more_vert),
              //   itemBuilder: (BuildContext context) {
              //     return [
              //       PopupMenuItem<String>(
              //         value: kAddItem,
              //         child: Text(rc.getDisplayText(context,'AddItem)),
              //         onTap: () => Future.delayed(const Duration(milliseconds: 50)).then(
              //           (value) => showItemFactoryPage(
              //             context,
              //             store: store,
              //             itemID: null,
              //           ),
              //         ),
              //       ),
              //       PopupMenuItem<String>(
              //         value: kUpdateStoreInfo,
              //         child: Text(rc.getDisplayText(context,'UpdateStoreInfo)),
              //       )
              //     ];
              //   },
              // ),
              onTap: () => MySellerStorePage.show(store: store),
            ),
            Card(
              elevation: 0,
              color: Get.theme.highlightColor,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Table(
                border: TableBorder.symmetric(
                  inside: const BorderSide(color: Colors.grey, width: 0.2),
                ),
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          const Text('Likes'),
                          Text(store.numLikes.toString()),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Orders'),
                          Text(store.numOrders.toString()),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Receptions'),
                          Text(store.numReceptions.toString()),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Confirmations'),
                          Text(store.numConfirmations.toString()),
                        ],
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text('Reviews'),
                        Text(store.numReviews.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Refunds'),
                        Text(store.numRefunds.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('AvgRating'),
                        Text(store.avgRating?.toStringAsFixed(1) ?? ''),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('PackagesSent'),
                        Text(store.numPackagesSent.toString()),
                      ],
                    ),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
