import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/ui/widgets/intro_slides.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class FirebaseAuthRepository {
  final auth = FirebaseAuth.instance;
  // final _facebookAuth = FacebookAuth.instance;
  final googleSignIn = GoogleSignIn();

  ConfirmationResult? _confirmationResult;
  AppUser? currentUser;
  String? verifyID;

  bool get isSignedIn => auth.currentUser != null;

  String get currentUserId => auth.currentUser!.uid;

  Future<void> introduceTheApp() async {
    final value = await isIntroduced();
    if (value == false) {
      await Get.to(() => const IntroSlides());
    }
  }

  Future<UserCredential> loginWithGooglePressed() async {
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return auth.signInWithPopup(googleProvider);
    } else {
      final googleUser = await googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return auth.signInWithCredential(googleAuthCredential);
    }
  }

  // Future<UserCredential> loginWithFacebookPressed() async {
  //   // by default we request the email and the public profile
  //   // or FacebookAuth.i.login()
  //   final result = await _facebookAuth.login();

  //   final accessToken = result.accessToken!;

  //   // Create a credential from the access token
  //   final facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

  //   return auth.signInWithCredential(facebookAuthCredential);
  // }

  Future<UserCredential> loginWithPhoneNumber({
    required String phoneNumber,
    required String smsCode,
    required String? verificationId,
  }) {
    if (kIsWeb) {
      // Sign the user in by providing the SMS code to the confirm method on the resolved ConfirmationResult
      return _confirmationResult!.confirm(smsCode);
    } else {
      // Create a PhoneAuthCredential with the code
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      // Sign the user in (or link) with the credential
      return auth.signInWithCredential(credential);
    }
  }

  Stream<DocumentSnapshot<AppUser>> getCurrentUser({required String userID}) {
    return BehaviorSubject()..addStream(AppUser.ref.doc(userID).snapshots());
  }

  Future<bool> isFirstTime({required String userId}) async {
    late bool exist;
    await FirebaseFirestore.instance.collection(usersCollection).doc(userId).get().then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<bool> isIntroduced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isIntroduced') ?? false;
  }

  Future<void> setIntroduced(bool bool) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIntroduced', bool);
  }

  Future<void> handleVerifyPhoneNumber(context, {required String phoneNumber}) async {
    FAC.logEvent(FAEvent.phone_number_verification);

    if (kIsWeb) {
      _confirmationResult = await auth.signInWithPhoneNumber(phoneNumber);
    } else {
      return auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // // Sign the user in (or link) with the auto-generated credential
          // await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            EasyLoading.showError('The provided phone number is not valid.', dismissOnTap: true);
          }

          // Handle other errors
        },
        codeSent: (String verificationId, int? resendToken) async {
          EasyLoading.showInfo(RCCubit.instance.getText(R.messageSent), dismissOnTap: true);
          verifyID = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }
}
