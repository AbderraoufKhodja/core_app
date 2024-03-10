import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/client_orders/client_orders_cubit.dart';
import 'package:fibali/bloc/store_items/bloc.dart';
import 'package:fibali/ui/pages/client_order_events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:get/get.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class ChatOrdersCard extends StatefulWidget {
  final String clientID;
  final String storeID;
  final String chatID;
  final bool initiallyExpanded;
  final Color color;

  const ChatOrdersCard({
    Key? key,
    required this.clientID,
    required this.storeID,
    required this.chatID,
    this.initiallyExpanded = false,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  _ChatOrdersCardState createState() => _ChatOrdersCardState();
}

class _ChatOrdersCardState extends State<ChatOrdersCard> {
  final _ordersMultiSelectKey = GlobalKey<FormFieldState>();
  final _itemsMultiSelectKey = GlobalKey<FormFieldState>();
  final _storeItemsBloc = StoreItemsBloc();

  final List<ShoppingOrder> _clientOrder = [];
  final List<Item> _sellerItems = [];

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  String get _storeID => widget.storeID;
  String get _chatID => widget.chatID;
  String get _clientID => widget.clientID;

  late ClientOrdersCubit _clOrdersCubit;

  @override
  void initState() {
    super.initState();
    _clOrdersCubit = ClientOrdersCubit();
    _storeItemsBloc.add(LoadStoreItems(storeID: _storeID));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
      child: Card(
        elevation: 0,
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.center,
          initiallyExpanded: widget.initiallyExpanded,
          // backgroundColor: Colors.transparent,
          title: Text(RCCubit.instance.getText(R.orders)),
          maintainState: true,
          children: [
            // SizedBox(
            //   height: Get.width / 5,
            //   child: FirestoreListView<Item>(
            //     scrollDirection: Axis.horizontal,
            //     query: _storeItemsBloc.storeItemsRef.where('storeID', isEqualTo: widget.storeID),
            //     itemBuilder: (context, snapshot) {
            //       final _item = snapshot.data();

            //       return PhotoWidgetNetwork(
            //         photoUrl: _item.photoUrls?[0],
            //         height: Get.width / 5,
            //         width: Get.width / 5,
            //         boxShape: BoxShape.circle,
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: 6),
            SizedBox(
              height: Get.width / 5,
              child: FirestoreListView<ShoppingOrder>(
                scrollDirection: Axis.horizontal,
                query: ShoppingOrder.ref
                    .where('clientID', isEqualTo: widget.clientID)
                    .where('storeID', isEqualTo: widget.storeID)
                    .orderBy('lastOrderEvent.timestamp', descending: true),
                itemBuilder: (context, snapshot) {
                  final order = snapshot.data();

                  return GestureDetector(
                    onTap: () {
                      if (_currentUser?.uid == order.clientID) {
                        ClientOrderEventsPage.show(
                          orderID: order.orderID!,
                        );
                      }
                    },
                    child: PhotoWidgetNetwork(
                      label: null,
                      photoUrl: order.itemPhoto ?? '',
                      height: Get.width / 5,
                      width: Get.width / 5,
                      boxShape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  MultiSelectChipField<Item> buildMultiSelectItems({
    required List<Item> items,
    required List<Item> selectedItems,
    required Color selectedColor,
  }) {
    return MultiSelectChipField(
      height: Get.width / 5,
      showHeader: false,
      decoration: const BoxDecoration(),
      items: items.map((item) => MultiSelectItem<Item>(item, item.description!)).toList(),
      key: _itemsMultiSelectKey,
      itemBuilder: (MultiSelectItem<Item?> item, FormFieldState<List<Item?>> state) => InkResponse(
        onTap: () {
          selectedItems.contains(item.value)
              ? selectedItems.remove(item.value)
              : selectedItems.add(item.value!);
          state.didChange(selectedItems);
          _itemsMultiSelectKey.currentState!.validate();
          setState(() {});
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 100),
          child: PhotoWidgetNetwork(
            label: null,
            photoUrl: item.value!.photoUrls![0],
            height: Get.width / 5,
            width: Get.width / 5,
            boxShape: BoxShape.circle,
            border: selectedItems.contains(item.value)
                ? Border.all(color: selectedColor, width: 3)
                : Border.all(color: selectedColor, width: 1),
          ),
        ),
      ),
    );
  }

  MultiSelectChipField<ShoppingOrder> buildMultiSelectOrders({
    required List<ShoppingOrder> orders,
    required List<ShoppingOrder> selectedOrders,
    required Color selectedColor,
  }) {
    return MultiSelectChipField(
      height: Get.width / 5,
      showHeader: false,
      items: orders
          .map(
            (order) => MultiSelectItem<ShoppingOrder>(order, order.itemTitle!),
          )
          .toList(),
      key: _ordersMultiSelectKey,
      itemBuilder:
          (MultiSelectItem<ShoppingOrder?> order, FormFieldState<List<ShoppingOrder?>> state) =>
              InkResponse(
        onTap: () {
          selectedOrders.contains(order.value)
              ? selectedOrders.remove(order.value)
              : selectedOrders.add(order.value!);
          state.didChange(selectedOrders);
          _ordersMultiSelectKey.currentState!.validate();
          setState(() {});
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 100),
          child: PhotoWidgetNetwork(
            label: null,
            photoUrl: order.value!.itemPhoto ?? '',
            height: Get.width / 5,
            width: Get.width / 5,
            boxShape: BoxShape.circle,
            border: selectedOrders.contains(order.value)
                ? Border.all(color: selectedColor, width: 3)
                : Border.all(color: selectedColor, width: 1),
          ),
        ),
      ),
    );
  }
}
