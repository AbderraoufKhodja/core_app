import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/ui/swip_module/ui/swipe_card.dart';
import 'package:fibali/ui/swip_module/widgets/custom_swap_card.dart';
import 'package:fibali/ui/swip_module/widgets/example_card.dart';
import 'package:fibali/ui/widgets/gps_loader_widget.dart';
import 'package:fibali/ui/widgets/no_items_widget.dart';
import 'package:fibali/ui/widgets/swipe_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:lottie/lottie.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwapCardsGridWidget extends StatefulWidget {
  const SwapCardsGridWidget({super.key});

  @override
  State<SwapCardsGridWidget> createState() => _SwapCardsGridWidgetState();
}

class _SwapCardsGridWidgetState extends State<SwapCardsGridWidget> {
  bool showExpansionTileSubtitle = true;

  SwapSearchBloc get _searchBloc => BlocProvider.of<SwapSearchBloc>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return GPSLoaderWidget(
      loader: (context) => Lottie.asset('assets/90002-enable-location-animation.json'),
      builder: (context, geopoint) => BlocBuilder<SwapSearchBloc, SwapSearchState>(
        builder: (context, state) {
          if (state is SwapSearchInitialState) {
            _searchBloc.loadingSwapItems(
              userGeopoint: geopoint,
              userID: _currentUser!.uid,
            );
            return Lottie.asset('assets/90002-enable-location-animation.json');
          }

          if (state is NoSwapAroundState) {
            return const NoItemsWidget();
          }

          if (state is SwapItemLoadingState) {
            return LoadingGrid(
                width: _searchBloc.showRail ? Get.width - (Get.width / 6) : Get.width);
          }

          if (state is SwapItemLoadedState) {
            if (state.swapItems.isEmpty) return const NoItemsWidget();

            _searchBloc.displayedItemsCount = state.swapItems.length;

            return ListView(
              children: [
                MasonryGridView.count(
                  mainAxisSpacing: 0.0,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedDismissCard(
                        swapItems: state.swapItems,
                        index: index,
                      ),
                    );
                  },
                  itemCount: state.swapItems.length,
                  crossAxisCount: 2,
                ),
                DoubleCirclesWidget(
                  title: RCCubit.instance.getText(R.finishSwipingToSeeMore),
                  description: null,
                  child: Iconify(
                    Mdi.cards_outline,
                    color: Get.isDarkMode ? Colors.white : Colors.grey,
                    size: 80,
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildSwapInfoIcon({
    required IconData icon,
    required String label,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: 3),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 50,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UploadFirstSwapItemWidget extends StatelessWidget {
  const UploadFirstSwapItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          SwapFactoryPage.show(currentUser: currentUser!, itemID: null);
                        },
                        child: Text(RCCubit.instance.getText(R.add)))
                  ],
                ),
                const Divider(
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Lottie.asset(
                    'assets/lf20_uewt8rjj.json',
                    repeat: true,
                  ),
                ),
                Expanded(
                  child: ListTile(
                      title: Text(RCCubit.instance.getText(R.addFirstSwapItemTitle)),
                      subtitle: Text(RCCubit.instance.getText(R.addFirstSwapItemDescription))),
                )
              ],
            ));
      },
    );
  }
}

class AnimatedDismissCard extends StatelessWidget {
  const AnimatedDismissCard({
    super.key,
    required this.swapItems,
    required this.index,
  });

  final List<SwapItem> swapItems;
  final int index;

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SwapSearchBloc>(context);
    final userSwapBloc = BlocProvider.of<UserSwapItemsBloc>(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);

