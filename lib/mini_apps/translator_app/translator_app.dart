import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_appointments_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/translators/translators_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/widgets/top_rounded_navigation_bar.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:get/get.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class TranslatorApp extends StatefulWidget {
  const TranslatorApp({super.key});

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: MediaQuery.of(context).size.height,
        child: AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: const [
            TranslatorBookingPage(),
            TranslatorsPage(),
            TransAppointHistoryPage(),
            Scaffold(body: Center(child: Text("Urgency"))),
          ][indexPage],
        ),
      ),
      bottomNavigationBar: TopRoundedNavigationBar(
        currentIndex: indexPage,
        onTap: (value) => setState(() {
          indexPage = value;
        }),
        items: [
          TopRoundedNavigationBarItem(
            label: RCCubit.instance.getText(R.home),
            selectedIcon: Icons.home_rounded,
          ),
          TopRoundedNavigationBarItem(
            label: RCCubit.instance.getText(R.translators),
            selectedIcon: FontAwesome.users,
            color: const Color(0xFF06F884),
          ),
          TopRoundedNavigationBarItem(
            label: RCCubit.instance.getText(R.history),
            selectedIcon: Icons.history,
            color: Colors.purpleAccent,
          ),
          TopRoundedNavigationBarItem(
            label: RCCubit.instance.getText(R.urgency),
            selectedIcon: Icons.notifications,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

Future<dynamic>? showTranslatorApp(BuildContext context) {
  return Get.to(
    () => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<TranslatorDashboardCubit>(context)),
        BlocProvider.value(value: BlocProvider.of<CallHandlerCubit>(context)),
      ],
      child: const TranslatorApp(),
    ),
  );
}
