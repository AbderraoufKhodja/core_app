import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/ui/widgets/shimmer_order_card.dart';
import 'package:fibali/ui/widgets/card_shopping.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AllClientOrdersTab extends StatefulWidget {
  const AllClientOrdersTab({super.key});

  @override
  State<AllClientOrdersTab> createState() => _AllClientOrdersTabState();
}

class _AllClientOrdersTabState extends State<AllClientOrdersTab> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<ShoppingOrder>(
      query: ShoppingOrder.ref.where('clientID', isEqualTo: _currentUser!.uid),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: const [
                ShimmerOrderCard(),
                SizedBox(height: 8.0),
                ShimmerOrderCard(),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.bagShopping,
                  color: Colors.grey.shade300,
                  size: Get.height / 10,
                ),
                Text(RCCubit.instance.getText(R.noOrders), textAlign: TextAlign.center),
              ],
            ),
          );
        }

        final orders =
            snapshot.docs.map((order) => order.data()).where((order) => order.isValid()).toList();

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: orders.length,
          itemBuilder: (BuildContext _, int index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            return CardShopping(order: orders[index]);
          },
        );
      },
    );
  }
}
