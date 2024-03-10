import 'package:bloc/bloc.dart';
import 'package:fibali/repositories/user_repository.dart';
import 'package:fibali/ui/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final _userRepository = UserRepository();

  SignUpBloc() : super(SignUpState.empty()) {
    on<EmailChanged>((event, emit) {
      emit(state.update(
        isEmailValid: Validators.isValidEmail(event.email),
      ));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.update(isEmailValid: Validators.isValidPassword(event.password)));
    });

    on<SignUpWithCredentialsPressed>((event, emit) async {
      emit(SignUpState.loading());

      try {
        await _userRepository.signUpWithEmail(
          email: event.email,
          password: event.password,
        );

        emit(SignUpState.success());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          debugPrint('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          debugPrint('The account already exists for that email.');
        }
        SignUpState.failure();
      } catch (_) {
        SignUpState.failure();
      }
    });
  }
}
