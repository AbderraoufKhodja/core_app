part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class InitNotifications extends NotificationsEvent {
  final BuildContext context;
  final AppUser? currentUser;

  const InitNotifications(
    this.context, {
    required this.currentUser,
  });
}

class ShowNotification extends NotificationsEvent {
  final String channelId, channelName, channelDescription, ticker;
  final Importance importance;
  final Priority priority;

  const ShowNotification({
    required this.channelId,
    required this.channelName,
    required this.channelDescription,
    required this.importance,
    required this.priority,
    required this.ticker,
  });
}
