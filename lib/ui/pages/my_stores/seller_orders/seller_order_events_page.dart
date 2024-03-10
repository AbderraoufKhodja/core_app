import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/seller_order_events/seller_order_events_bloc.dart';
import 'package:fibali/bloc/seller_order_events/seller_order_events_event.dart';
import 'package:fibali/bloc/seller_order_events/seller_order_events_state.dart';
import 'package:fibali/bloc/seller_orders/seller_orders_cubit.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/widgets/package_sending_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class SellerOrderEventsPage extends StatefulWidget {
  final String orderID;

  const SellerOrderEventsPage({super.key, required this.orderID});

  static Future<dynamic>? show({
    required String orderID,
  }) {
    return Get.to(() => BlocProvider(
          create: (context) => SellerOrdersCubit(),
          child: SellerOrderEventsPage(orderID: orderID),
        ));
  }

  @override
  SellerOrderEventsPageState createState() => SellerOrderEventsPageState();
}

class SellerOrderEventsPageState extends State<SellerOrderEventsPage> {
  final _orderEventsBloc = SellerOrderEventsBloc();

  SellerOrdersCubit get _sellerOrdersBloc => BlocProvider.of<SellerOrdersCubit>(context);
  Size get _size => MediaQuery.of(context).size;
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    _orderEventsBloc.add(LoadSellerOrderEvents(orderID: widget.orderID));

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentOrderID", widget.orderID));

    _orderEventsBloc.markAsSeen(
      currentUserID: _currentUser!.uid,
      orderID: widget.orderID,
    );
  }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((prefs) => prefs.remove("currentOrderID"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _orderEventsBloc.markAsSeen(
          currentUserID: _currentUser!.uid,
          orderID: widget.orderID,
        );
        return Future.value(true);
      },
      child: StreamBuilder<DocumentSnapshot<ShoppingOrder>>(
        stream: ShoppingOrder.ref.doc(widget.orderID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final order = snapshot.data!.data();

          if (snapshot.hasData && order != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(RCCubit.instance.getText(R.orderDetails)),
                leading: PopButton(
                  onPressed: () {
                    _orderEventsBloc.markAsSeen(
                      currentUserID: _currentUser!.uid,
                      orderID: widget.orderID,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: ListTile(
                  title: _buildOrderActionsButton(order: order),
                  trailing: IconButton(
                    onPressed: () => _showMessaging(order: order),
                    icon: const Icon(FontAwesomeIcons.solidComments),
                  ),
                ),
              ),
              body: _buildBody(order: order),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  ListView _buildBody({required ShoppingOrder order}) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: SizedBox(
                  height: 100,
                  width: 50,
                  child: GestureDetector(
                    onTap: () => showItemPage(
                      itemID: order.itemID!,
                      photo: order.itemPhoto!,
                      storeID: order.storeID!,
                    ),
                    child: PhotoWidget.network(
                      photoUrl: order.itemPhoto.toString(),
                    ),
                  ),
                ),
                title: Text(order.itemTitle.toString()),
                subtitle: Text(order.attributes.toString()),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.finalPrice.toString()),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      child: Text(' ${order.lastOrderEvent?['type'].toString() ?? ''} '),
                    ),
                  ],
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                minVerticalPadding: 0,
                style: ListTileStyle.drawer,
                dense: true,
                leading: Text(RCCubit.instance.getText(R.orderID)),
                title: Text(order.orderID!),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                minVerticalPadding: 0,
                style: ListTileStyle.drawer,
                dense: true,
                leading: Text(RCCubit.instance.getText(R.deliveryAddress)),
                title: Text(order.deliveryAddress!['province']),
                subtitle: Text(order.deliveryAddress!['subProvince'] +
                    ', ' +
                    order.deliveryAddress!['streetAddress']),
                trailing: IconButton(
                  onPressed: () => showGoogleMaps(),
                  icon: const FaIcon(FontAwesomeIcons.locationDot),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                minVerticalPadding: 0,
                style: ListTileStyle.drawer,
                dense: true,
                leading: Text(RCCubit.instance.getText(R.contactInfo)),
                title: Text(order.deliveryAddress!['name']),
                subtitle: Text(order.deliveryAddress!['phoneNumber']),
                trailing: IconButton(
                  onPressed: () => launch('tel://' + order.deliveryAddress!['phoneNumber']),
                  icon: const FaIcon(FontAwesomeIcons.phone),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<SellerOrderEventsBloc, OrderEventsState>(
          bloc: _orderEventsBloc,
          builder: (context, state) {
            if (state is SellerOrderEventsInitial) {
              _orderEventsBloc.add(LoadSellerOrderEvents(orderID: widget.orderID));
            }
            if (state is SellerOrderEventsLoaded) {
              return StreamBuilder<QuerySnapshot<OrderEvent>>(
                stream: state.orderEvents,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                      children: snapshot.data!.docs
                          .map((orderEvents) => orderEvents.data())
                          .where((orderEvent) => orderEvent.isValid())
                          .map(
                            (orderEvent) => Card(
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(' ${orderEvent.type!} ')),
                                      title: Text(orderEvent.senderName!),
                                      trailing: Text(orderEvent.timestamp != null
                                          ? timeago.format(orderEvent.timestamp!.toDate())
                                          : ''),
                                      subtitle: Text(orderEvent.text ?? ''),
                                    ),
                                    orderEvent.photoUrls?.isNotEmpty == true
                                        ? SizedBox(
                                            height: _size.height / 8,
                                            child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) =>
                                                    PhotoWidget.network(
                                                      photoUrl: orderEvent.photoUrls![index],
                                                      canDisplay: true,
                                                      height: _size.height / 8,
                                                      width: _size.height / 8,
                                                    ),
                                                separatorBuilder: (context, index) =>
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                itemCount: orderEvent.photoUrls!.length),
                                          )
                                        : const SizedBox(),
                                  ],
                                )),
                          )
                          .toList());
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildOrderActionsButton({required ShoppingOrder order}) {
    switch (order.lastOrderEvent?['type']) {
      case 'newOrder':
        return ElevatedButton(
          onPressed: () => showPackageSendingPage(
            context,
            onSubmitted: (rating, comment, photoFiles) {
              _sellerOrdersBloc.handleSendPackage(
                context,
                order: order,
                reviewText: comment?.isNotEmpty == true ? comment : null,
                photoFiles: photoFiles,
              );
            },
          ),
          child: Text(RCCubit.instance.getText(R.sendPackage)),
        );
      case 'refundApplication':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _sellerOrdersBloc.handleAcceptRefund(
                  context,
                  order: order,
                ),
                child: Text(RCCubit.instance.getText(R.acceptRefund)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _sellerOrdersBloc.handleDeclineRefund(
                  context,
                  order: order,
                ),
                child: Text(RCCubit.instance.getText(R.declineRefund)),
              ),
            ),
          ],
        );
      case 'addReview':
        return const SizedBox();

      default:
        return const SizedBox();
    }
  }

  Future<dynamic>? _showMessaging({required ShoppingOrder order}) {
    final typeChatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
      firstID: order.clientID!,
      secondID: order.storeID!,
    )}';
    return showMessagingPage(
      chatID: typeChatID,
      type: ChatTypes.shopping,
      otherUserID: _currentUser!.uid == order.clientID ? order.storeOwnerID! : order.clientID!,
    );
  }
}
