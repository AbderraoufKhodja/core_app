part of 'cloud_messaging_bloc.dart';

abstract class CloudMessagingState extends Equatable {
  const CloudMessagingState();

  @override
  List<Object> get props => [];
}

class CloudMessagingInitialState extends CloudMessagingState {}

class CloudMessagingLoadingState extends CloudMessagingState {}

class CloudMessagingLoadedState extends CloudMessagingState {}
