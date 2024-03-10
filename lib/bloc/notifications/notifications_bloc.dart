import 'package:fibali/repositories/notifications_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final notificationsRepository = NotificationsRepository();

  NotificationsBloc() : super(NotificationsInitial()) {
    on<InitNotifications>((event, emit) async {
      emit(NotificationsLoading());
      await notificationsRepository.initializeNotifications(
        event.context,
        currentUser: event.currentUser,
      );
      emit(NotificationsLoaded());
    });
  }

  Future<void> cancelNotification({required int notificationId}) {
    return notificationsRepository.cancelNotification(
      notificationId: notificationId,
    );
  }

  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) {
    return notificationsRepository.showNotification(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload);
  }
}
