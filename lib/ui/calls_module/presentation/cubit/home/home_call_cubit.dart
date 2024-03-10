import 'dart:convert';

import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/ui/calls_module/data/api/call_api.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_call_state.dart';

enum HomeCallTypes { users, history }

class CallHandlerCubit extends Cubit<HomeCallState> {
  CallHandlerCubit() : super(HomeInitial());

  static CallHandlerCubit get(context) => BlocProvider.of(context);

  List<AppUser> users = [];
  List<Chat> calls = [];
  final _callApi = CallApi();
  bool fireCallLoading = false;

  Future<void> fireVideoCall(
    BuildContext context, {
    required Chat chat,
  }) async {
    retrievePermissions(
      onPermissionGranted: () {
        EasyLoading.show(dismissOnTap: true);
        fireCallLoading = true;
        emit(LoadingFireVideoCallState());
        //1-generate call token
        Map<String, dynamic> queryMap = {
          'channelName': 'channel_${UniqueKey().hashCode.toString()}',
          'uid': 0,
        };

        _callApi.generateCallToken(queryMap: queryMap).then((value) {
          chat.token = value['data']['token'];
          chat.channelName = value['data']['channelId'];

          //2-post call in Firebase
          postCallToFirestore(chat: chat);
        }).catchError((onError) {
          EasyLoading.showError('');
          debugPrint(onError);

          fireCallLoading = false;
          //For test
          // callModel.token = agoraTestToken;
          // callModel.channelName = agoraTestChannelName;
          // postCallToFirestore(callModel: callModel);
          emit(ErrorFireVideoCallState(onError.toString()));
        });
      },
    );
  }

  postCallToFirestore({required Chat chat}) {
    _callApi.postCallToFirestore(chat: chat).then((value) {
      //3-update user busy status in Firebase
      _callApi.updateUserBusyStatusFirestore(chat: chat, busyCalling: true).then((value) {
        fireCallLoading = false;
        // sendNotificationForIncomingCall(chat: chat);
        emit(SuccessFireVideoCallState(chat: chat));
      }).catchError((onError) {
        EasyLoading.showError('');

        fireCallLoading = false;
        emit(ErrorUpdateUserBusyStatus(onError.toString()));
      });
    }).catchError((onError) {
      EasyLoading.showError('');

      fireCallLoading = false;
      debugPrint(onError);
      emit(ErrorPostCallToFirestoreState(onError.toString()));
    });
  }

  sendNotificationForIncomingCall({required Chat chat}) {
    FirebaseFunctions.instance.httpsCallable('sendTranslatorNotificationCall').call({
      'userID': chat.receiverID,
      'body': jsonEncode(chat.toCloudFunctions()),
    }).then(
      (value) {
        debugPrint('SendNotifySuccess ${value.data.toString()}');
        emit(SuccessFireVideoCallState(chat: chat));
      },
    ).onError(
      (error, stackTrace) {
        EasyLoading.showError('');
        debugPrint('Error when send Notify: $onError');
        fireCallLoading = false;
        emit(ErrorSendNotification(onError.toString()));
      },
    );
  }
  // Chat inComingCall;

  CallStatus? currentCallStatus;
  LiveEventStatus? currentLiveStatus;

  void listenToInComingCalls(BuildContext context, {required String currentUserID}) {
    _callApi.listenToInComingCall(currentUserID: currentUserID).onData(
      (data) {
        if (data.size != 0) {
          for (var element in data.docs) {
            if (element.data().current == true) {
              retrievePermissions(
                onPermissionGranted: () {
                  final status = element.data().lastMessage?[MessageLabels.status.name];
                  if (status == CallStatus.ringing.name) {
                    currentCallStatus = CallStatus.ringing;
                    debugPrint('ringingStatus');
                    emit(SuccessInComingCallState(chat: element.data()));
                  }
                },
              );
            }
          }
        }
      },
    );
  }

  static Future<void> retrievePermissions({
    required Function() onPermissionGranted,
  }) async {
    late PermissionStatus status;

    // retrieve permissions
    final permissions = [
      await Permission.camera.isPermanentlyDenied,
      await Permission.microphone.isPermanentlyDenied,
    ].any((result) => result == true);

    if (permissions) {
      status = PermissionStatus.denied;
      return Get.dialog(
        AlertDialog(
          //GetX dialog is used, you may use default other dialog based on your requirement
          title: Text(
            RCCubit.instance.getText(R.needCameraMicrophonePermission),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          content: Text(
            RCCubit.instance.getText(R.pleaseGrantCameraMicrophonePermission),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () async => {
                  await openAppSettings(), //function in permission_handler
                  Get.back() //close dialog
                },
                child: Text(RCCubit.instance.getText(R.grantPermission)),
              ),
            ),
          ],
        ),
      );
    }

    return [Permission.microphone, Permission.camera].request().then(
      (results) async {
        if (results[Permission.camera] != PermissionStatus.granted) {
          return Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.cameraPermissionDenied),
              message: RCCubit.instance.getText(R.pleaseGrantCameraPermission),
            ),
          );
        }

        if (results[Permission.microphone] != PermissionStatus.granted) {
          return Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.microphonePermissionDenied),
              message: RCCubit.instance.getText(R.pleaseGrantMicrophonePermission),
            ),
          );
        }

        return await onPermissionGranted.call();
      },
    ).onError(
      (error, stackTrace) {
        return Get.showSnackbar(
          GetSnackBar(
            title: RCCubit.instance.getText(R.needCameraMicrophonePermission),
            message: RCCubit.instance.getText(R.pleaseGrantCameraMicrophonePermission),
          ),
        );
      },
    );
  }
}
