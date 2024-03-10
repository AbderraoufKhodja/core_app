import 'dart:async';
import 'dart:io';

import 'package:fibali/repositories/cloud_messaging_repository.dart';
import 'package:fibali/fibali_core/models/recieved_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/authentication/bloc.dart';

class NotificationsRepository {
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // static AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description: 'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  //   playSound: true,
  //   enableVibration: true,
  // );

  static AndroidNotificationDetails callChannel = const AndroidNotificationDetails(
    'com.deepdev.fibali',
    'call_channel',
    autoCancel: false,
    ongoing: true,
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
  );

  static AndroidNotificationDetails normalChannel = const AndroidNotificationDetails(
    'com.deepdev.fibali',
    'normal_channel',
    autoCancel: true,
    ongoing: false,
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
  );

  late DarwinInitializationSettings initializationSettingsDarwin;
  late InitializationSettings initializationSettings;
  late AndroidInitializationSettings initializationSettingsAndroid;

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  static final selectNotificationStream = StreamController<String?>.broadcast();

  /// A notification action which triggers a App navigation event
  static const navigationActionId = 'id_3';

  final selectNotificationSubject = BehaviorSubject<String?>();

  String? selectedNotificationPayload;

  void onDidReceiveLocalNotification({
    required int? id,
    required String? title,
    required String? body,
    required String? payload,
  }) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  Future<void> initializeNotifications(
    context, {
    required AppUser? currentUser,
  }) async {
    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    ///
    initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) {
          onDidReceiveLocalNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          );
        });

    initializationSettingsAndroid = const AndroidInitializationSettings('mipmap/ic_launcher');

    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            if (notificationResponse.payload != null) {
              CloudMessagingRepository.handleMessage(
                currentUser: currentUser,
                codedJson: notificationResponse.payload!,
              );
            }
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.payload != null) {
              CloudMessagingRepository.handleMessage(
                currentUser: currentUser,
                codedJson: notificationResponse.payload!,
              );
            }
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isIOS) {
      final result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      print(result);
    }
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    required NotificationDetails? notificationDetails,
    required String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> cancelNotification({required int notificationId}) {
    return flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    debugPrint('notification action tapped with input: ${notificationResponse.input}');
  }
}
