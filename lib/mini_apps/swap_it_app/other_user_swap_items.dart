import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/matched_item/bloc/matched_item_bloc.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/animated_fading_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherUserSwapItems extends StatelessWidget {
  const OtherUserSwapItems({
    super.key,
    required this.otherUserID,
    required this.showBadge,
    required this.matchID,
  });

  final String otherUserID;
  final String matchID;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemBloc = MatchedItemBloc();
    final radius = size.height / 8;
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return BlocBuilder<MatchedItemBloc, MatchedItemsState>(
      bloc: itemBloc,
      builder: (BuildContext _, MatchedItemsState state) {
        if (state is MatchedItemsInitialState) {
          itemBloc.add(LoadMatchedItemsEvent(userID: otherUserID));
        }

        if (state is MatchedItemsLoadedState) {
          return StreamBuilder<QuerySnapshot<SwapItem>>(
            stream: state.items,
            builder: (_, snapshot) {
              if (snapshot.hasError) return Container();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(height: radius);
              }

              if (snapshot.data?.docs.isEmpty == true) return const SizedBox();

              final items =
                  snapshot.data!.docs.map((doc) => doc.data()).toList();

              return bd.Badge(
                showBadge: showBadge,
                position:
                    bd.BadgePosition.custom(top: 0, end: size.height / 50),
                child: GestureDetector(
                  onTap: () async {
                    final otherUserValidSwapItem =
                        items.firstWhere((swapItem) => swapItem.isValid());

                    final chatID =
                        '${ChatTypes.swapIt.name}_${Utils.getUniqueID(
                      firstID: currentUser!.uid,
                      secondID: otherUserID,
                    )}';

                    if (showBadge) {
                      itemBloc.addViewMatch(
                        matchID: matchID,
                        userID: currentUser.uid,
                      );
                    }

                    showMessagingPage(
                      chatID: chatID,
                      type: ChatTypes.swapIt,
                      otherUserID: otherUserValidSwapItem.uid!,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: size.height / 60),
                    child: SizedBox(
                      child: AnimatedFadingItems(
                        urls: items.map((item) => item.photoUrls?[0]).toList(),
                        height: radius,
                        width: radius,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Container(height: radius);
      },
    );
  }
}
