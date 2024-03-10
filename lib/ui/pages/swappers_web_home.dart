import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/cloud_messaging/bloc/cloud_messaging_bloc.dart';
import 'package:fibali/bloc/notifications/notifications_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/user_terms.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/pages/user_terms_page.dart' deferred as user_terms;
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_it_grid_page.dart' deferred as swap_it_grid;
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_state.dart';
import 'package:fibali/ui/calls_module/presentation/screens/call_screen.dart';
import 'package:fibali/ui/calls_module/shared/shared_widgets.dart';
import 'package:fibali/ui/pages/chats_page.dart' deferred as chats;
import 'package:fibali/ui/pages/discover_page.dart' deferred as discover;
import 'package:fibali/ui/pages/profile_page.dart' deferred as profile;
import 'package:fibali/ui/widgets/chats_badge.dart';
import 'package:fibali/ui/widgets/home_badge.dart';
import 'package:fibali/ui/widgets/profile_badge.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class SwappersWebHome extends StatefulWidget {
  const SwappersWebHome({super.key});

  @override
  SwappersWebHomeState createState() => SwappersWebHomeState();
}

class SwappersWebHomeState extends State<SwappersWebHome> {
  final pageController = PageController();

  int activeIndex = 0;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  final pages = [
    FutureBuilder(
        future: swap_it_grid.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return swap_it_grid.SwapItGridPage();
          }

          return const CircularProgressIndicator();
        }),
    FutureBuilder(
        future: discover.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return discover.DiscoverPage();
          }

          return const CircularProgressIndicator();
        }),
    FutureBuilder(
        future: chats.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return chats.ChatsPage();
          }

          return const CircularProgressIndicator();
        }),
    FutureBuilder(
        future: profile.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return profile.ProfilePage();
          }

          return const CircularProgressIndicator();
        }),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CloudMessagingBloc>(context)
        .add(InitFCMEvent(context, currentUser: _currentUser));

    BlocProvider.of<NotificationsBloc>(context)
        .add(InitNotifications(context, currentUser: _currentUser));

    UserTerms.ref().orderBy(UTLabels.timestamp.name, descending: true).limit(1).get().then((query) {
      if (query.docs.isNotEmpty) {
        final userTerms = query.docs.first.data();
        final latestUserTermsTimestamp = userTerms.timestamp as Timestamp?;
        final currentUserTermsTimestamp = _currentUser!.userTermsAgreementTimestamp as Timestamp?;
        if (latestUserTermsTimestamp != null &&
            currentUserTermsTimestamp != null &&
            latestUserTermsTimestamp.compareTo(currentUserTermsTimestamp) <= 0) {
          return;
        }
        showUserTermsDialog();
      }
    });

    AppVersionUpdate.checkForUpdates(
      // TODO: update the appleID
      // appleId: "6446277677",
      playStoreId: "com.deepdev.swappers",
    ).then((data) async {
      print(data.storeUrl);
      print(data.storeVersion);
      if (data.canUpdate!) {
        Utils.showBlurredDialog(
          child: AlertDialog(
            title: Text(RCCubit.instance.getText(R.newUpdateAvailableTitle)),
            content: Text(
              RCCubit.instance.getText(R.newUpdateAvailableDescription),
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  launch(data.storeUrl!);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
        //showDialog(... your custom widgets view)
        //or use our widgets
        // AppVersionUpdate.showAlertUpdate
        // AppVersionUpdate.showBottomSheetUpdate
        // AppVersionUpdate.showPageUpdate
      }
    });
  }

  void showUserTermsDialog() {
    Utils.showBlurredDialog(
      barrierDismissible: false,
      child: const UserTermsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallHandlerCubit, HomeCallState>(
      listener: callHandler,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: false,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: pages,
                  ),
                ),
                _buildBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildBottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 4),
        SizedBox(
          child: GNav(
            haptic: true,
            tabBorderRadius: 4,
            curve: Curves.easeInExpo,
            duration: const Duration(milliseconds: 600),
            gap: 8,
            color: Colors.grey[800],
            activeColor: Colors.white30,
            iconSize: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            tabBackgroundColor: Colors.white70,
            textStyle: TextStyle(
              fontSize: 16,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.bagShopping,
                text: RCCubit.instance.getText(R.swaps).toUpperCase(),
                leading: BusinessBadge(isActive: activeIndex == 0),
              ),
              GButton(
                icon: FontAwesomeIcons.earthAfrica,
                text: RCCubit.instance.getText(R.discover).toUpperCase(),
                leading: HomeBadge(isActive: activeIndex == 1),
              ),
              GButton(
                icon: FontAwesomeIcons.solidComments,
                iconColor: Colors.grey,
                text: RCCubit.instance.getText(R.chat).toUpperCase(),
                leading: ChatsBadge(isActive: activeIndex == 2),
              ),
              GButton(
                  iconColor: Colors.grey,
                  icon: FontAwesomeIcons.solidUser,
                  text: RCCubit.instance.getText(R.profile).toUpperCase(),
                  leading: ProfileBadge(isActive: activeIndex == 3))
            ],
            selectedIndex: activeIndex,
            onTabChange: (index) => _onTap(index),
          ),
        ),
      ],
    );
  }

  void callHandler(_, state) async {
    //GetUserData States
    if (state is ErrorGetUsersState) {
      showToast(msg: state.message);
    }
    if (state is ErrorGetCallHistoryState) {
      //  showToast(msg: state.message);
    }
    //FireCall States
    if (state is ErrorFireVideoCallState) {
      // showToast(msg: state.message);
    }
    if (state is ErrorPostCallToFirestoreState) {
      showToast(msg: 'ErrorPostCallToFirestoreState: ${state.message}');
    }
    if (state is ErrorUpdateUserBusyStatus) {
      showToast(msg: state.message);
    }
    if (state is SuccessFireVideoCallState) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      final isReceiver = _currentUser?.uid == state.chat.receiverID;

      return CallScreen.show(chat: state.chat, isReceiver: isReceiver);
    }
    //Receiver Call States
    if (state is SuccessInComingCallState) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      final isReceiver = _currentUser?.uid == state.chat.receiverID;

      return CallScreen.show(chat: state.chat, isReceiver: isReceiver);
    }
  }

  void _onTap(int index) {
    setState(() {
      if (index == 0) {
        FirebaseAnalytics.instance.logScreenView(screenName: 'BusinessScreen - Swappers');
      } else if (index == 1) {
        FirebaseAnalytics.instance.logScreenView(screenName: 'DiscoverScreen - Swappers');
      } else if (index == 2) {
        FirebaseAnalytics.instance.logScreenView(screenName: 'ChatsScreen - Swappers');
      } else if (index == 3) {
        FirebaseAnalytics.instance.logScreenView(screenName: 'ProfileScreen - Swappers');
      }
      activeIndex = index;
      _settingsCubit.setHomeActiveIndex(index);
      pageController.jumpToPage(index);
    });
  }
}

