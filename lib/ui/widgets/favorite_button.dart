import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/item/item_bloc.dart';
import 'package:fibali/fibali_core/models/favorite.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  ItemBloc get _itemBloc => BlocProvider.of<ItemBloc>(context);

  @override
  Widget build(BuildContext context) {
    final favoriteRef = Favorite.ref.doc('favorite_${_currentUser!.uid}${widget.item.itemID!}');

    return StreamBuilder<DocumentSnapshot<Favorite>>(
      stream: favoriteRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return IconButton(
              onPressed: () => _itemBloc.handleRemoveFavoriteItem(context,
                  item: widget.item, currentUserID: _currentUser!.uid),
              icon: const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber),
            );
          } else {
            return IconButton(
              onPressed: () => _itemBloc.handleAddFavoriteItem(context,
                  item: widget.item, currentUserID: _currentUser!.uid),
              icon: const FaIcon(FontAwesomeIcons.star),
            );
          }
        }

        return FaIcon(FontAwesomeIcons.solidStar, color: Colors.grey.shade200);
      },
    );
  }
}
