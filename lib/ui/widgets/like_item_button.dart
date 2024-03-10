import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/item/item_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/like.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  ItemBloc get _itemBloc => BlocProvider.of<ItemBloc>(context);
  @override
  Widget build(BuildContext context) {
    final likeRef = Like.ref.doc(_currentUser!.uid + widget.item.itemID!);

    return StreamBuilder<DocumentSnapshot<Like>>(
      stream: likeRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return IconButton(
              onPressed: () => _itemBloc.handleRemoveLikeItem(
                context,
                item: widget.item,
                currentUserID: _currentUser!.uid,
              ),
              icon: FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red.shade400,
              ),
            );
          } else {
            return IconButton(
              onPressed: () => _itemBloc.handleLikeItem(
                context,
                item: widget.item,
                currentUserID: _currentUser!.uid,
              ),
              icon: const FaIcon(FontAwesomeIcons.heart),
            );
          }
        }

        return IconButton(
          icon: FaIcon(
            FontAwesomeIcons.solidHeart,
            color: Colors.grey.shade200,
          ),
          onPressed: null,
        );
      },
    );
  }
}
