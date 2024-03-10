import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/ui/pages/client_order_events_page.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ClientOrderCard extends StatefulWidget {
  final ShoppingOrder order;
  final Color? color;

  const ClientOrderCard({
    Key? key,
    required this.order,
    this.color,
  }) : super(key: key);

  @override
  State<ClientOrderCard> createState() => _ClientOrderCardState();
}

class _ClientOrderCardState extends State<ClientOrderCard> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return bd.Badge(
      showBadge: widget.order.isSeen?[_currentUser!.uid] == false,
      position: bd.BadgePosition.topEnd(end: 10, top: 10),
      child: Container(
        color: widget.color ??
            (widget.order.isSeen?[_currentUser!.uid] == false
                ? Colors.grey.shade200
                : Colors.white),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              onTap: () => ClientOrderEventsPage.show(
                orderID: widget.order.orderID!,
              ),
              leading: GestureDetector(
                onTap: () => showItemPage(
                  itemID: widget.order.itemID!,
                  photo: widget.order.itemPhoto!,
                  storeID: widget.order.storeID!,
                ),
                child: PhotoWidgetNetwork(
                  label: null,
                  photoUrl: widget.order.itemPhoto.toString(),
                  height: 50,
                  width: 50,
                ),
              ),
              title: Text(
                widget.order.itemTitle.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(widget.order.attributes.toString()),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.order.finalPrice} ${widget.order.currency ?? ''}'),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      child: Text(RCCubit.instance.getCloudText(
                          context, widget.order.lastOrderEvent?['type'].toString() ?? '')),
                    ),
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
              title: Text(widget.order.orderID!),
              subtitle: formatDate(),
              trailing: IconButton(
                onPressed: () => _showMessaging(),
                icon: const Icon(FontAwesomeIcons.solidComments),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text formatDate() {
    return Text(widget.order.timestamp is Timestamp
        ? DateFormat.yMd().add_jm().format((widget.order.timestamp as Timestamp).toDate())
        : '');
  }

  Future<void> _showMessaging() async {
    final typeChatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
      firstID: widget.order.clientID!,
      secondID: widget.order.storeID!,
    )}';

    final otherUserID = _currentUser!.uid == widget.order.clientID
        ? widget.order.storeOwnerID!
        : widget.order.clientID!;

    return showMessagingPage(
      chatID: typeChatID,
      type: ChatTypes.shopping,
      otherUserID: otherUserID,
    );
  }
}
