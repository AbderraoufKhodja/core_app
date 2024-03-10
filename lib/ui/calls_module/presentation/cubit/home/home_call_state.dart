import 'package:fibali/fibali_core/models/chat.dart';

abstract class HomeCallState {}

class HomeInitial extends HomeCallState {}

class ChangeCurrentPageState extends HomeCallState {}

class LoadingGetUsersState extends HomeCallState {}

class SuccessGetUsersState extends HomeCallState {}

class ErrorGetUsersState extends HomeCallState {
  final String message;

  ErrorGetUsersState(this.message);
}

class LoadingGetCallHistoryState extends HomeCallState {}

class SuccessGetCallHistoryState extends HomeCallState {}

class ErrorGetCallHistoryState extends HomeCallState {
  final String message;

  ErrorGetCallHistoryState(this.message);
}

//Sender
class LoadingFireVideoCallState extends HomeCallState {}

class LoadingCallState extends HomeCallState {}

class SuccessFireVideoCallState extends HomeCallState {
  final Chat chat;

  SuccessFireVideoCallState({required this.chat});
}

class ErrorFireVideoCallState extends HomeCallState {
  final String message;
  ErrorFireVideoCallState(this.message);
}

class ErrorPostCallToFirestoreState extends HomeCallState {
  final String message;
  ErrorPostCallToFirestoreState(this.message);
}

class ErrorUpdateUserBusyStatus extends HomeCallState {
  final String message;
  ErrorUpdateUserBusyStatus(this.message);
}

class ErrorSendNotification extends HomeCallState {
  final String message;
  ErrorSendNotification(this.message);
}

//Incoming Call
class SuccessInComingCallState extends HomeCallState {
  final Chat chat;

  SuccessInComingCallState({required this.chat});
}