class UserTermsDialog extends StatefulWidget {
  const UserTermsDialog({
    super.key,
  });

  @override
  State<UserTermsDialog> createState() => _UserTermsDialogState();
}

class _UserTermsDialogState extends State<UserTermsDialog> {
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return AlertDialog(
      title: Text(
        RCCubit.instance.getText(R.termsAndConditions),
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                children: [
                  Text(
                    RCCubit.instance.getText(R.askAgreeTermsConditions),
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              user_terms.loadLibrary().then((_) => user_terms.UserTermsPage.show());
            },
            child: Text(
              RCCubit.instance.getText(R.viewTermsAndConditions),
              style: GoogleFonts.cairoTextTheme().bodyMedium,
            ),
          ),
          CheckboxListTile(
            value: _isTermsAccepted,
            onChanged: (value) {
              setState(() {
                _isTermsAccepted = value!;
              });
            },
            title: Text(
              RCCubit.instance.getText(R.iAgreeToTheTermsAndConditions),
              style: Get.textTheme.bodySmall,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isTermsAccepted == false
              ? null
              : () {
                  AppUser.ref.doc(currentUser!.uid).update({
                    AULabels.userTermsAgreementTimestamp.name: FieldValue.serverTimestamp(),
                  });

                  Get.back();
                },
          child: Text(
            RCCubit.instance.getText(R.continu),
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessBadge extends StatefulWidget {
  final bool isActive;

  const BusinessBadge({super.key, required this.isActive});

  @override
  State<BusinessBadge> createState() => _BusinessBadgeState();
}

class _BusinessBadgeState extends State<BusinessBadge> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
      query: FirebaseFirestore.instance
          .collection(swapMatchesCollection)
          .where(_currentUser!.uid, isEqualTo: false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Iconify(
            Mdi.cards_outline,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          );
        }

        if (snapshot.hasError) {
          return Iconify(
            Mdi.cards_outline,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          );
        }

        if (snapshot.docs.isEmpty) {
          return Iconify(
            Mdi.cards_outline,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          );
        }

        final unseenMatches = snapshot.docs.map((doc) => doc.data());

        // Check badge number

        return bd.Badge(
          showBadge: false,
          badgeContent: FittedBox(
            child: Text(
              unseenMatches.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          badgeStyle: const bd.BadgeStyle(
            shape: bd.BadgeShape.circle,
            padding: EdgeInsets.all(3),
          ),
          child: Iconify(
            Mdi.cards_outline,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
            size: 28,
          ),
        );
      },
    );
  }
}
