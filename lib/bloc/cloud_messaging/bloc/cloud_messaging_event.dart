part of 'cloud_messaging_bloc.dart';

abstract class CloudMessagingEvent extends Equatable {
  const CloudMessagingEvent();

  @override
  List<Object?> get props => [];
}

class InitFCMEvent extends CloudMessagingEvent {
  final BuildContext context;
  final AppUser? currentUser;

  const InitFCMEvent(
    this.context, {
    required this.currentUser,
  });

  @override
  List<Object?> get props => [context, currentUser];
}
