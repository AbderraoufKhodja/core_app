import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_item/swap_item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwapItemLikeButton extends StatefulWidget {
  const SwapItemLikeButton({
    Key? key,
    required this.swapItem,
  }) : super(key: key);

  final SwapItem swapItem;

  @override
  State<SwapItemLikeButton> createState() => _SwapItemLikeButtonState();
}

class _SwapItemLikeButtonState extends State<SwapItemLikeButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  SwapItemBloc get _swapItemBloc => BlocProvider.of<SwapItemBloc>(context);

  @override
  Widget build(BuildContext context) {
    final appreciationRef =
        Appreciation.ref.doc('swap_${_currentUser!.uid}${widget.swapItem.itemID!}');

    return StreamBuilder<DocumentSnapshot<Appreciation>>(
      stream: appreciationRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.exists == true) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 4,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                RCCubit.instance.getText(R.liked),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: Colors.grey,
                  height: 1,
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                _swapItemBloc.handleLikeSwapItem(
                  context,
                  swapItem: widget.swapItem,
                  currentUser: _currentUser!,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 4,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  RCCubit.instance.getText(R.like),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: Colors.red,
                    height: 1,
                  ),
                ),
              ),
            );
          }
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 4,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Text(
            RCCubit.instance.getText(R.like),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: Colors.transparent,
              height: 1,
            ),
          ),
        );
      },
    );
  }
}
