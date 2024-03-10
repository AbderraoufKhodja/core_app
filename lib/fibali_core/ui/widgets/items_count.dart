import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:flutter/material.dart';

class ItemsCount extends StatefulWidget {
  final int count;

  const ItemsCount({
    required this.count,
  });

  @override
  _ItemsCountState createState() => _ItemsCountState();
}

class _ItemsCountState extends State<ItemsCount> {
  // bool isAnimationOver = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 20,
      height: size.width / 15,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.transparent, Colors.amber],
          stops: [0.1, 0.7],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(size.width / 50),
      ),
      child: Center(
        child: Text(widget.count.toString()),
        // child: isAnimationOver
        //     ? Text(
        //         widget.count.toString(),
        //         style: textStyle,
        //       )
        //     : AnimatedTextKit(
        //         isRepeatingAnimation: false,
        //         pause: Duration.zero,
        //         animatedTexts: widget.count
        //             .asMap()
        //             .map(
        //               (index, value) => MapEntry(
        //                 index,
        //                 RotateAnimatedText(
        //                   (index).toString(),
        //                   duration: Duration(milliseconds: 100),
        //                   textStyle: textStyle,
        //                 ),
        //               ),
        //             )
        //             .values
        //             .toList(),
        //         onFinished: () {
        //           setState(() {
        //             isAnimationOver = !isAnimationOver;
        //           });
        //         },
        //       ),
      ),
    );
    // return BlocBuilder<InterestedUsersBloc, InterestedUsersState>(
    //   builder: (BuildContext context, InterestedUsersState state) {
    //     if (state is InterestedUsersInitialState) {
    //       _interestedUsersBloc.add(
    //         LoadIntrestedUsersEvent(
    //           itemID: widget.currentItem.itemID,
    //         ),
    //       );
    //     }
    //     if (state is LoadingInterestedUsersState) {
    //       return SizedBox();
    //     }
    //     if (state is InterestedUsersLoadedState) {
    //       return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //         stream: state.interestedUsers,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasError) {
    //             return SizedBox();
    //           }

    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return SizedBox();
    //           }

    //           if (snapshot.data!.docs.isEmpty) {
    //             return SizedBox();
    //           }

    //           final _interestedUsersItemsRepository = InterestedUsersItemsRepository();
    //           final _interestedUsersItemsBloc =
    //               InterestedUsersItemsBloc(_interestedUsersItemsRepository);

    //           return BlocProvider(
    //             create: (context) => _interestedUsersItemsBloc,
    //             child: BlocBuilder<InterestedUsersItemsBloc, InterestedUsersItemsState>(
    //               builder: (context, state) {
    //                 if (state is InterestedUsersItemsInitialState) {
    //                   _interestedUsersItemsBloc.add(
    //                     LoadIntrestedUsersItemsEvent(
    //                       interestedUsersID: interestedUsersID,
    //                     ),
    //                   );
    //                 }
    //                 if (state is LoadingInterestedUsersItemsState) {
    //                   return SizedBox();
    //                 }
    //                 if (state is InterestedUsersItemsLoadedState) {
    //                   return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //                     stream: state.otherUsersItems,
    //                     builder: (context, snapshot) {
    //                       if (snapshot.hasError) {
    //                         return SizedBox();
    //                       }

    //                       if (snapshot.connectionState == ConnectionState.waiting) {
    //                         return SizedBox();
    //                       }

    //                       if (snapshot.data!.docs.isEmpty) {
    //                         return SizedBox();
    //                       }

    //                       final chosenItemsID =
    //                           widget.chosenList.map((appreciation) => appreciation.itemID).toList();

    //                       List<Item> interestedUsersItems = [];
    //                       snapshot.data!.docs.forEach((doc) {
    //                         if (!chosenItemsID.contains(doc['itemID']))
    //                           interestedUsersItems.add(Item.fromDocument(doc));
    //                         else
    //                           print(doc['itemID']);
    //                       });

    //                       if (interestedUsersItems.isEmpty) {
    //                         return SizedBox();
    //                       }
    //                     },
    //                   );
    //                 }
    //                 return SizedBox();
    //               },
    //             ),
    //           );
    //         },
    //       );
    //     }
    //     return SizedBox();
    //   },
    // );
  }

  AppUser getInterestedItemUser({
    required List<AppUser> interestedUsersList,
    required String itemUserId,
  }) {
    return interestedUsersList[interestedUsersList.indexWhere(
      (user) => user.uid == itemUserId,
    )];
  }
}
