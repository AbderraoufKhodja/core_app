import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/client_orders/client_orders_cubit.dart';
import 'package:fibali/bloc/ordering/bloc.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/pages/review_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ClientOrderEventsPage extends StatefulWidget {
  final String orderID;

  const ClientOrderEventsPage({Key? key, required this.orderID}) : super(key: key);

  @override
  ClientOrderEventsPageState createState() => ClientOrderEventsPageState();

  static Future<dynamic>? show({
    required String orderID,
  }) {
    return Get.to(
      () => BlocProvider(
        create: (context) => ClientOrdersCubit(),
        child: ClientOrderEventsPage(orderID: orderID),
      ),
    );
  }
}

class ClientOrderEventsPageState extends State<ClientOrderEventsPage> {
  final orderEventsBloc = OrderEventsBloc();

  ClientOrdersCubit get _clientOrdersBloc => BlocProvider.of<ClientOrdersCubit>(context);
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    orderEventsBloc.add(LoadOrderEvents(orderID: widget.orderID));

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentOrderID", widget.orderID));

    orderEventsBloc.markAsSeen(
      currentUserID: _currentUser!.uid,
      orderID: widget.orderID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        orderEventsBloc.markAsSeen(
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
                    orderEventsBloc.markAsSeen(
                      currentUserID: _currentUser!.uid,
                      orderID: widget.orderID,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                padding: const EdgeInsets.all(8.0),
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

  Widget _buildBody({required ShoppingOrder order}) {
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
                    child: PhotoWidgetNetwork(
                      label: null,
                      photoUrl: order.itemPhoto.toString(),
                    ),
                  ),
                ),
                title: Text(order.itemTitle.toString()),
                subtitle: Text(order.attributes.toString()),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${order.finalPrice} ${order.currency ?? ''}'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      child: Text(RCCubit.instance
                          .getCloudText(context, order.lastOrderEvent?['type'].toString() ?? '')),
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
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                minVerticalPadding: 0,
                style: ListTileStyle.drawer,
                dense: true,
                leading: Text(RCCubit.instance.getText(R.info)),
                title: Text(order.storeName!),
                subtitle: Text(order.storePhoneNumber!),
                trailing: IconButton(
                  onPressed: () {
                    launch('tel://${order.storePhoneNumber!}');
                  },
                  icon: const FaIcon(FontAwesomeIcons.phone),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<OrderEventsBloc, OrderEventsState>(
          bloc: orderEventsBloc,
          builder: (context, state) {
            if (state is OrderEventsInitial) {
              orderEventsBloc.add(LoadOrderEvents(orderID: order.orderID!));
            }
            if (state is OrderEventsLoaded) {
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
                                            height: Get.height / 8,
                                            child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                // shrinkWrap: true,
                                                itemBuilder: (context, index) => PhotoWidgetNetwork(
                                                      label: null,
                                                      photoUrl: orderEvent.photoUrls![index],
                                                      canDisplay: true,
                                                      height: Get.height / 8,
                                                      width: Get.height / 8,
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
    switch (Utils.enumFromString(OrEvTypes.values, order.lastOrderEvent?['type'])) {
      case OrEvTypes.orderReceived:
        return Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _clientOrdersBloc.handleRefund(
                  context,
                  order: order,
                ),
                child: Text(RCCubit.instance.getText(R.refund)),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => showReviewPage(
                  context,
                  onSubmitted: (rating, comment, photoFiles) {
                    _clientOrdersBloc.handleAddReview(
                      context,
                      order: order,
                      reviewText: comment?.isNotEmpty == true ? comment : null,
                      rating: rating,
                      photoFiles: photoFiles,
                    );
                  },
                ),
                child: Text(RCCubit.instance.getText(R.review)),
              ),
            ),
          ],
        );
      case OrEvTypes.refundApplication:
        return ElevatedButton(
          onPressed: () {},
          child: Text(RCCubit.instance.getText(R.contactClientService)),
        );
      case OrEvTypes.addReview:
        return TextButton(
          onPressed: () => _clientOrdersBloc.handleRefund(
            context,
            order: order,
          ),
          child: Text(RCCubit.instance.getText(R.refund)),
        );
      case OrEvTypes.acceptRefund:
        return ElevatedButton(
          onPressed: () {},
          child: Text(RCCubit.instance.getText(R.contactClientService)),
        );
      case OrEvTypes.declineRefund:
        return ElevatedButton(
          onPressed: () {},
          child: Text(RCCubit.instance.getText(R.contactClientService)),
        );
      case OrEvTypes.packageSent:
        return ElevatedButton(
          onPressed: () => _clientOrdersBloc.handleReceiveOrder(
            context,
            order: order,
          ),
          child: Text(RCCubit.instance.getText(R.recieved)),
        );

      case OrEvTypes.newOrder:
        return ReceiveRemindWidget(order: order);
      case OrEvTypes.remindSeller:
        return ReceiveRemindWidget(order: order);
      case OrEvTypes.itemPackaged:
        // TODO: Handle this case.
        return const SizedBox();
      case OrEvTypes.confirmOrder:
        // TODO: Handle this case.
        return const SizedBox();
      case null:
        // TODO: Handle this case.
        return const SizedBox();
    }
  }

  Future<dynamic>? _showMessaging({required ShoppingOrder order}) {
    final chatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
      firstID: _currentUser!.uid,
      secondID: order.storeOwnerID!,
    )}';
    return showMessagingPage(
      chatID: chatID,
      type: ChatTypes.shopping,
      otherUserID: order.storeOwnerID!,
    );
  }
}

class ReceiveRemindWidget extends StatelessWidget {
  const ReceiveRemindWidget({super.key, required this.order});

  final ShoppingOrder order;

  @override
  Widget build(BuildContext context) {
    ClientOrdersCubit clientOrdersBloc = BlocProvider.of<ClientOrdersCubit>(context);

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => clientOrdersBloc.handleReminder(
              context,
              order: order,
            ),
            child: Text(RCCubit.instance.getText(R.reminder)),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () => clientOrdersBloc.handleReceiveOrder(
              context,
              order: order,
            ),
            child: Text(RCCubit.instance.getText(R.recieved)),
          ),
        ),
      ],
    );
  }
}
