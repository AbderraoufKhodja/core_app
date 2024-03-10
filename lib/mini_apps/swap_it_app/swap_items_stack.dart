import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/animated_fading_items.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/interested_users_swap_items_bloc/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_widget.dart';
import 'package:fibali/ui/swip_module/widgets/bottom_buttons_row.dart';
import 'package:fibali/ui/swip_module/widgets/card_overlay.dart';
import 'package:fibali/ui/widgets/swap_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:timeago/timeago.dart' as timeago;

class SwapItemsStack extends StatefulWidget {
  final List<String> interestedUsersID;

  const SwapItemsStack({
    super.key,
    required this.interestedUsersID,
  });

  @override
  SwapItemsStackState createState() => SwapItemsStackState();
}

class SwapItemsStackState extends State<SwapItemsStack> {
  final controller = CardController();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SwapSearchBloc get _searchBloc => BlocProvider.of<SwapSearchBloc>(context);

  double get _radius => Get.height / 8;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 60),
      scrollDirection: Axis.horizontal,
      itemCount: widget.interestedUsersID.length,
      itemBuilder: (_, index) {
        final interestedUserSwapItemsBloc = InterestedUserSwapItemsBloc();
        return BlocBuilder<InterestedUserSwapItemsBloc, InterestedUserSwapItemsState>(
          bloc: interestedUserSwapItemsBloc,
          builder: (_, state) {
            if (state is InterestedUserSwapItemsInitialState) {
              interestedUserSwapItemsBloc.add(LoadInterestedUserSwapItemsEvent(
                userID: widget.interestedUsersID[index],
              ));
            }

            if (state is InterestedUserSwapItemsLoadedState) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: state.otherUserSwapItems,
                builder: (_, snapshot) {
                  if (snapshot.hasError) return Container(height: _radius);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(height: _radius);
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Container(height: _radius);
                  }

                  final items =
                      snapshot.data!.docs.map((doc) => SwapItem.fromFirestore(doc.data())).toList();

                  return GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _SwipeStack(
                            items: items.map((item) {
                              return SwapItemWidget(
                                photoUrl: item.photoUrls?[0],
                                photoHeight: Get.height * 0.75,
                                photoWidth: Get.width,
                                clipRadius: Get.height * 0.01,
                                containerWidth: Get.width,
                                containerHeight: Get.height * 0.1,
                                child: _buildCardFooter(
                                  item: item,
                                  interestedUserSwapItemsBloc: interestedUserSwapItemsBloc,
                                ),
                              );
                            }).toList(),
                            bottomBar: null,
                            onSwipeCompleted: (index, direction) {
                              /// Get orientation & index of swiped card!
                              if (direction == SwipeDirection.right) {
                                _searchBloc.add(
                                  LikeSwapItemEvent(
                                    currentUserId: _currentUser!.uid,
                                    selectedItemId: items[index].itemID!,
                                    selectedUserId: items[index].uid!,
                                  ),
                                );
                              } else if (direction == SwipeDirection.left) {
                                _searchBloc.add(
                                  SkipSwapItemEvent(
                                    currentUserId: _currentUser!.uid,
                                    selectedItemId: items[index].itemID!,
                                    selectedUserId: items[index].uid!,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: Get.height / 60),
                      child: SizedBox(
                        height: _radius,
                        width: _radius,
                        child: AnimatedFadingItems(
                          height: _radius,
                          width: _radius,
                          urls: items.map((item) => item.photoUrls![0]).toList(),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return Container(height: _radius);
          },
        );
      },
    );
  }

  AppUser getOtherUser({
    required List<AppUser> otherUsersList,
    required String otherItemId,
  }) {
    return otherUsersList[otherUsersList.indexWhere(
      (user) => user.uid == otherItemId,
    )];
  }

  Widget _buildCardFooter(
      {required SwapItem item, required InterestedUserSwapItemsBloc interestedUserSwapItemsBloc}) {
    final timeAgo = item.timestamp != null ? timeago.format(item.timestamp!.toDate()) : '';
    return FittedBox(
      child: Column(
        children: [
          if (item.description != null)
            Text(
              item.description!,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
            ),
          SizedBox(height: Get.height * 0.01),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                timeAgo,
                style: TextStyle(color: Colors.white),
              ),
              Container(child: const VerticalDivider()),
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    if (BlocProvider.of<SettingsCubit>(context).hasLocation)
                      Text(
                        '${(getDifference(context, location: item.location?['geopoint'])! / 1000).floor()} km ',
                        style: TextStyle(color: Colors.white),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int? getDifference(context, {required GeoPoint location}) {
    if (BlocProvider.of<SettingsCubit>(context).hasLocation) {
      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        BlocProvider.of<SettingsCubit>(context).state.latitude!,
        BlocProvider.of<SettingsCubit>(context).state.longitude!,
      );

      return distance ~/ 1000;
    }
    return null;
  }
}

class _SwipeStack extends StatefulWidget {
  const _SwipeStack({
    required this.items,
    required this.onSwipeCompleted,
    this.bottomBar,
  });

  final Null Function(dynamic, dynamic) onSwipeCompleted;

  final List<Widget> items;
  final Widget? bottomBar;

  @override
  _SwipeStackState createState() => _SwipeStackState();
}

class _SwipeStackState extends State<_SwipeStack> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SwipableStack(
              controller: _controller,
              stackClipBehaviour: Clip.none,
              allowVerticalSwipe: false,
              itemCount: widget.items.length,
              onWillMoveNext: (index, swipeDirection) {
                // Return true for the desired swipe direction.
                switch (swipeDirection) {
                  case SwipeDirection.left:
                  case SwipeDirection.right:
                    return true;
                  case SwipeDirection.up:
                  case SwipeDirection.down:
                    return false;
                }
              },
              onSwipeCompleted: widget.onSwipeCompleted,
              horizontalSwipeThreshold: 0.8,
              // Set max value to ignore vertical threshold.
              verticalSwipeThreshold: 1,
              overlayBuilder: (
                context,
                properties,
              ) =>
                  CardOverlay(
                swipeProgress: properties.swipeProgress,
                direction: properties.direction,
              ),
              builder: (context, properties) {
                final itemIndex = properties.index % widget.items.length;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.items[itemIndex],
                    ),
                    if (itemIndex != widget.items.length - 1)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Divider(),
                          if (widget.bottomBar != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: widget.bottomBar!,
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: BottomButtonsRow(
                                onSwipe: (direction) {
                                  _controller.next(swipeDirection: direction);
                                },
                                onRewindTap: _controller.rewind,
                                canRewind: _controller.canRewind,
                              ),
                            )
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