    return Dismissible(
      key: GlobalKey(),
      direction: DismissDirection.horizontal,
      background: SizedBox(
        width: 20,
        child: Iconify(
          Ph.heart_fill,
          color: Colors.red.shade200,
        ),
      ),
      secondaryBackground: Iconify(
        Ph.thumbs_down_fill,
        color: Colors.grey.shade200,
      ),
      onDismissed: (direction) {
        /// Get orientation & index of swiped card!
        if (direction == DismissDirection.startToEnd) {
          if (!settingsCubit.state.performedFirstSwipeRight) {
            settingsCubit.performedFirstSwipe(true);
            settingsCubit.performedFirstSwipeRight(true);
            // show tutorial
            Utils.showBlurredDialog(
                child: AlertDialog(
              title: Text(RCCubit.instance.getText(R.liked)),
              content: Text(RCCubit.instance.getText(R.swipeRightDescription)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    RCCubit.instance.getText(R.ok),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
          }
          searchBloc.add(
            LikeSwapItemEvent(
              currentUserId: currentUser!.uid,
              selectedItemId: swapItems[index].itemID!,
              selectedUserId: swapItems[index].uid!,
            ),
          );
        } else if (direction == DismissDirection.endToStart) {
          if (!settingsCubit.state.performedFirstSwipeLeft) {
            settingsCubit.performedFirstSwipe(true);
            settingsCubit.performedFirstSwipeLeft(true);
            // show tutorial
            Utils.showBlurredDialog(
                child: AlertDialog(
              title: Text(RCCubit.instance.getText(R.skipped)),
              // Explain what happen when you swipe left
              content: Text(RCCubit.instance.getText(R.swipeLeftDescription)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    RCCubit.instance.getText(R.ok),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
          }
          searchBloc.add(
            SkipSwapItemEvent(
              currentUserId: currentUser!.uid,
              selectedItemId: swapItems[index].itemID!,
              selectedUserId: swapItems[index].uid!,
            ),
          );
        }
        if (searchBloc.displayedItemsCount != null) {
          searchBloc.displayedItemsCount = searchBloc.displayedItemsCount! - 1;
        }

        if (searchBloc.displayedItemsCount == 0) {
          userSwapBloc.checkHasSwapItems().then(
            (hasSwapItems) {
              if (!hasSwapItems) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const UploadFirstSwapItemWidget();
                  },
                );
              }
            },
          );

          if (searchBloc.hasMore) {
            searchBloc.loadMore();
          } else {
            searchBloc.add(NoSwapItemsEvent());
          }
        }
      },
      child: Stack(
        children: [
          CustomSwapCard(swapItem: swapItems[index]),
          const SwipeAnimationWidget(),
        ],
      ),
    );
  }
}

class AnimatedSwapCard extends StatefulWidget {
  const AnimatedSwapCard({
    super.key,
    required this.swapItems,
    required this.index,
  });

  final List<SwapItem> swapItems;
  final int index;

  @override
  State<AnimatedSwapCard> createState() => _AnimatedSwapCardState();
}

class _AnimatedSwapCardState extends State<AnimatedSwapCard> {
  bool isUnfolded = true;

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SwapSearchBloc>(context);
    final userSwapBloc = BlocProvider.of<UserSwapItemsBloc>(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return AnimatedContainer(
      width: isUnfolded ? Get.width / 3 : 0,
      height: isUnfolded ? Get.height / 3 : 0,
      duration: const Duration(milliseconds: 500),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        child: SwapCard(
          widgets: ExampleCard(swapItem: widget.swapItems[widget.index]),
          bottomBar: null,
          onSwipeCompleted: (idx, direction) {
            /// Get orientation & index of swiped card!
            if (direction == SwipeDirection.right) {
              searchBloc.add(
                LikeSwapItemEvent(
                  currentUserId: currentUser!.uid,
                  selectedItemId: widget.swapItems[widget.index].itemID!,
                  selectedUserId: widget.swapItems[widget.index].uid!,
                ),
              );
            } else if (direction == SwipeDirection.left) {
              searchBloc.add(
                SkipSwapItemEvent(
                  currentUserId: currentUser!.uid,
                  selectedItemId: widget.swapItems[widget.index].itemID!,
                  selectedUserId: widget.swapItems[widget.index].uid!,
                ),
              );
            }

            if (widget.index == widget.swapItems.length - 1) {
              userSwapBloc.checkHasSwapItems().then(
                (hasSwapItems) {
                  if (!hasSwapItems) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const UploadFirstSwapItemWidget();
                      },
                    );
                  }
                },
              );

              if (searchBloc.hasMore) {
                searchBloc.loadMore();
              } else {
                searchBloc.add(NoSwapItemsEvent());
              }
            }
            setState(() {
              isUnfolded = false;
            });
          },
        ),
      ),
    );
  }
}
