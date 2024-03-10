import 'package:app_version_update/app_version_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/cloud_messaging/bloc/cloud_messaging_bloc.dart';
import 'package:fibali/bloc/notifications/notifications_bloc.dart';

import 'package:fibali/fibali_core/models/user_terms.dart';
import 'package:fibali/fibali_core/utils/utils.dart';

import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_state.dart';
import 'package:fibali/ui/calls_module/presentation/screens/call_screen.dart';
import 'package:fibali/ui/calls_module/shared/shared_widgets.dart';
import 'package:fibali/ui/pages/business_page.dart';
import 'package:fibali/ui/pages/chats_page.dart';
import 'package:fibali/ui/pages/discover_page.dart';

import 'package:fibali/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:url_launcher/url_launcher.dart';

class LargeScreenHome extends StatefulWidget {
  const LargeScreenHome({super.key});

  @override
  LargeScreenHomeState createState() => LargeScreenHomeState();
}

class LargeScreenHomeState extends State<LargeScreenHome> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

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
      }
    });

    AppVersionUpdate.checkForUpdates(
      appleId: "6446277677",
      playStoreId: "com.deepdev.fibali",
    ).then((data) async {
      print(data.storeUrl);
      print(data.storeVersion);
      if (data.canUpdate!) {
        Utils.showBlurredDialog(
          child: AlertDialog(
            title: const Text('New update available'),
            content: const Text(
              'We have a new version available for you to download. Please update to the latest version to enjoy the latest features and improvements.',
              style: TextStyle(fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallHandlerCubit, HomeCallState>(
        listener: (_, state) async {
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
            final isReceiver = _currentUser?.uid == state.chat.receiverID;
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (!isReceiver) {
              return CallScreen.show(chat: state.chat, isReceiver: isReceiver);
            }
          }
          //Receiver Call States
          if (state is SuccessInComingCallState) {
            final isReceiver = _currentUser?.uid == state.chat.receiverID;
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (isReceiver) {
              return CallScreen.show(chat: state.chat, isReceiver: isReceiver);
            }
          }
        },
        child: const Row(children: [
          Expanded(child: DiscoverPage()),
          Expanded(child: BusinessPage()),
          Expanded(child: ChatsPage()),
          Expanded(child: ProfilePage()),
        ]));
  }
}
