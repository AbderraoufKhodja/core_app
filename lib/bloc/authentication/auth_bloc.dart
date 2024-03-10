import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fibali/bloc/business/business_cubit.dart';
import 'package:fibali/bloc/discover/discover_cubit.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/app_device_info.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/otp_timer.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/my_app.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/pages/select_language_page.dart';
import 'package:fibali/ui/widgets/intro_slides.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import './bloc.dart';

export 'package:fibali/fibali_core/models/app_user.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final auth = FirebaseAuth.instance;
  static final deviceInfoPlugin = DeviceInfoPlugin();

  // final _facebookAuth = FacebookAuth.instance;
  final _googleSignIn = GoogleSignIn();
  StreamSubscription<DocumentSnapshot<AppUser>>? currentUserStreamSubscription;
  Stream<DocumentSnapshot<AppUser>>? currentUserStream;

  ConfirmationResult? _confirmationResult;
  AppUser? currentUser;
  String? verifID;

  bool get isSignedIn => auth.currentUser != null;

  String? get _currentUserId => auth.currentUser?.uid;

  AuthBloc() : super(Uninitialized()) {
    on<AppStartedEvent>((event, emit) async {
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        return await Future.wait([
          BlocProvider.of<RCCubit>(event.context).setupRemoteConfig(),
          BlocProvider.of<SettingsCubit>(event.context).initSettings(),
        ]).then((value) {
          debugPrint('init done');
          return false;
        }).onError((error, stackTrace) {
          debugPrint(' try init again');
          error.printError();
          return true;
        });
      });

      await selectLanguage();
      await introduceTheApp();

      try {
        if (!isSignedIn) {
          emit(Unauthenticated());
        }
        if (isSignedIn) {
          final currentUserDoc = await getCurrentUserDoc(userId: _currentUserId!);
          if (!currentUserDoc.exists) {
            emit(AuthenticatedButNotSet(uid: _currentUserId!));
          } else {
            currentUser = currentUserDoc.data()!;

            // cancel stream subscription
            if (currentUserStreamSubscription != null) {
              currentUserStreamSubscription!.cancel();
            }

            currentUserStream = _getCurrentUserStream(userID: _currentUserId!);
            currentUserStreamSubscription = currentUserStream!.listen((event) {
              currentUser = event.data();
              if (currentUser != null) {
                FAC.setUserProperties(currentUser: currentUser!);
              }
            });
            FAC.logEvent(FAEvent.successful_log_in);
            emit(Authenticated(currentUserStream!));
          }
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });

    on<LoggedInEvent>(
      (event, emit) async {
        EasyLoading.show(dismissOnTap: false);
        FAC.logEvent(FAEvent.start_log_in);
        await Future.doWhile(() async {
          await Future.delayed(const Duration(seconds: 1));

          try {
            final currentUserDoc = await getCurrentUserDoc(userId: _currentUserId!)
                .timeout(const Duration(seconds: 8));
            if (auth.currentUser?.isAnonymous == true) {
              if (!currentUserDoc.exists) {
                // removed await
                _addAnonymousNewUser(
                  name: 'Anonymous_${_currentUserId!.codeUnits.join().substring(0, 8)}',
                  userID: _currentUserId!,
                );
              }

              final doc = await getCurrentUserDoc(userId: _currentUserId!)
                  .timeout(const Duration(seconds: 8));

              currentUser = doc.data()!;

              // cancel stream subscription
              if (currentUserStreamSubscription != null) {
                currentUserStreamSubscription!.cancel();
              }

              currentUserStream = _getCurrentUserStream(userID: _currentUserId!);
              currentUserStreamSubscription = currentUserStream!.listen((event) {
                currentUser = event.data();
                if (currentUser != null) {
                  FAC.setUserProperties(currentUser: currentUser!);
                }
              });
              // Successful login
              FAC.logEvent(FAEvent.successful_log_in);
              emit(Authenticated(currentUserStream!));
              EasyLoading.dismiss();
              return false;
            } else {
              if (!currentUserDoc.exists) {
                emit(AuthenticatedButNotSet(uid: _currentUserId!));
              } else {
                currentUser = currentUserDoc.data()!;

                // cancel stream subscription
                if (currentUserStreamSubscription != null) {
                  currentUserStreamSubscription!.cancel();
                }

                currentUserStream = _getCurrentUserStream(userID: _currentUserId!);
                currentUserStreamSubscription = currentUserStream!.listen((event) {
                  currentUser = event.data();
                  if (currentUser != null) {
                    FAC.setUserProperties(currentUser: currentUser!);
                  }
                });
                FAC.logEvent(FAEvent.successful_log_in);
                emit(Authenticated(currentUserStream!));
              }

              EasyLoading.dismiss();
              return false;
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(Unauthenticated());

            return true;
          }
        });
      },
    );

    on<LoggedOutEvent>(
      (event, emit) async {
        try {
          FAC.logEvent(FAEvent.log_out);
          await handleSignOut(event.context);
          emit(Unauthenticated());
        } catch (error) {
          debugPrint(error.toString());
        }
      },
    );
  }

  // logging anonymously
  Future<UserCredential> loggingAnonymously() {
    return auth.signInAnonymously();
  }

  // If user is not logged in or is anonymous, ask them to ~login
  Future<bool> needLogIn() async {
    final isAuthenticated = auth.currentUser != null && auth.currentUser!.isAnonymous == false;
    if (isAuthenticated) {
      return false;
    } else {
      Get.dialog<bool?>(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white70,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            title: Text(RCCubit.instance.getText(R.logIn)),
            content: Text(RCCubit.instance.getText(R.needToLogin)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(RCCubit.instance.getText(R.cancel)),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  emit(Unauthenticated());
                },
                child: Text(RCCubit.instance.getText(R.logIn)),
              ),
            ],
          ),
        ),
      );
      return true;
    }
  }

  Future<void> selectLanguage() async {
    try {
      final isNull = BlocProvider.of<SettingsCubit>(Get.context!).state.appLanguage == null;
      if (isNull) {
        final defaultLocale = Get.deviceLocale?.languageCode;
        await MyApp.setAppLanguage(language: defaultLocale ?? 'en');
        await Get.to(() => const SelectLanguagePage());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> introduceTheApp() async {
    final value = await isAppIntroduced();
    if (value == false) {
      await Get.to(() => const IntroSlides());
    }
  }

  Future<UserCredential> loginWithGooglePressed() async {
    if (kIsWeb) {
      // Create a new provider
      final googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');

      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return auth.signInWithPopup(googleProvider);
    } else {
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return auth.signInWithCredential(googleAuthCredential);
    }
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    // final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      // rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
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

  Future<void> handleVerifyPhoneNumber(context, {required String phoneNumber}) async {
    FAC.logEvent(FAEvent.verify_phone_number);

    final timerCubit = BlocProvider.of<TimerCubit>(context);

    if (kIsWeb) {
      _confirmationResult = await auth.signInWithPhoneNumber(phoneNumber);
    } else {
      timerCubit.loading();
      return auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          // await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          timerCubit.enableButton();
          if (e.code == 'invalid-phone-number') {
            EasyLoading.showError('The provided phone number is not valid.', dismissOnTap: true);
          } else {
            EasyLoading.showError(
                'An error occurred. Please try again later or use another login method.',
                dismissOnTap: true);
          }
          debugPrint(e.toString());

          // Handle other errors
        },
        codeSent: (String verificationId, int? resendToken) async {
          timerCubit.startTimer();
          EasyLoading.showInfo(RCCubit.instance.getText(R.messageSent), dismissOnTap: true);
          verifID = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  Future<void> handleSignOut(context) async {
    FAC.logEvent(FAEvent.log_out);

    EasyLoading.show(status: RCCubit.instance.getText(R.loggingOut), dismissOnTap: true);
    AppDeviceInfo? deviceInfo;

    try {
      deviceInfo = await getDeviceInfo();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      if (deviceInfo != null) {
        await AppUser.ref.doc(currentUser?.uid).update(
          {
            '${AULabels.devices.name}.${deviceInfo.deviceID!}.${DeviceParameters.lastLoggedOutTimestamp.name}':
                FieldValue.serverTimestamp(),
            '${AULabels.devices.name}.${deviceInfo.deviceID!}.${DeviceParameters.isLogged.name}':
                false,
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return Future.wait([
      if (auth.currentUser?.providerData[0].providerId == 'google.com')
        _googleSignIn.signOut()
      else
        auth.signOut(),
      // _facebookAuth.logOut(),
    ]).then((value) {
      currentUser = null;
      EasyLoading.dismiss(animation: true);
      Get.until((route) => Get.currentRoute == '/');
    }).onError((error, stackTrace) {
      Logger().e(error);
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }

  Future<void> handleAddNewUser(
    context, {
    required XFile? photoFile,
    required String? photoUrl,
    required String name,
    required Map<String, dynamic>? defaultAddress,
    required String userID,
  }) async {
    FAC.logEvent(FAEvent.add_new_user);

    EasyLoading.show(status: RCCubit.instance.getText(R.creatingUser), dismissOnTap: true);
    _addNewUser(
      photoFile: photoFile,
      providerPhotoUrl: photoUrl,
      name: name,
      defaultAddress: defaultAddress,
      userID: userID,
    ).then((value) {
      EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);

      add(LoggedInEvent());
    }).onError((error, stackTrace) {
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }

  Future<void> _addAnonymousNewUser({
    required String name,
    required String userID,
  }) async {
    String? country;
    String? fcmToken;
    Map<String, dynamic>? location;
    AppDeviceInfo? deviceInfo;

    try {
      final geopoint = await SettingsCubit.determinePosition(userID: null);

      location = GeoFlutterFire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
          .dataForThreeHundredKm;

      final placemark = await placemarkFromCoordinates(
        geopoint.latitude,
        geopoint.longitude,
      );

      if (placemark.isNotEmpty) {
        country = placemark[0].isoCountryCode;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      if (kIsWeb) {
        fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: kVapidKey);
      }
      if (!kIsWeb) fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      deviceInfo = await getDeviceInfo();
    } catch (e) {
      debugPrint(e.toString());
    }

    final user = AppUser(
      uid: userID,
      name: name,
      isVerified: false,
      phoneNumber: auth.currentUser?.phoneNumber,
      email: auth.currentUser?.email,
      backgroundPhoto: null,
      country: country,
      bio: null,
      birthDay: null,
      gender: null,
      deliveryAddress: null,
      location: location,
      devices: deviceInfo?.deviceID != null
          ? {
              deviceInfo!.deviceID!: {
                DeviceParameters.deviceID.name: deviceInfo.deviceID!,
                DeviceParameters.data.name: deviceInfo.deviceData!,
                DeviceParameters.token.name: fcmToken,
                DeviceParameters.lastTokenTimestamp.name: FieldValue.serverTimestamp(),
                DeviceParameters.lastLoggedInTimestamp.name: FieldValue.serverTimestamp(),
                DeviceParameters.lastLoggedOutTimestamp.name: null,
                DeviceParameters.isLogged.name: true,
              },
            }
          : null,
      userTermsAgreementTimestamp: null,
      businessType: null,
      isSeller: null,
      isActive: true,
      isAnonymous: true,
      busyCalling: false,
      relations: null,
      numFollower: 0,
      numFollowing: 0,
      avgSwapRating: null,
      numSwapRating: 0,
      photoUrl: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    return AppUser.ref.doc(_currentUserId).set(user);
  }

  Future<void> _addNewUser({
    required XFile? photoFile,
    required String name,
    required Map<String, dynamic>? defaultAddress,
    required String userID,
    required String? providerPhotoUrl,
  }) async {
    final appUserRef = AppUser.ref.doc(userID);
    final user = AppUser(
      uid: userID,
      name: name,
      isVerified: false,
      phoneNumber: auth.currentUser?.phoneNumber,
      email: auth.currentUser?.email,
      backgroundPhoto: null,
      country: null,
      bio: null,
      birthDay: null,
      gender: null,
      deliveryAddress: null,
      location: null,
      devices: null,
      userTermsAgreementTimestamp: null,
      businessType: null,
      isSeller: null,
      isActive: true,
      isAnonymous: false,
      busyCalling: false,
      relations: null,
      numFollower: 0,
      numFollowing: 0,
      avgSwapRating: null,
      numSwapRating: 0,
      photoUrl: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    appUserRef.set(user);

    if (photoFile != null) {
      Utils.futureDoWhile(
        func: () async {
          final photoRef = AppUser.photoStorageRef(userID: userID);
          late final String url;
          url = await Utils.uploadPhoto(file: photoFile, ref: photoRef, needModeration: true);
          appUserRef.update({AULabels.photoUrl.name: url});
        },
        maxTries: 2,
      );
    } else {
      appUserRef.update({AULabels.photoUrl.name: providerPhotoUrl});
    }

    Utils.futureDoWhile(
      func: () async {
        Map<String, dynamic>? location;
        String? country;

        final geopoint = await SettingsCubit.determinePosition(userID: null);

        final placemark = await placemarkFromCoordinates(
          geopoint.latitude,
          geopoint.longitude,
        );

        location = GeoFlutterFire()
            .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
            .dataForThreeHundredKm;

        if (placemark.isNotEmpty) {
          country = placemark[0].isoCountryCode;
        }

        appUserRef.update({
          if (country != null) AULabels.country.name: country,
          AULabels.location.name: location,
        });
      },
      maxTries: 2,
    );

    Utils.futureDoWhile(
      func: () async {
        String? fcmToken;
        AppDeviceInfo? deviceInfo;

        if (kIsWeb) {
          fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: kVapidKey);
        } else {
          fcmToken = await FirebaseMessaging.instance.getToken();
        }

        deviceInfo = await getDeviceInfo();

        appUserRef.update({
          AULabels.devices.name: deviceInfo.deviceID != null
              ? {
                  deviceInfo.deviceID!: {
                    DeviceParameters.deviceID.name: deviceInfo.deviceID!,
                    DeviceParameters.data.name: deviceInfo.deviceData!,
                    DeviceParameters.token.name: fcmToken,
                    DeviceParameters.lastTokenTimestamp.name: FieldValue.serverTimestamp(),
                    DeviceParameters.lastLoggedInTimestamp.name: FieldValue.serverTimestamp(),
                    DeviceParameters.lastLoggedOutTimestamp.name: null,
                    DeviceParameters.isLogged.name: true,
                  },
                }
              : null
        });
      },
      maxTries: 2,
    );

    return AppUser.ref.doc(_currentUserId).set(user);
  }

  static Future<AppDeviceInfo> getDeviceInfo() async {
    String? deviceID;
    Map<String, dynamic>? deviceData;

    if (Platform.isIOS) {
      // import 'dart:io'
      // INFO: Device ID can't have "." in it's name $.replaceAll('.', '_')
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor?.replaceAll('.', '_'); // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceID = androidDeviceInfo.id.replaceAll('.', '_'); // unique ID on Android
    }
    deviceData = await deviceInfoPlugin.deviceInfo.then((value) => value.data);

    return AppDeviceInfo(deviceID: deviceID, deviceData: deviceData);
  }

  Stream<DocumentSnapshot<AppUser>> _getCurrentUserStream({required String userID}) {
    return BehaviorSubject()..addStream(AppUser.ref.doc(userID).snapshots());
  }

  Future<DocumentSnapshot<AppUser>> getCurrentUserDoc({required String userId}) async {
    late DocumentSnapshot<AppUser> appUser;
    try {
      appUser = await AppUser.ref.doc(userId).get(const GetOptions(source: Source.cache));
    } catch (e) {
      debugPrint(e.toString());
      appUser = await AppUser.ref.doc(userId).get(const GetOptions(source: Source.server));
    }

    return appUser;
  }

  Future<bool> hasBusiness({required String userId}) async {
    return AppUser.ref
        .doc(userId)
        .get(const GetOptions(source: Source.server))
        .then<bool>((user) => user.data()?.businessType != null);
  }

  Future<bool> isSwapItAppIntroduced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSwapItAppIntroduced') == true;
  }

  Future<bool> isAppIntroduced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAppIntroduced') == true;
  }

  initBlocs() {
    BlocProvider.of<RelationsCubit>(Get.context!).emit(RelationsInitial());
    BlocProvider.of<UserSwapItemsBloc>(Get.context!).add(SetInitUserSwapItemsEvent());
    if (auth.currentUser?.isAnonymous == false) {
      final homeCallCubit = BlocProvider.of<CallHandlerCubit>(Get.context!);
      homeCallCubit.listenToInComingCalls(Get.context!, currentUserID: currentUser!.uid);

      final relationsCubit = BlocProvider.of<RelationsCubit>(Get.context!);
      relationsCubit.loadRelations(userID: currentUser!.uid);

      final userSwapItems = BlocProvider.of<UserSwapItemsBloc>(Get.context!);
      userSwapItems.add(LoadUserSwapItemsEvent(userID: currentUser!.uid));

      final businessCubit = BlocProvider.of<BusinessCubit>(Get.context!);
      businessCubit.countryCode ??= currentUser!.country;

      final discoverCubit = BlocProvider.of<DiscoverCubit>(Get.context!);
      discoverCubit.refreshSearchRef();
    }
  }
}
