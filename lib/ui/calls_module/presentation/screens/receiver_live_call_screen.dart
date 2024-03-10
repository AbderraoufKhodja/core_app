import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/live/live_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/live/live_state.dart';
import 'package:fibali/ui/calls_module/shared/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiverLiveScreen extends StatefulWidget {
  final Post post;
  const ReceiverLiveScreen({super.key, required this.post});

  static Future<dynamic>? show({
    required Post post,
  }) async {
    return Get.to(() => BlocProvider(
          create: (context) => LiveCubit(),
          child: ReceiverLiveScreen(post: post),
        ));
  }

  @override
  State<ReceiverLiveScreen> createState() => _ReceiverLiveScreenState();
}

class _ReceiverLiveScreenState extends State<ReceiverLiveScreen> {
  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  late final _liveCubit = LiveCubit.get(context);

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentLiveID", widget.post.postID!));
    _liveCubit.listenToCallStatus(
      context: context,
      post: widget.post,
      isReceiver: true,
    );

    // _liveCubit.playContactingRing(isCaller: false);

    _liveCubit.initAgoraAndJoinChannel(
      channelToken: widget.post.token!,
      channelName: widget.post.channelName!,
      isEmitter: false,
    );
  }

  Future<void> _dispose() async {
    await _liveCubit.engine?.leaveChannel();
    await _liveCubit.engine?.release();
  }

  @override
  void dispose() {
    _dispose();
    _liveCubit.player.dispose();

    SharedPreferences.getInstance().then((prefs) => prefs.remove("currentLiveID"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (BuildContext _, Object? state) {
        if (state is LiveScheduledState) {
          showToast(msg: 'Live is scheduled');
        }

        if (state is LiveStartingState) {
          showToast(msg: 'Live is starting');
        }

        if (state is LiveOnGoingState) {
          showToast(msg: 'Live is on going');
        }

        if (state is LiveCanceledState) {
          showToast(msg: 'Live has been canceled');
        }

        if (state is LiveEndedState) {
          showToast(msg: 'Live has been ended!');
        }
      },
      builder: (BuildContext context, state) {
        return SizedBox(
          height: Get.height,
          child: Center(
            child: _remoteVideo(),
          ),
        );
      },
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_liveCubit.remoteUid != null && widget.post.channelName != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _liveCubit.engine!,
          canvas: VideoCanvas(uid: _liveCubit.remoteUid!),
          connection: RtcConnection(channelId: widget.post.channelName!),
        ),
      );
    } else {
      return const Text(
        'Please wait for the host to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
