import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSlides extends StatefulWidget {
  const IntroSlides({Key? key}) : super(key: key);

  @override
  State<IntroSlides> createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  @override
  void initState() {
    FirebaseAnalytics.instance.logTutorialBegin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return IntroViewsFlutter(
      [
        PageViewModel(
          bubbleBackgroundColor: Colors.grey.shade500,
          pageBackground: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Lottie.asset(
                  'assets/90002-enable-location-animation.json',
                  repeat: true,
                  width: Get.width,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                      height: size.height * 0.35,
                      child: Column(
                        children: [
                          Text(
                            RCCubit.instance.getText(R.swap).toUpperCase(),
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const Divider(),
                          Text(
                            RCCubit.instance.getText(R.swapIntroDescription),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        PageViewModel(
          bubbleBackgroundColor: Colors.grey.shade500,
          pageBackground: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Lottie.asset(
                  'assets/91955-social-media-network.json',
                  repeat: true,
                  width: Get.width,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                      height: size.height * 0.35,
                      child: Column(
                        children: [
                          Text(
                            RCCubit.instance.getText(R.connect).toUpperCase(),
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const Divider(),
                          Text(
                            RCCubit.instance.getText(R.connectIntroDescription),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
      fullTransition: 200,
      showSkipButton: true,
      showNextButton: true,
      nextText: Text(
        RCCubit.instance.getText(R.next).toUpperCase(),
        style: Get.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      onTapBackButton: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAppIntroduced', true);
        Get.back(canPop: true);
      },
      doneText: TextButton(
        onPressed: () async {
          FirebaseAnalytics.instance.logTutorialComplete();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAppIntroduced', true);
          Get.back(canPop: true);
        },
        child: Text(
          RCCubit.instance.getText(R.done).toUpperCase(),
          style: Get.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      skipText: TextButton(
        onPressed: () async {
          FirebaseAnalytics.instance.logEvent(name: 'skip_intro');
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isAppIntroduced', true);
          Get.back(canPop: true);
        },
        child: Text(
          RCCubit.instance.getText(R.skip).toUpperCase(),
          style: Get.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Future<void> showIntroSlides(context) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => const IntroSlides()));
}
