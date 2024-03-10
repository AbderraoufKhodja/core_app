import 'package:equatable/equatable.dart';

abstract class LiveState extends Equatable {
  @override
  List<Object> get props => [];
}

class LiveInitial extends LiveState {}

//Agora video room States
class AgoraRemoteUserJoinedLive extends LiveState {}

class AgoraUserLeftEvent extends LiveState {}

class AgoraInitAndJoinedSuccessState extends LiveState {}

class AgoraInitForEmitterSuccessState extends LiveState {}

class AgoraInitForReceiverSuccessState extends LiveState {}

class AgoraSwitchCameraState extends LiveState {}

class AgoraToggleMutedState extends LiveState {}

//Update live Status
class LoadingCancelLiveState extends LiveState {}

class SuccessCancelLiveState extends LiveState {}

class ErrorCancelLiveState extends LiveState {
  final String error;
  ErrorCancelLiveState(this.error);
}

// Live States

class LiveScheduledState extends LiveState {}

class LiveStartingState extends LiveState {}

class LiveOnGoingState extends LiveState {}

class LiveCanceledState extends LiveState {}

class LiveEndedState extends LiveState {}
