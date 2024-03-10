import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/my_stores/horizontal_seller_store_item_card.dart';
import 'package:fibali/ui/widgets/horizontal_store_item_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class SellerStoreItemsListWidget extends StatelessWidget {
  const SellerStoreItemsListWidget({super.key, required this.store});
  final Store store;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<Item>(
      padding: const EdgeInsets.all(8),
      query: Item.ref.where(ItemLabels.storeID.name, isEqualTo: store.storeID),
      loadingBuilder: (context) => HorizontalStoreItemCard.shimmer(),
      itemBuilder: (context, snapshot) {
        if (snapshot.data().isValid() == true) {
          final item = snapshot.data();
          return GestureDetector(
            onTap: () => showItemPage(
              itemID: item.itemID!,
              storeID: item.storeID!,
              photo: item.photoUrls!.first,
            ),
            child: HorizontalSellerStoreItemCard(item: item),
          );
        }

        return const SizedBox();
      },
    );
  }
}
