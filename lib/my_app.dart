import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/pages/privacy_policy_page.dart';
import 'package:fibali/fibali_core/ui/pages/user_terms_page.dart';
import 'package:fibali/ui/pages/app_gate.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Future<void> setAppLanguage({
    required String language,
  }) async {
    final settings = BlocProvider.of<SettingsCubit>(Get.context!);
    final state = Get.context!.findAncestorStateOfType<_MyAppState>();

    await settings.setAppLanguage(language: language);
    state?.updateUI();
  }

  static void updateAppUI(context) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.updateUI();
  }

  @override
  State<MyApp> createState() => _MyAppState();

  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xffff1744),
      primaryContainer: Color(0xffd50000),
      secondary: Color(0xffffc107),
      secondaryContainer: Color(0xffff9100),
      tertiary: Color(0xff424242),
      tertiaryContainer: Color(0xffffffff),
      appBarColor: Color(0xffff9100),
      error: Color(0xffb00020),
    ),
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 5,
      blendOnColors: false,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorUnfocusedHasBorder: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      popupMenuRadius: 8.0,
      popupMenuElevation: 3.0,
      drawerIndicatorRadius: 12.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 8.0,
      menuElevation: 3.0,
      menuBarRadius: 0.0,
      menuBarElevation: 2.0,
      menuBarShadowColor: Color(0x00000000),
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarMutedUnselectedLabel: false,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarMutedUnselectedIcon: false,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorOpacity: 1.00,
      navigationBarIndicatorRadius: 12.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailMutedUnselectedLabel: false,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailMutedUnselectedIcon: false,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 12.0,
      navigationRailElevation: 1.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.cairo().fontFamily,
  ).copyWith(
    appBarTheme: AppBarTheme(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.grey.shade100,
      titleTextStyle: GoogleFonts.fredokaOneTextTheme(
        Get.theme.textTheme,
      ).titleLarge?.copyWith(color: Colors.grey.shade300),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xffee003b),
      primaryContainer: Color(0xff920021),
      secondary: Color(0xffffc107),
      secondaryContainer: Color(0xffff9100),
      tertiary: Color(0xff9e9e9e),
      tertiaryContainer: Color(0xffffffff),
      appBarColor: Color(0xffff9100),
      error: Color(0xffcf6679),
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 2,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorUnfocusedHasBorder: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      popupMenuRadius: 8.0,
      popupMenuElevation: 3.0,
      drawerIndicatorRadius: 12.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 8.0,
      menuElevation: 3.0,
      menuBarRadius: 0.0,
      menuBarElevation: 2.0,
      menuBarShadowColor: Color(0x00000000),
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarMutedUnselectedLabel: false,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarMutedUnselectedIcon: false,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorOpacity: 1.00,
      navigationBarIndicatorRadius: 12.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailMutedUnselectedLabel: false,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailMutedUnselectedIcon: false,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 12.0,
      navigationRailElevation: 1.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    fontFamily: GoogleFonts.cairo().fontFamily,
  ).copyWith(
    appBarTheme: AppBarTheme(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.grey.shade100,
      titleTextStyle: GoogleFonts.fredokaOneTextTheme(
        Get.theme.textTheme,
      ).titleLarge?.copyWith(color: Colors.grey.shade300),
    ),
    cardTheme: const CardTheme(
      elevation: 0,
    ),
  );
}

class _MyAppState extends State<MyApp> {
  updateUI() => setState(() {});

  @override
  void initState() {
    configLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => AuthBloc()),
        // BlocProvider(create: (context) => SignUpBloc()),
        // BlocProvider(create: (context) => RCCubit()),
        // BlocProvider(create: (context) => SettingsCubit()),
        // BlocProvider(create: (context) => NearbyCubit()),
        // BlocProvider(create: (context) => DiscoverCubit()),
        // BlocProvider(create: (context) => RelationsCubit()),
        // BlocProvider(create: (context) => BusinessCubit()),
        // BlocProvider(create: (context) => AeBusinessCubit()),
        // BlocProvider(create: (context) => PostCategoriesBloc()),
        // BlocProvider(create: (context) => CloudMessagingBloc()),
        // BlocProvider(create: (context) => NotificationsBloc()),
        // BlocProvider(create: (context) => SwapSearchBloc()),
        // BlocProvider(create: (context) => UserSwapItemsBloc()),
        // BlocProvider(create: (context) => CallHandlerCubit()),
        // BlocProvider(create: (context) => PostBloc()),
        // BlocProvider(create: (context) => SwapItemBloc()),
        // BlocProvider(create: (context) => ItemBloc()),
        // BlocProvider(create: (context) => ChatsBloc()),
        // BlocProvider(create: (context) => SearchCubit()),
        // BlocProvider(create: (context) => TooltipsIntroCubit()),
        // BlocProvider(create: (context) => TranslatorDashboardCubit()),
      ],
      child: ScrollConfiguration(
        behavior: const BouncingScrollBehavior(),
        child: Builder(builder: (context) {
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
              '/': (context) => const AppGate(),
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
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.grey.shade600))),
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
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.grey.shade600))),
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
        }),
      ),
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
