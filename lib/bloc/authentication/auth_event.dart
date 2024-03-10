import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthenticationEvent {
  final BuildContext context;
  const AppStartedEvent(this.context);
}

class LoggedInEvent extends AuthenticationEvent {}

class LoggedOutEvent extends AuthenticationEvent {
  final BuildContext context;

  const LoggedOutEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoginWithGooglePressed extends AuthenticationEvent {
  @override
  String toString() => 'LoginWithGooglePressed';
}

class LoginWithPhonePressed extends AuthenticationEvent {
  final String phoneNumber;

  const LoginWithPhonePressed({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'LoginWithGooglePressed';
}

class LoginWithFacebookPressed extends AuthenticationEvent {
  @override
  String toString() => 'LoginWithFacebookPressed';
}

class LoginWithEmailAndPassword extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginWithEmailAndPassword(
      {required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
