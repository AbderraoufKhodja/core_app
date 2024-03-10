import 'package:fibali/bloc/authentication/bloc.dart' deferred as authentication_bloc;
import 'package:fibali/bloc/business/business_cubit.dart' deferred as business_cubit;
import 'package:fibali/bloc/chats/chats_bloc.dart' deferred as chats_bloc;
import 'package:fibali/bloc/cloud_messaging/bloc/cloud_messaging_bloc.dart'
    deferred as cloud_messaging_bloc;
import 'package:fibali/bloc/discover/bloc.dart' deferred as discover_bloc;
import 'package:fibali/bloc/item/item_bloc.dart' deferred as item_bloc;
import 'package:fibali/bloc/nearby/nearby_cubit.dart' deferred as nearby_cubit;
import 'package:fibali/bloc/notifications/notifications_bloc.dart' deferred as notifications_bloc;
import 'package:fibali/bloc/post/post_bloc.dart' deferred as post_bloc;
import 'package:fibali/bloc/relations/bloc.dart' deferred as relations_bloc;
import 'package:fibali/bloc/search/search_cubit.dart' deferred as search_cubit;
import 'package:fibali/bloc/sign_up/sign_up_bloc.dart' deferred as sign_up_bloc;
import 'package:fibali/bloc/tooltips_into/tooltips_intro_cubit.dart'
    deferred as tooltips_intro_cubit;
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart'
    deferred as remote_config_cubit;
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/mini_apps/shopping_app/bloc/post_categories_bloc.dart'
    deferred as post_categories_bloc;
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart' deferred as swap_it_search_bloc;
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_item/swap_item_bloc.dart'
    deferred as swap_it_swap_item_bloc;
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart'
    deferred as translator_dashboard_cubit;
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart'
    deferred as home_call_cubit;
import 'mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart'
    deferred as global_business_bloc;
import 'mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart'
    deferred as swap_it_user_swap_items_bloc;
import 'package:fibali/ui/pages/web_swappers_app_gate.dart' deferred as webSwappersAppGate;

import 'package:fibali/fibali_core/ui/pages/privacy_policy_page.dart';
import 'package:fibali/fibali_core/ui/pages/user_terms_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyWebSwappersApp extends StatefulWidget {
  const MyWebSwappersApp({super.key});

  static Future<void> setAppLanguage({
    required String language,
  }) async {
    final settings = BlocProvider.of<SettingsCubit>(Get.context!);
    final state = Get.context!.findAncestorStateOfType<_MyWebSwappersAppState>();

    await settings.setAppLanguage(language: language);
    state?.updateUI();
  }

  static void updateAppUI(context) {
    final state = context.findAncestorStateOfType<_MyWebSwappersAppState>();
    state?.updateUI();
  }

  @override
  State<MyWebSwappersApp> createState() => _MyWebSwappersAppState();
}

class _MyWebSwappersAppState extends State<MyWebSwappersApp> {
  updateUI() => setState(() {});

  final waitForFutures = Future.wait([
    authentication_bloc.loadLibrary(),
    sign_up_bloc.loadLibrary(),
    remote_config_cubit.loadLibrary(),
    nearby_cubit.loadLibrary(),
    discover_bloc.loadLibrary(),
    relations_bloc.loadLibrary(),
    business_cubit.loadLibrary(),
    global_business_bloc.loadLibrary(),
    post_categories_bloc.loadLibrary(),
    cloud_messaging_bloc.loadLibrary(),
    notifications_bloc.loadLibrary(),
    swap_it_search_bloc.loadLibrary(),
    swap_it_user_swap_items_bloc.loadLibrary(),
    home_call_cubit.loadLibrary(),
    post_bloc.loadLibrary(),
    swap_it_swap_item_bloc.loadLibrary(),
    item_bloc.loadLibrary(),
    chats_bloc.loadLibrary(),
    search_cubit.loadLibrary(),
    tooltips_intro_cubit.loadLibrary(),
    translator_dashboard_cubit.loadLibrary(),
  ]);

