import 'dart:async';

import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/flavors.dart';

import 'package:fibali/ui/pages/account_setup_page.dart';
import 'package:fibali/ui/pages/fibali_home.dart';
import 'package:fibali/ui/pages/splash.dart';
import 'package:fibali/ui/pages/swappers_home.dart';
import 'package:fibali/ui/widgets/intro_slides.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'login_page.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      // Got a new connectivity status!
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('No internet connection');
      } else {
        debugPrint('Internet connection available');
      }
    });
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  final appLanguage = BlocProvider.of<SettingsCubit>(Get.context!).state.appLanguage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          BlocProvider.of<AuthBloc>(context).add(AppStartedEvent(context));
          return const Splash();
        }

        if (state is Authenticated) {
          BlocProvider.of<AuthBloc>(context).initBlocs();

          if (F.appFlavor == Flavor.swappers) {
            return const SafeArea(
              top: false,
              bottom: false,
              child: SwappersHome(),
            );
          }

          return const SafeArea(
            top: false,
            bottom: false,
            child: FibaliHome(),
          );
          // if (Get.width > 800) {
          //   return const LargeScreenHome();
          // } else {}
        }

        if (state is AuthenticatedButNotSet) {
          return const AccountSetupPage();
        }

        if (state is AuthenticatedButNotIntroduced) {
          return const IntroSlides();
        }

        if (state is Unauthenticated) {
          return const LoginPage();
        }

        return const SizedBox();
      },
    );
  }
}
