import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/seller_orders/seller_orders_cubit.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/shopping_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/shimmer_order_card.dart';

class ReceivedSellerOrdersTab extends StatefulWidget {
  const ReceivedSellerOrdersTab({super.key});

  @override
  State<ReceivedSellerOrdersTab> createState() => _ReceivedSellerOrdersTabState();
}

class _ReceivedSellerOrdersTabState extends State<ReceivedSellerOrdersTab> {
  final _sellerOrdersCubit = SellerOrdersCubit();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<ShoppingOrder>(
      query: _sellerOrdersCubit.ordersRef
          .where('storeOwnerID', isEqualTo: _currentUser!.uid)
          .where('lastOrderEvent.type', whereIn: [
        'orderReceived',
        'addReview',
      ]),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const ShimmerOrderCard();
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.shoppingBag,
                  color: Colors.grey.shade300,
                  size: _size.height / 10,
                ),
                Text(RCCubit.instance.getText(R.noOrders), textAlign: TextAlign.center),
              ],
            ),
          );
        }

        final _orders =
            snapshot.docs.map((order) => order.data()).where((order) => order.isValid()).toList();

        return ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (BuildContext _, int index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            return ShoppingCard(order: _orders[index]);
          },
        );
      },
    );
  }
}
