import 'package:fibali/ui/swip_module/widgets/card_overlay.dart';
import 'package:fibali/ui/widgets/swipe_animation_widget.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwapItIntro extends StatefulWidget {
  const SwapItIntro({
    Key? key,
  }) : super(key: key);

  @override
  State<SwapItIntro> createState() => _SwapItIntroState();
}

class _SwapItIntroState extends State<SwapItIntro> {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);

    final key = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.black,
      key: key,
      body: Container(
        decoration: const BoxDecoration(color: Colors.black87),
        child: _SwipeStack(
          widgets: [
            Stack(
              children: [
                const Center(
                  child: PhotoWidget.asset(
                    path: 'assets/find_swaps_around.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 16.0,
                          left: 16.0,
                          bottom: 120,
                        ),
                        child: ListTile(
                          title: Text(RCCubit.instance.getText(R.searchSwapsAroundTitle),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                          subtitle: Column(
                            children: [
                              const Divider(color: Colors.white70),
                              Text(RCCubit.instance.getText(R.searchSwapsAroundDescription),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SwipeAnimationWidget(),
              ],
            ),
            Stack(
              children: [
                const Center(
                  child: PhotoWidget.asset(
                    path: 'assets/match_chat_exchange.png',
                    // fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned.fill(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 16.0,
                          left: 16.0,
                          bottom: 120,
                        ),
                        child: ListTile(
                          title: Text(RCCubit.instance.getText(R.matchChatExchangeTitle),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                          subtitle: Column(
                            children: [
                              const Divider(color: Colors.white70),
                              Text(RCCubit.instance.getText(R.matchChatExchangeDescription),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
          bottomBar: null,
          onSwipeCompleted: (index, direction) {
            if (index == 1) {
              settingsCubit.setSwapItAppIntroduced(true);
              Get.back();
            }
          },
        ),
      ),
    );
  }
}

class _SwipeStack extends StatefulWidget {
  const _SwipeStack({
    required this.widgets,
    required this.onSwipeCompleted,
    this.bottomBar,
  });

  final Null Function(dynamic, dynamic) onSwipeCompleted;

  final List<Widget> widgets;
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
    return SwipableStack(
      controller: _controller,
      stackClipBehaviour: Clip.none,
      allowVerticalSwipe: false,

      itemCount: widget.widgets.length,
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
        final itemIndex = properties.index % widget.widgets.length;
        return widget.widgets[itemIndex];
      },
    );
  }
}
