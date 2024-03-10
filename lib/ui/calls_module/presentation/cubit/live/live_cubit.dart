import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/calls_module/data/api/live_api.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/fibali_core/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  LiveCubit() : super(LiveInitial());

  static LiveCubit get(context) => BlocProvider.of(context);

  //Update Call Status
  final _liveApi = LiveApi();

  //Agora video room
  int? remoteUid;
  RtcEngine? engine;
  StreamSubscription<DocumentSnapshot<Post>>? liveStatusStreamSubscription;

  Future<void> initAgoraAndJoinChannel({
    required String channelToken,
    required String channelName,
    required bool isEmitter,
  }) async {
    //create the engine
    engine = createAgoraRtcEngine();
    await engine!.initialize(const RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await engine!.enableVideo();

    if (isEmitter) {
      await engine!.startPreview();
    }

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int rmtUid, int elapsed) {
          debugPrint("remote user $rmtUid joined");
          remoteUid = rmtUid;
          emit(AgoraRemoteUserJoinedLive());
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
    final currentUserID = BlocProvider.of<AuthBloc>(Get.context!).currentUser!.uid;
    await engine!.joinChannel(
      token: channelToken,
      channelId: channelName,
      uid: Utils.convertToCodeUnitsWith8Char(value: currentUserID),
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );

    if (isEmitter) {
      emit(AgoraInitForEmitterSuccessState());
      playContactingRing(isCaller: true);
    } else {
      emit(AgoraInitForReceiverSuccessState());
    }

    debugPrint('channelToken is $channelToken channelName is $channelName');
  }

  //Sender
  final player = AudioPlayer();

  Future<void> playContactingRing({required bool isCaller}) async {
    if (Platform.isAndroid) {
      const audioAsset =
          "assets/sounds/ringlong.mp3"; // Note: No need to prefix with 'assets/' in AudioCache
      await player.play(AssetSource(audioAsset));
    }
  }

  int current = 0;

  bool muted = false;
  Widget muteIcon = const Icon(
    Icons.keyboard_voice_rounded,
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

  Future<void> updateCallStatusToCancel({required Post post}) async {
    await _liveApi.updateLiveStatus(
      post: post,
      status: LiveEventStatus.canceled.name,
    );
  }

  Future<void> updateCallStatusToStarting({required Post post, required currentUser}) async {
    await _liveApi.updateLiveStatus(
      post: post,
      status: LiveEventStatus.starting.name,
    );
  }

  Future<void> updateCallStatusToOnGoing({required Post post, required currentUser}) async {
    await _liveApi.updateLiveStatus(
      post: post,
      status: LiveEventStatus.onGoing.name,
    );
  }

  Future<void> updateLiveStatusToEnded({required Post call}) async {
    await _liveApi.updateLiveStatus(post: call, status: LiveEventStatus.ended.name);
  }

  Future<void> endCurrentLive({required Post post}) async {
    await _liveApi.endCurrentLive(post: post);
  }

  Future<void> updateUserBusyStatusFirestore({required Post post}) async {
    await _liveApi.updateUserBusyStatusFirestore(
      post: post,
      busyCalling: false,
    );
  }

  Future<void> performEndLive({required Post post}) async {
    await endCurrentLive(post: post);
    await updateUserBusyStatusFirestore(post: post);
  }

  void listenToCallStatus({
    required BuildContext context,
    required Post post,
    required bool isReceiver,
  }) {
    final homeCubit = CallHandlerCubit.get(context);
    liveStatusStreamSubscription = _liveApi.listenToLiveStatus(
      postID: post.postID!,
    );
    // scheduled, canceled, starting, onGoing, ended
    liveStatusStreamSubscription!.onData((data) {
      if (data.exists) {
        debugPrint("current status: ${data.data()?.lastLiveEvent?[LELabels.status.name]}");
        final String? status = data.data()?.lastLiveEvent?[LELabels.status.name];
        switch (Utils.enumFromString(LiveEventStatus.values, status)) {
          case LiveEventStatus.scheduled:
            homeCubit.currentLiveStatus = LiveEventStatus.scheduled;
            debugPrint('scheduledStatus');
            emit(LiveScheduledState());
            break;
          case LiveEventStatus.starting:
            homeCubit.currentLiveStatus = LiveEventStatus.scheduled;
            debugPrint('startingStatus');
            emit(LiveStartingState());
            break;
          case LiveEventStatus.canceled:
            homeCubit.currentLiveStatus = LiveEventStatus.canceled;
            debugPrint('canceledStatus');
            liveStatusStreamSubscription!.cancel();
            emit(LiveCanceledState());
            break;
          case LiveEventStatus.onGoing:
            homeCubit.currentLiveStatus = LiveEventStatus.onGoing;
            debugPrint('onGoingStatus');
            emit(LiveOnGoingState());
            break;
          case LiveEventStatus.ended:
            homeCubit.currentLiveStatus = LiveEventStatus.ended;
            debugPrint('endedStatus');
            liveStatusStreamSubscription!.cancel();
            emit(LiveEndedState());
            break;
          case null:
            // TODO: Handle this case.
            break;
        }
      }
    });
  }
}
