import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_denied_permanently_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_denied_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_disable_widget.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/ui/swip_module/ui/swipe_stack.dart';
import 'package:fibali/ui/swip_module/widgets/example_card.dart';
import 'package:fibali/ui/widgets/no_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwapCardsDecksWidget extends StatefulWidget {
  const SwapCardsDecksWidget({super.key});

  @override
  State<SwapCardsDecksWidget> createState() => _SwapCardsDecksWidgetState();
}

class _SwapCardsDecksWidgetState extends State<SwapCardsDecksWidget> {
  bool showExpansionTileSubtitle = true;

  SwapSearchBloc get _searchBloc => BlocProvider.of<SwapSearchBloc>(context);

  UserSwapItemsBloc get _userSwapBloc => BlocProvider.of<UserSwapItemsBloc>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeoPoint>(
      future: _settingsCubit.getSwapPosition(userID: _currentUser?.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingGrid(width: Get.width - 20);
        }

        if (snapshot.hasError) {
          if (snapshot.error is LocationPermanentlyDeniedException) {
            return const Center(child: LocationDeniedPermanentlyWidget());
          }

          if (snapshot.error is LocationDeniedException) {
            return const Center(child: LocationDeniedWidget());
          }

          if (snapshot.error is LocationDisabledException) {
            return const Center(child: LocationDisableWidget());
          }
        }

        if (snapshot.data is GeoPoint) {
          final geopoint = snapshot.data!;

          return BlocBuilder<SwapSearchBloc, SwapSearchState>(
            builder: (context, state) {
              if (state is SwapSearchInitialState) {
                //TODO: load Liked items
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
                  width: _searchBloc.showRail ? Get.width - (Get.width / 6) : Get.width,
                );
              }

              if (state is SwapItemLoadedState) {
                if (state.swapItems.isEmpty) return const NoItemsWidget();

                final widgets = state.swapItems
                    .map((item) => SizedBox(child: ExampleCard(swapItem: item)))
                    .toList();

                return SizedBox(
                  height: Get.height,
                  child: SwipeStack(
                    widgets: widgets,
                    bottomBar: null,
                    onSwipeCompleted: (index, direction) {
                      /// Get orientation & index of swiped card!
                      if (direction == SwipeDirection.right) {
                        _searchBloc.add(
                          LikeSwapItemEvent(
                            currentUserId: _currentUser!.uid,
                            selectedItemId: state.swapItems[index].itemID!,
                            selectedUserId: state.swapItems[index].uid!,
                          ),
                        );
                      } else if (direction == SwipeDirection.left) {
                        _searchBloc.add(
                          SkipSwapItemEvent(
                            currentUserId: _currentUser!.uid,
                            selectedItemId: state.swapItems[index].itemID!,
                            selectedUserId: state.swapItems[index].uid!,
                          ),
                        );
                      }

                      if (index == widgets.length - 1) {
                        _userSwapBloc.checkHasSwapItems().then(
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
                        if (_searchBloc.hasMore) {
                          _searchBloc.loadMore();
                        } else {
                          _searchBloc.add(NoSwapItemsEvent());
                        }
                      }
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          );
        }
        return Center(
          child: Text(RCCubit.instance.getText(R.oops)),
        );
      },
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
