import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/other_user_swap_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart';

class MatchedItemsListView extends StatelessWidget {
  const MatchedItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radius = size.height / 8;
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
      builder: (_, state) {
        if (state is UserSwapItemsInitialState) {
          BlocProvider.of<UserSwapItemsBloc>(context)
              .add(LoadUserSwapItemsEvent(userID: currentUser!.uid));
        }

        if (state is UserSwapItemsLoadedState) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: state.matchedList,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Container(height: radius);
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(height: radius);
              }

              //TODO test sorting logic of the matched items
              final List<Widget> items = (snapshot.data!.docs
                    ..sort((a, b) => (getField(a, 'timestamp', Timestamp) as Timestamp? ??
                            Timestamp.now())
                        .compareTo(
                            getField(b, 'timestamp', Timestamp) as Timestamp? ?? Timestamp.now())))
                  .map(
                (doc) {
                  final otherUserID = doc.data().keys.firstWhereOrNull(
                      (element) => element != currentUser!.uid && element != 'timestamp');

                  if (otherUserID == null) return const SizedBox();

                  return SizedBox(
                    child: OtherUserSwapItems(
                      otherUserID: otherUserID,
                      showBadge: getField(doc, currentUser!.uid, bool) == false,
                      matchID: doc.id,
                    ),
                  );
                },
              ).toList();

              items.insert(0, buildShareButton(size));

              return SizedBox(
                height: radius,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: items,
                ),
              );
            },
          );
        }
        return Container(height: radius);
      },
    );
  }

  Widget buildShareButton(Size size) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(right: size.height / 60),
        child: Container(
          height: size.height / 8,
          width: size.height / 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
          child: IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              icon: FaIcon(
                FontAwesomeIcons.users,
                size: size.height / 16,
                color: Colors.white70,
              )),
        ),
      ),
    );
  }
}
