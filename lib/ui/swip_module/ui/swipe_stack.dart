import 'package:fibali/ui/swip_module/widgets/bottom_buttons_row.dart';
import 'package:fibali/ui/swip_module/widgets/card_overlay.dart';
import 'package:fibali/ui/widgets/swipe_animation_widget.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeStack extends StatefulWidget {
  const SwipeStack({
    super.key,
    required this.widgets,
    required this.onSwipeCompleted,
    this.bottomBar,
  });
  final Null Function(dynamic, dynamic) onSwipeCompleted;

  final List<Widget> widgets;
  final Widget? bottomBar;

  @override
  SwipeStackState createState() => SwipeStackState();
}

class SwipeStackState extends State<SwipeStack> with TickerProviderStateMixin {
  late AnimationController? _lottieController;
  late final SwipableStackController _controller;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    _lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    super.dispose();
    _lottieController?.dispose();
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
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.widgets[itemIndex],
                    ),
                    if (itemIndex != widget.widgets.length - 1)
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
        if (!_settingsCubit.state.isSwapItAppIntroduced) const SwipeAnimationWidget(),
      ],
    );
  }
}