  @override
  void initState() {
    configLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitForFutures,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final providers = [
              BlocProvider(create: (context) => SettingsCubit()),
              BlocProvider(create: (context) => authentication_bloc.AuthBloc()),
              BlocProvider(create: (context) => sign_up_bloc.SignUpBloc()),
              BlocProvider(create: (context) => remote_config_cubit.RCCubit()),
              BlocProvider(create: (context) => nearby_cubit.NearbyCubit()),
              BlocProvider(create: (context) => discover_bloc.DiscoverCubit()),
              BlocProvider(create: (context) => relations_bloc.RelationsCubit()),
              BlocProvider(create: (context) => business_cubit.BusinessCubit()),
              BlocProvider(create: (context) => global_business_bloc.AeBusinessCubit()),
              BlocProvider(create: (context) => post_categories_bloc.PostCategoriesBloc()),
              BlocProvider(create: (context) => cloud_messaging_bloc.CloudMessagingBloc()),
              BlocProvider(create: (context) => notifications_bloc.NotificationsBloc()),
              BlocProvider(create: (context) => swap_it_search_bloc.SwapSearchBloc()),
              BlocProvider(create: (context) => swap_it_user_swap_items_bloc.UserSwapItemsBloc()),
              BlocProvider(create: (context) => home_call_cubit.CallHandlerCubit()),
              BlocProvider(create: (context) => post_bloc.PostBloc()),
              BlocProvider(create: (context) => swap_it_swap_item_bloc.SwapItemBloc()),
              BlocProvider(create: (context) => item_bloc.ItemBloc()),
              BlocProvider(create: (context) => chats_bloc.ChatsBloc()),
              BlocProvider(create: (context) => search_cubit.SearchCubit()),
              BlocProvider(create: (context) => tooltips_intro_cubit.TooltipsIntroCubit()),
              BlocProvider(
                  create: (context) => translator_dashboard_cubit.TranslatorDashboardCubit()),
            ];
            return MultiBlocProvider(
              providers: providers,
              child: ScrollConfiguration(
                behavior: const BouncingScrollBehavior(),
                child: Builder(builder: (context) {
                  return const SwappersWebGetMaterialApp();
                }),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class SwappersWebGetMaterialApp extends StatelessWidget {
  const SwappersWebGetMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Made for FlexColorScheme version 7.0.5. Make sure you
      // use same or higher package version, but still same major version.
      // If you use a lower version, some properties may not be supported.
      // In that case remove them after copying this theme to your app.
      // theme: MyApp.lightTheme,
      // darkTheme: MyApp.darkTheme,
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      // themeMode: ThemeMode.system,
      routes: {
        '/': (context) => FutureBuilder(
          future: webSwappersAppGate.loadLibrary(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return webSwappersAppGate.WebSwappersAppGate();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        '/terms': (context) => const UserTermsPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
      },
      theme: FlexThemeData.light(
        scheme: FlexScheme.barossa,
        textTheme: GoogleFonts.cairoTextTheme(),
        scaffoldBackground: Colors.grey.shade200,
        subThemesData: const FlexSubThemesData(
          cardElevation: 2,
          inputDecoratorRadius: 8,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFillColor: Colors.white,
          elevatedButtonRadius: 8,
        ),
        // appBarBackground: Colors.transparent,
      ).copyWith(
        tabBarTheme: TabBarTheme(
          labelColor: Colors.grey,
          labelStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: Colors.blue),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade600),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey.shade600))),
        dialogTheme: DialogTheme(
          titleTextStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 14,
          ),
          elevation: 0,
          backgroundColor: Colors.grey[400],
        ),
        appBarTheme: AppBarTheme(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.grey.shade100,
          titleTextStyle: Get.locale?.languageCode == 'ar'
              ? GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)
                  .titleLarge
                  ?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold)
              : GoogleFonts.fredokaOneTextTheme(Theme.of(context).textTheme)
                  .titleLarge
                  ?.copyWith(color: Colors.grey.shade600),
        ),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.barossa,
        textTheme: GoogleFonts.cairoTextTheme(),
        subThemesData: const FlexSubThemesData(
          cardElevation: 2,
          inputDecoratorRadius: 8,
          inputDecoratorFillColor: Colors.white,
          inputDecoratorUnfocusedHasBorder: false,
          elevatedButtonRadius: 8,
        ),
        // appBarBackground: Colors.transparent,
      ).copyWith(
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          labelStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: Colors.blue),
          ),
        ),
        cardColor: Colors.grey.shade900,
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey.shade600))),
        dialogTheme: DialogTheme(
          titleTextStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: GoogleFonts.cairo(
            color: Colors.black54,
            fontSize: 14,
          ),
          elevation: 0,
          backgroundColor: Colors.grey[400],
        ),
        appBarTheme: AppBarTheme(
          elevation: 1,
          centerTitle: true,
          titleTextStyle: GoogleFonts.fredokaOneTextTheme(Theme.of(context).textTheme)
              .titleLarge
              ?.copyWith(color: Colors.grey.shade200),
        ),
      ),

      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class BouncingScrollBehavior extends ScrollBehavior {
  const BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black87
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
