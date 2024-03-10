import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fibali/mini_apps/medical_appointment/ui/doctors/doctors_page.dart';
import 'package:fibali/mini_apps/medical_appointment/ui/home/home_page.dart';
import 'package:fibali/mini_apps/medical_appointment/ui/widgets/top_rounded_navigation_bar.dart';
import 'package:fibali/mini_apps/medical_appointment/utils/md_app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
        primaryColor: MdAppColors.kBlue,
        primaryColorLight: MdAppColors.kLightBlue,
        primaryColorDark: MdAppColors.kDarkBlue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.pinkAccent,
        ),
      ),
      home: _MainPage(),
    );
  }
}

class _MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
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
            MedicalHomePage(),
            DoctorsPage(),
            Scaffold(body: Center(child: Text("History"))),
            Scaffold(body: Center(child: Text("Urgency"))),
          ][indexPage],
        ),
      ),
      bottomNavigationBar: TopRoundedNavigationBar(
        currentIndex: indexPage,
        onTap: (value) => setState(() {
          indexPage = value;
        }),
        items: const [
          TopRoundedNavigationBarItem(
            label: 'Home',
            selectedIcon: Icons.home_rounded,
          ),
          TopRoundedNavigationBarItem(
            label: 'Doctors',
            selectedIcon: FontAwesome.user_md,
            color: Color(0xFF06F884),
          ),
          TopRoundedNavigationBarItem(
            label: 'History',
            selectedIcon: Icons.history,
            color: Colors.purpleAccent,
          ),
          TopRoundedNavigationBarItem(
            label: 'Urgency',
            selectedIcon: Icons.notifications,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

Future<void> showMedicalApp(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<SettingsCubit>(context)),
          BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
        ],
        child: const MedicalApp(),
      ),
    ),
  );
}
