import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/notifications/notifications_bloc.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/repositories/cloud_messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'cloud_messaging_event.dart';

part 'cloud_messaging_state.dart';

class CloudMessagingBloc extends Bloc<CloudMessagingEvent, CloudMessagingState> {
  final _fcmRepository = CloudMessagingRepository();

  CloudMessagingBloc() : super(CloudMessagingInitialState()) {
    on<InitFCMEvent>((event, emit) async {
      emit(CloudMessagingLoadingState());
      _fcmRepository.subscribeToFeedsTopic();
      _fcmRepository.handleDynamicLinks();

      await _fcmRepository.initFCM(
        event.context,
        currentUser: event.currentUser,
      );

      emit(CloudMessagingLoadedState());
    });
  }

  void showNotification(context) {
    final notificationsBloc = BlocProvider.of<NotificationsBloc>(context);

    final notificationId = Random().nextInt(1000);
    const ios = DarwinNotificationDetails(

    );
    const platform = NotificationDetails(
      android: AndroidNotificationDetails(
        '2',
        '2',
        autoCancel: true,
        ongoing: false,
        channelShowBadge: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        actions: [
          AndroidNotificationAction(
            '256',
            'title',
          )
        ],
      ),
      iOS: ios,
    );
    notificationsBloc
        .showNotification(
      id: notificationId,
      title: 'Test notification',
      body: 'a new notification',
      notificationDetails: platform,
      payload: null,
    )
        .onError((error, stackTrace) => debugPrint(error.toString()));
  }
}
