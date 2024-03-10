import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/authentication/auth_event.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/otp_timer.dart';
import 'package:fibali/ui/widgets/app_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  PhoneNumber? _phoneNumber;
  final _timerCubit = TimerCubit(TimerInit());

  AuthBloc get _authBloc => BlocProvider.of<AuthBloc>(context);

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _timerCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(Get.width / 6),
                      child: FittedBox(
                        child: AppLogo(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                // AnimatedLogInBackground(),
                FlutterLogin(
                  // title: 'Fibali',
                  // logo: 'assets/launcher_icon.png',
                  initPhoneNumber: PhoneNumber(
                    dialCode: _settingsCubit.state.dialCode,
                    isoCode: _settingsCubit.state.isoCode,
                  ),
                  messages: LoginMessages(
                    confirmPasswordHint: RCCubit.instance.getText(R.fillOTP),
                    userHint: RCCubit.instance.getText(R.phoneNumber),
                    passwordHint: '',
                    loginButton: RCCubit.instance.getText(R.logIn),
                  ),
                  scrollable: true,
                  phoneNumberPicker: null,
                  onInputChanged: (phoneNumber) {
                    debugPrint(phoneNumber.toString());
                    if (phoneNumber.dialCode != null) {
                      _settingsCubit.setDialCode(value: phoneNumber.dialCode!);
                      _settingsCubit.setIsoCode(value: phoneNumber.isoCode!);
                    }
                    _phoneNumber = phoneNumber;
                  },
                  sendOTPWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          thickness: 2,
                          width: 0,
                        ),
                      ),
                      OtpTimerButton(
                        duration: 60,
                        text: RCCubit.instance.getText(R.sendSms),
                        buttonType: ButtonType.text,
                        onPressed: () {
                          debugPrint(_phoneNumber?.phoneNumber);

                          if (_phoneNumber?.phoneNumber
                                  ?.split(_phoneNumber?.dialCode ?? '')[1]
                                  .isNotEmpty ==
                              true) {
                            _authBloc
                                .handleVerifyPhoneNumber(
                              context,
                              phoneNumber: _phoneNumber!.phoneNumber!,
                            )
                                .then((value) {
                              _settingsCubit.setPhoneNumber(value: _phoneNumber!.phoneNumber!);
                            });
                          } else {
                            Get.showSnackbar(
                              GetSnackBar(
                                title: RCCubit.instance.getText(R.missingPhoneNumber),
                                message: RCCubit.instance.getText(R.pleaseAddPhoneNumber),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  hideForgotPasswordButton: true,
                  userType: LoginUserType.phone,
                  theme: LoginTheme(
                    pageColorLight: Colors.transparent,
                    pageColorDark: Colors.black,
                    primaryColor: Theme.of(context).primaryColor,
                    accentColor: Colors.transparent,
                    inputTheme: const InputDecorationTheme(filled: true),
                    cardTheme: !Get.isDarkMode
                        ? const CardTheme(color: Colors.white70)
                        : CardTheme(color: Get.theme.cardColor),
                  ),
                  userValidator: (value) => value?.isEmpty == true
                      ? RCCubit.instance.getText(R.invalidPhoneNumber)
                      : null,
                  onLogin: (loginData) async {
                    try {
                      if (kIsWeb) {
                        await _authBloc.loginWithPhoneNumber(
                          phoneNumber: loginData.name,
                          smsCode: loginData.password,
                          verificationId: null,
                        );
                        return null;
                      }
                      if (_authBloc.verifID != null) {
                        await _authBloc.loginWithPhoneNumber(
                          phoneNumber: loginData.name,
                          smsCode: loginData.password,
                          verificationId: _authBloc.verifID!,
                        );
                        return null;
                      }
                    } catch (error) {
                      return error.toString();
                    }

                    return "Login Failed";
                  },
                  loginProviders: <LoginProvider>[
                    if (GetPlatform.isIOS)
                      LoginProvider(
                        icon: FontAwesomeIcons.apple,
                        callback: () async {
                          try {
                            await _authBloc.signInWithApple();
                            return null;
                          } catch (error) {
                            debugPrint(error.toString());
                            return error.toString();
                          }
                        },
                      )
                    else
                      LoginProvider(
                        icon: FontAwesomeIcons.google,
                        callback: () async {
                          try {
                            await _authBloc.loginWithGooglePressed();
                            return null;
                          } catch (error) {
                            debugPrint(error.toString());
                            return error.toString();
                          }
                        },
                      ),
                    if (GetPlatform.isIOS && kDebugMode)
                      LoginProvider(
                        icon: FontAwesomeIcons.google,
                        callback: () async {
                          try {
                            await _authBloc.loginWithGooglePressed();
                            return null;
                          } catch (error) {
                            debugPrint(error.toString());
                            return error.toString();
                          }
                        },
                      ),
                    // LoginProvider(
                    //   icon: FontAwesomeIcons.arrowRight,
                    //   label: RCCubit.instance.getText(R.skip),
                    //   callback: () async {
                    //     try {
                    //       await _authBloc.loggingAnonymously();
                    //       return null;
                    //     } catch (error) {
                    //       debugPrint(error.toString());
                    //       return error.toString();
                    //     }
                    //   },
                    // ),
                  ],
                  onRecoverPassword: (phoneNumber) {
                    if (phoneNumber.isNotEmpty) {
                      _authBloc.handleVerifyPhoneNumber(
                        context,
                        phoneNumber: phoneNumber,
                      );
                    }
                    return null;
                  },
                  onSubmitAnimationCompleted: () {
                    _authBloc.add(LoggedInEvent());
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        EasyLoading.show();
                        try {
                          await _authBloc.loggingAnonymously();
                          _authBloc.add(LoggedInEvent());
                        } catch (e) {
                          debugPrint(e.toString());
                          EasyLoading.showError(RCCubit.instance.getText(R.failed));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(RCCubit.instance.getText(R.skipLogging)),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
