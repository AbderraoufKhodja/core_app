import 'package:fibali/ui/swip_module/widgets/card_overlay.dart';
import 'package:fibali/ui/widgets/swipe_animation_widget.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwapCard extends StatefulWidget {
  const SwapCard({
    super.key,
    required this.widgets,
    required this.onSwipeCompleted,
    this.bottomBar,
  });

  final Null Function(dynamic, dynamic) onSwipeCompleted;

  final Widget widgets;
  final Widget? bottomBar;

  @override
  SwapCardState createState() => SwapCardState();
}

class SwapCardState extends State<SwapCard> with TickerProviderStateMixin {
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
    return SwipableStack(
      controller: _controller,
      stackClipBehaviour: Clip.none,

      allowVerticalSwipe: false,
      itemCount: 1,
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
      horizontalSwipeThreshold: 0.1,

      // Set max value to ignore vertical threshold.
      verticalSwipeThreshold: 1,
      overlayBuilder: (context, properties) {
        return CardOverlay(
          swipeProgress: properties.swipeProgress,
          direction: properties.direction,
        );
      },
      builder: (context, properties) {
        return widget.widgets;
      },
    );
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: SwipableStack(
            controller: _controller,
            stackClipBehaviour: Clip.none,
            allowVerticalSwipe: false,
            itemCount: 1,
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
            horizontalSwipeThreshold: 0.1,
            // Set max value to ignore vertical threshold.
            verticalSwipeThreshold: 1,
            overlayBuilder: (context, properties) {
              return CardOverlay(
                swipeProgress: properties.swipeProgress,
                direction: properties.direction,
              );
            },
            builder: (context, properties) {
              return widget.widgets;
            },
          ),
        ),
        if (!_settingsCubit.state.isSwapItAppIntroduced) const SwipeAnimationWidget(),
      ],
    );
  }
}
