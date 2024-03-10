import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ClientOrdersBadge extends StatefulWidget {
  final bool isActive;

  const ClientOrdersBadge({Key? key, required this.isActive}) : super(key: key);
  @override
  State<ClientOrdersBadge> createState() => _ClientOrdersBadgeState();
}

class _ClientOrdersBadgeState extends State<ClientOrdersBadge> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<ShoppingOrder>(
      query: ShoppingOrder.ref
          .where('clientID', isEqualTo: _currentUser!.uid)
          .where('isSeen.${_currentUser!.uid}', isEqualTo: false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Iconify(
            Mdi.cards_outline,
            color: widget.isActive ? Colors.white : Colors.white,
            size: 28,
          );
        }

        if (snapshot.hasError) {
          return Iconify(
            Mdi.cards_outline,
            color: widget.isActive ? Colors.white : Colors.white,
            size: 28,
          );
        }

        if (snapshot.docs.isEmpty) {
          return Iconify(
            Mdi.cards_outline,
            color: widget.isActive ? Colors.white : Colors.white,
            size: 28,
          );
        }

        final orders = snapshot.docs.map((doc) => doc.data());

        return bd.Badge(
          showBadge: orders.any(
            (order) => order.isSeen?[_currentUser?.uid] == false,
          ),
          badgeContent: FittedBox(
            child: Text(
              orders
                  .where((chat) => chat.isSeen?[_currentUser?.uid] == false)
                  .length
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          badgeStyle: const bd.BadgeStyle(
            shape: bd.BadgeShape.instagram,
            padding: EdgeInsets.all(3),
          ),
          child: Iconify(
            Mdi.cards_outline,
            color: widget.isActive ? Colors.white : Colors.white,
            size: 28,
          ),
        );
      },
    );
  }
}
