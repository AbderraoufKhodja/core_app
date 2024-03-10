import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class SwapItIntroSlides extends StatefulWidget {
  const SwapItIntroSlides({Key? key}) : super(key: key);

  @override
  State<SwapItIntroSlides> createState() => _SwapItIntroSlidesState();
}

class _SwapItIntroSlidesState extends State<SwapItIntroSlides> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return IntroViewsFlutter(
      [
        PageViewModel(
          bubbleBackgroundColor: Colors.grey,
          pageBackground: Stack(
            children: [
              Image.asset(
                'assets/swap_it_intro_0.png',
                height: size.height,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: size.height * 0.35,
                    child: Column(
                      children: [
                        Text(
                          RCCubit.instance.getText(R.oldItemsPilingTitle),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          RCCubit.instance.getText(R.oldItemsPilingDescription),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        PageViewModel(
          bubbleBackgroundColor: Colors.grey,
          pageBackground: Stack(
            children: [
              Image.asset(
                'assets/swap_it_intro_1.png',
                height: size.height,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: size.height * 0.35,
                    child: Column(
                      children: [
                        Text(
                          RCCubit.instance.getText(R.shareThemTitle),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          RCCubit.instance.getText(R.shareThemDescription),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        PageViewModel(
          bubbleBackgroundColor: Colors.grey,
          pageBackground: Stack(
            children: [
              Image.asset(
                'assets/swap_it_intro_2.png',
                height: size.height,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: size.height * 0.35,
                    child: Column(
                      children: [
                        Text(
                          RCCubit.instance.getText(R.findBestItemsAroundTitle),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          RCCubit.instance.getText(R.findBestItemsAroundDescription),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PageViewModel(
          bubbleBackgroundColor: Colors.grey,
          pageBackground: Stack(
            children: [
              Image.asset(
                'assets/swap_it_intro_3.png',
                height: size.height * 0.7,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    RCCubit.instance.getText(R.matchChatExchangeTitle),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Text(
                    RCCubit.instance.getText(R.matchChatExchangeDescription),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        )
      ],
      fullTransition: 200,
      showSkipButton: true,
      onTapBackButton: () async {
        BlocProvider.of<SettingsCubit>(context).setSwapItAppIntroduced(true);
        Get.back(canPop: true);
      },
      doneText: ElevatedButton(
        onPressed: () async {
          BlocProvider.of<SettingsCubit>(context).setSwapItAppIntroduced(true);
          Get.back(canPop: true);
        },
        child: Text(RCCubit.instance.getText(R.done)),
      ),
      skipText: ElevatedButton(
        onPressed: () async {
          BlocProvider.of<SettingsCubit>(context).setSwapItAppIntroduced(true);
          Get.back(canPop: true);
        },
        child: Text(RCCubit.instance.getText(R.skip)),
      ),
    );
  }
}

Future<void> showSwapItIntroSlides(context) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => const SwapItIntroSlides()));
}
