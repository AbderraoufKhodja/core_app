import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_items_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class InstantMatchSwapItems extends StatelessWidget {
  const InstantMatchSwapItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radius = size.height / 8;
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return SizedBox(
      height: radius,
      child: BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
        builder: (_, state) {
          if (state is UserSwapItemsInitialState) {
            BlocProvider.of<UserSwapItemsBloc>(context)
                .add(LoadUserSwapItemsEvent(userID: currentUser!.uid));
          }
          if (state is UserSwapItemsLoadedState) {
            return StreamBuilder2<QuerySnapshot<Appreciation>, QuerySnapshot<Appreciation>>(
              streams: StreamTuple2(state.chosenList, state.interestedUsers),
              builder: (_, snapshot) {
                if (snapshot.snapshot1.hasError || snapshot.snapshot2.hasError) {
                  return Container();
                }

                if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
                    snapshot.snapshot2.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                final chosenList = snapshot.snapshot1.data!.docs
                    .where((doc) => doc.data().state == ApTypes.like.name)
                    .map((doc) => doc.data())
                    .toList();

                final othersInterest = snapshot.snapshot2.data!.docs
                    .where((doc) => doc.data().isValid())
                    .map((doc) => doc.data())
                    .toList()
                  ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                final matchedUsersID = checkMatch(
                  context,
                  othersInterest: othersInterest,
                  chosenList: chosenList,
                );

                final othersInterestID = othersInterest
                    .map((appreciation) => appreciation.interestBy!)
                    .toSet()
                    .toList()
                  ..removeWhere((userID) => matchedUsersID.contains(userID));

                if (othersInterestID.isEmpty) return buildInfoWidget(size);

                return SwapItemsStack(interestedUsersID: othersInterestID);
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget buildInfoWidget(Size size) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            width: size.height / 8,
            height: size.height / 8,
            alignment: Alignment.center,
            color: Colors.grey.shade300,
            child: FaIcon(
              FontAwesomeIcons.bolt,
              size: size.height / 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  List<String> checkMatch(
    context, {
    required List<Appreciation> othersInterest,
    required List<Appreciation> chosenList,
  }) {
    final othersInterestID =
        othersInterest.map((appreciation) => appreciation.interestBy!).toList();

    final currentInterestID = chosenList.map((appreciation) => appreciation.uid!).toList();

    final matchedUsersID =
        currentInterestID.toSet().intersection(othersInterestID.toSet()).toList();

    return matchedUsersID;
  }
}
