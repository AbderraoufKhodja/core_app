import 'dart:async';

import 'package:fibali/ui/pages/account_setup_page.dart' deferred as accountSetupPage;
import 'package:fibali/ui/pages/splash.dart' deferred as splash;
import 'package:fibali/ui/pages/swappers_web_home.dart' deferred as swappersWebHome;
import 'package:fibali/ui/widgets/intro_slides.dart' deferred as introSlides;
import 'login_page.dart' deferred as loginPage;

import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/bloc/authentication/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class WebSwappersAppGate extends StatefulWidget {
  const WebSwappersAppGate({super.key});

  @override
  State<WebSwappersAppGate> createState() => _WebSwappersAppGateState();
}

class _WebSwappersAppGateState extends State<WebSwappersAppGate> {
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
          return FutureBuilder(
            future: splash.loadLibrary(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return splash.Splash();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }

        if (state is Authenticated) {
          BlocProvider.of<AuthBloc>(context).initBlocs();

          return SafeArea(
              top: false,
              bottom: false,
              child: FutureBuilder(
                future: swappersWebHome.loadLibrary(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                          minWidth: 100,
                        ),
                        child: swappersWebHome.SwappersWebHome());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ));

          // if (Get.width > 800) {
          //   return const LargeScreenHome();
          // } else {}
        }

        if (state is AuthenticatedButNotSet) {
          return FutureBuilder(
            future: accountSetupPage.loadLibrary(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return accountSetupPage.AccountSetupPage();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }

        if (state is AuthenticatedButNotIntroduced) {
          return FutureBuilder(
            future: introSlides.loadLibrary(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return introSlides.IntroSlides();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }

        if (state is Unauthenticated) {
          return FutureBuilder(
            future: loginPage.loadLibrary(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return loginPage.LoginPage();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
