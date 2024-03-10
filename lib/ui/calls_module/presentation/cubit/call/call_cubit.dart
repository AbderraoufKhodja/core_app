import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fibali/ui/calls_module/data/api/call_api.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/settings.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/async.dart';

import 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  static CallCubit get(context) => BlocProvider.of(context);

  //Update Call Status
  final _callApi = CallApi();

  //Agora video room

  int? remoteUid;
  RtcEngine? engine;
  StreamSubscription? callStatusStreamSubscription;

  Future<void> initAgoraAndJoinChannel({
    required String channelToken,
    required String channelName,
    required bool isCaller,
  }) async {
    //create the engine
    engine = createAgoraRtcEngine();
    await engine!.initialize(const RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await engine!.enableVideo();
    await engine!.startPreview();

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int rmtUid, int elapsed) {
          debugPrint("remote user $rmtUid joined");

          remoteUid = rmtUid;
          emit(StopTimerAudioEvent());
          emit(AgoraRemoteUserJoinedCall());
        },
        onUserOffline: (RtcConnection connection, int rmtUid, UserOfflineReasonType reason) {
          debugPrint("remote user $rmtUid left channel");
          remoteUid = null;
          emit(AgoraUserLeftEvent());
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    //join channel
    await engine!.joinChannel(
      token: channelToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    if (isCaller) {
      emit(AgoraInitForSenderSuccessState());
      playContactingRing(isCaller: true);
    } else {
      emit(AgoraInitForReceiverSuccessState());
    }

    debugPrint('channelToken is $channelToken channelName is $channelName');
  }

  //Sender
  final player = AudioPlayer();

  Future<void> playContactingRing({required bool isCaller}) async {
    const audioAsset = "assets/sounds/ringlong.mp3";
    await player.play(AssetSource(audioAsset));
    if (isCaller) {
      startCountdownCallTimer();
    }
  }

  int current = 0;
  late CountdownTimer countDownTimer;
  void startCountdownCallTimer() {
    countDownTimer = CountdownTimer(
      const Duration(seconds: callDurationInSec),
      const Duration(seconds: 1),
    );
    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      current = callDurationInSec - duration.elapsed.inSeconds;
      debugPrint("DownCount: $current");
    });

    sub.onDone(() {
      debugPrint("CallTimeDone");
      sub.cancel();
      emit(DownCountCallTimerFinishState());
    });
  }

  bool muted = false;
  Widget muteIcon = const Icon(
    Icons.keyboard_voice_rounded,
    color: Colors.black,
  );
  Widget disableCamera = const Icon(
    Icons.camera,
    color: Colors.black,
  );

  Future<void> toggleMuted() async {
    muted = !muted;
    muteIcon = muted
        ? const Icon(
            Icons.mic_off_rounded,
            color: Colors.black,
          )
        : const Icon(
            Icons.keyboard_voice_rounded,
            color: Colors.black,
          );
    await engine!.muteLocalAudioStream(muted);
    emit(AgoraToggleMutedState());
  }

  Future<void> switchCamera() async {
    await engine!.switchCamera();
    emit(AgoraSwitchCameraState());
  }

  Future<void> disableVideo() async {
    await engine!.disableVideo();
    emit(AgoraDisableCameraState());
  }

  void updateCallStatusToUnAnswered({required Chat chat}) {
    emit(LoadingUnAnsweredVideoChatState());
    _callApi
        .updateCallStatus(
      chat: chat,
      status: CallStatus.unAnswer.name,
    )
        .then((value) {
      emit(SuccessUnAnsweredVideoChatState());
    }).catchError((onError) {
      emit(ErrorUnAnsweredVideoChatState(onError.toString()));
    });
  }

  Future<void> updateCallStatusToCancel({required Chat call}) async {
    await _callApi.updateCallStatus(
      chat: call,
      status: CallStatus.cancel.name,
    );
  }

  Future<void> updateCallStatusToReject({required Chat call}) async {
    await _callApi.updateCallStatus(
      chat: call,
      status: CallStatus.reject.name,
    );
  }

  Future<void> updateCallStatusToAccept({required Chat chat}) async {
    await _callApi.updateCallStatus(chat: chat, status: CallStatus.accept.name);
    initAgoraAndJoinChannel(
        channelToken: chat.token!, channelName: chat.channelName!, isCaller: false);
  }

  Future<void> updateCallStatusToEnd({required Chat call}) async {
    await _callApi.updateCallStatus(chat: call, status: CallStatus.end.name);
  }

  Future<void> endCurrentCall({required Chat call}) async {
    await _callApi.endCurrentCall(call: call);
  }

  Future<void> updateUserBusyStatusFirestore({required Chat chat}) async {
    await _callApi.updateUserBusyStatusFirestore(chat: chat, busyCalling: false);
  }

  Future<void> performEndCall({required Chat chat}) async {
    await endCurrentCall(call: chat);
    await updateUserBusyStatusFirestore(chat: chat);
  }

  void listenToCallStatus(
      {required BuildContext context, required Chat chat, required bool isReceiver}) {
    var homeCubit = CallHandlerCubit.get(context);
    callStatusStreamSubscription = _callApi.listenToCallStatus(chatID: chat.chatID!);
    callStatusStreamSubscription!.onData((data) {
      if (data.exists) {
        debugPrint(data.data().toString());
        final String status = data.data()![ChatLabels.lastMessage.name][MessageLabels.status.name];
        if (status == CallStatus.accept.name) {
          homeCubit.currentCallStatus = CallStatus.accept;
          debugPrint('acceptStatus');
          emit(CallAcceptState());
        }
        if (status == CallStatus.reject.name) {
          homeCubit.currentCallStatus = CallStatus.reject;
          debugPrint('rejectStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallRejectState());
        }
        if (status == CallStatus.unAnswer.name) {
          homeCubit.currentCallStatus = CallStatus.unAnswer;
          debugPrint('unAnswerStatusHere');
          callStatusStreamSubscription!.cancel();
          emit(CallNoAnswerState());
        }
        if (status == CallStatus.cancel.name) {
          homeCubit.currentCallStatus = CallStatus.cancel;
          debugPrint('cancelStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallCancelState());
        }
        if (status == CallStatus.end.name) {
          homeCubit.currentCallStatus = CallStatus.end;
          debugPrint('endStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallEndState());
        }
      }
    });
  }
}
