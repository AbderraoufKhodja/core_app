import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final Stream<DocumentSnapshot<AppUser>> currentUser;

  const Authenticated(this.currentUser);

  @override
  List<Object> get props => [currentUser];

  @override
  String toString() => "Authenticated ${currentUser.last}";
}

class Anonymous extends AuthenticationState {
  @override
  String toString() => "Anonymous user";
}

class AuthenticatedButNotSet extends AuthenticationState {
  final String uid;

  const AuthenticatedButNotSet({required this.uid});

  @override
  List<Object> get props => [uid];
}

class AuthenticatedButNotIntroduced extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}
