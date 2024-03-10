import 'dart:async';

import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SwipeAnimationWidget extends StatefulWidget {
  const SwipeAnimationWidget({super.key});

  @override
  State<SwipeAnimationWidget> createState() => _SwipeAnimationWidgetState();
}

class _SwipeAnimationWidgetState extends State<SwipeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController? _controller;
  final periodicCheck = Stream.periodic(const Duration(seconds: 30));
  late final StreamSubscription? checkSubscription;

  SettingsCubit get settingsCubit => BlocProvider.of<SettingsCubit>(context);
  bool isVisible = true;
  bool isLottieLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!settingsCubit.state.performedFirstSwipe) {
      checkSubscription = periodicCheck.listen((event) {
        if (settingsCubit.state.performedFirstSwipe) {
          checkSubscription?.cancel();
          return;
        }
        if (mounted) {
          setState(() {
            isVisible = true;
          });
          _controller?.repeat();
        }
      });
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    checkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (settingsCubit.state.performedFirstSwipe) {
      return const SizedBox();
    }
    return isVisible
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                if (isLottieLoaded)
                  Container(
                    height: 120,
                    width: Get.width,
                    color: Colors.black54,
                  ),
                Lottie.asset(
                  'assets/124879-swipe-grey.json',
                  // repeat: true,
                  controller: _controller,
                  height: 120,
                  width: Get.width,
                  onLoaded: (lottieController) async {
                    await Future.delayed(const Duration(seconds: 5));

                    isLottieLoaded = true;

                    if (mounted) {
                      setState(() {});
                      _controller!.forward().then((value) {
                        if (mounted) {
                          setState(() {});
                        }
                        isLottieLoaded = false;
                        isVisible = false;
                      });
                    }
                  },
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
