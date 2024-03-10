import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:fibali/env/env.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/my_app.dart';
import 'package:fibali/repositories/notifications_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_installations/firebase_app_installations.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

// TODO: include check connectivity health
// TODO: add freezed boilerplate generator
// TODO: add update name and photo in messages and orders and delete phone number
// TODO: turn items images back
// TODO: remove all snapshot error text widgets

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initializeDateFormatting();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Gemini.init(apiKey: Env.googleGeminiKey);

  // OpenAI.apiKey = Env.openAIKey;

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }
  // if (kDebugMode) {
  //   print(await FirebaseInstallations.instance.getId());
  // }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.playIntegrity,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  debugPrint('Got a message whilst in the background!');
  // If you're going to use other Firebase services in the background, such as Firestore, make sure you call `initializeApp` before using other Firebase services.

  RCCubit? rc;

  final settings = SettingsCubit();
  final result = await Firebase.initializeApp();

  try {
    rc = RCCubit();
    await settings.initSettings();
  } catch (e) {}

  final json = remoteMessage.data['json'] as String;
  final data = jsonDecode(json) as Map<String, dynamic>;
  final notification = AppNotification.fromFirestore(data);

  switch (Utils.enumFromString<AppNotTypes>(AppNotTypes.values, notification.notificationType!)) {
    case AppNotTypes.relation:
      // TODO: Handle this case.
      showNotification(
        settings: settings,
        rc: rc,
        notificationType: notification.notificationType!,
        notification: notification,
        json: json,
      );
      break;
    case AppNotTypes.post:
      // TODO: Handle this case.
      showNotification(
        settings: settings,
        rc: rc,
        notificationType: notification.notificationType!,
        notification: notification,
        json: json,
      );
      break;
    case AppNotTypes.swap:
      // TODO: Handle this case.
      showNotification(
        settings: settings,
        rc: rc,
        notificationType: notification.notificationType!,
        notification: notification,
        json: json,
      );
      break;
    case AppNotTypes.message:
      // TODO: Handle this case.
      switch (Utils.enumFromString<MessageTypes>(MessageTypes.values, notification.type!)) {
        case MessageTypes.photo:
          // TODO: Handle this case.
          showNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;
        case MessageTypes.text:
          // TODO: Handle this case.
          showNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;
        case MessageTypes.location:
          // TODO: Handle this case.
          showNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;
        case MessageTypes.newSwap:
          // TODO: Handle this case.
          showNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;
        case MessageTypes.swapAccepted:
          // TODO: Handle this case.
          showNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;
        case MessageTypes.call:
          // TODO: Handle this case.
          showOngoingCallNotification(
            settings: settings,
            rc: rc,
            notificationType: notification.notificationType!,
            notification: notification,
            json: json,
          );
          break;

        case null:
          break;
      }

      break;
    case AppNotTypes.orderEvent:
      // TODO: Handle this case.
      showNotification(
        settings: settings,
        rc: rc,
        notificationType: notification.notificationType!,
        notification: notification,
        json: json,
      );
      break;
    case AppNotTypes.translatorCall:
      final body = remoteMessage.data['body'];
      //Foreground Msg
      debugPrint('callDataFromNotify $body');
      final bodyJson = jsonDecode(body);

      final notificationId = Random().nextInt(1000);
      const ios = DarwinNotificationDetails();
      final platform = NotificationDetails(
        android: NotificationsRepository.callChannel,
        iOS: ios,
      );

      await NotificationsRepository.flutterLocalNotificationsPlugin.show(
        notificationId,
        '📞Ringing...',
        '${CallModel.fromFirestore(bodyJson).callerName} is calling you',
        platform,
        payload: body,
      );

      await Future.delayed(const Duration(seconds: callDurationInSec), () {
        NotificationsRepository.flutterLocalNotificationsPlugin
            .cancel(notificationId)
            .then((value) {
          showMissedCallNotification(
            senderName: bodyJson['sender']['full_name'],
            data: json,
          );
        });
      });
      break;
    case null:
      break;
  }
}

void showOngoingCallNotification({
  required SettingsCubit settings,
  RCCubit? rc,
  required String notificationType,
  required AppNotification notification,
  required String json,
}) async {
  final notificationId = notification.callID.hashCode;
  const ios = DarwinNotificationDetails();
  final platform = NotificationDetails(
    android: NotificationsRepository.callChannel,
    iOS: ios,
  );
  final timestamp = notification.timestamp as Timestamp?;
  final isOngoing = Timestamp.now().seconds - (timestamp?.seconds ?? 0.toInt()) < 60;
  final isRinging = notification.type == CallStatus.ringing.name;
  final callStatus = Utils.enumFromString<CallStatus>(CallStatus.values, notification.callStatus!);

  if (isOngoing || isRinging) {
    await NotificationsRepository.flutterLocalNotificationsPlugin.show(
      notificationId,
      '📞Ringing...',
      '${notification.senderName} is calling you',
      platform,
      payload: json,
    );
  }

  if (callStatus == CallStatus.unAnswer || callStatus == CallStatus.cancel) {
    await Future.delayed(const Duration(seconds: callDurationInSec), () {
      NotificationsRepository.flutterLocalNotificationsPlugin.cancel(notificationId).then((value) {
        showMissedCallNotification(
          senderName: notification.senderName!,
          data: json,
        );
      });
    });
  }
}

void showMissedCallNotification({required String senderName, required String data}) {
  int notificationId = Random().nextInt(1000);
  var ios = const DarwinNotificationDetails();
  var platform = NotificationDetails(android: NotificationsRepository.normalChannel, iOS: ios);
  NotificationsRepository.flutterLocalNotificationsPlugin.show(
    notificationId,
    '📞Missed Call',
    'You have missed call from $senderName',
    platform,
    payload: data,
  );
}

void showNotification({
  required RCCubit? rc,
  required SettingsCubit? settings,
  required String notificationType,
  required AppNotification notification,
  required String json,
}) {
  final notificationId = Random().nextInt(1000);
  const ios = DarwinNotificationDetails();
  final platform = NotificationDetails(
    android: NotificationsRepository.normalChannel,
    iOS: ios,
  );

  if (notification.senderName != null && notification.notificationType != null) {
    final String? senderName = notification.senderName;
    final String? notificationType = notification.notificationType;
    final String? type = notification.type;
    final String? text = notification.text;

    String? title;
    String? body;

    if (rc != null && settings != null) {
      title = senderName ?? RCCubit.instance.getText(R.notification);
      body = type == AppNotLabels.text.name ? text : rc.getBackText(settings, type ?? '');
    } else {
      title = senderName;
      body = type == AppNotLabels.text.name ? text : type;
    }

    NotificationsRepository.flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platform,
      payload: json,
    );
  }
}

class BounceScrollBehavior extends ScrollBehavior {
  const BounceScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
