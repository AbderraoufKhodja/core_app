import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/live/live_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/live/live_state.dart';
import 'package:fibali/ui/calls_module/presentation/widgets/call_widgets/default_circle_image.dart';
import 'package:fibali/ui/calls_module/shared/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmitterLiveScreen extends StatefulWidget {
  final Post post;
  const EmitterLiveScreen({super.key, required this.post});

  static Future<dynamic>? show({
    required Post post,
  }) async {
    return Get.to(
      () => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<CallHandlerCubit>(Get.context!)),
          BlocProvider.value(value: BlocProvider.of<TranslatorDashboardCubit>(Get.context!)),
          BlocProvider(create: (context) => LiveCubit()),
        ],
        child: EmitterLiveScreen(post: post),
      ),
    );
  }

  @override
  State<EmitterLiveScreen> createState() => _EmitterLiveScreenState();
}

class _EmitterLiveScreenState extends State<EmitterLiveScreen> {
  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  late LiveCubit _liveCubit;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentLiveID", widget.post.postID!));
    _liveCubit = LiveCubit.get(context);

    _liveCubit.updateCallStatusToStarting(
      post: widget.post,
      currentUser: currentUser,
    );

    _liveCubit.listenToCallStatus(
      context: context,
      post: widget.post,
      isReceiver: false,
    );

    // Emitter
    _liveCubit.initAgoraAndJoinChannel(
      channelToken: widget.post.token!,
      channelName: widget.post.channelName!,
      isEmitter: true,
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

    _liveCubit.performEndLive(post: widget.post);
    SharedPreferences.getInstance().then((prefs) => prefs.remove("currentLiveID"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (BuildContext _, Object? state) {
        if (state is AgoraInitForEmitterSuccessState) {
          _liveCubit.updateCallStatusToOnGoing(
            post: widget.post,
            currentUser: currentUser,
          );
        }

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
          Get.back();
        }

        if (state is LiveEndedState) {
          showToast(msg: 'Live has been ended!');
          Get.back();
        }
      },
      builder: (BuildContext context, state) {
        final cubit = LiveCubit.get(context);
        debugPrint('the state$state${cubit.remoteUid}');

        return ModalProgressHUD(
          inAsyncCall: false,
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const PopButton(),
              ),
              extendBodyBehindAppBar: true,
              body: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Center(child: buildLocalView()),
                  Padding(
                    padding: const EdgeInsets.all(15.0).copyWith(top: kBottomNavigationBarHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50.0),
                        // UserInfoHeader(
                        //   //Caller -> Show Receiver INFO
                        //   avatar: widget.post.receiverPhoto,
                        //   name: widget.post.receiverName,
                        // ),
                        // const SizedBox(height: 30.0),
                        cubit.remoteUid == null
                            ? const Expanded(
                                child: Text(
                                  'Waiting for user to joint the your live ...',
                                  style: TextStyle(fontSize: 39.0),
                                ),
                              )
                            : Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  cubit.switchCamera();
                                },
                                child: const DefaultCircleImage(
                                  bgColor: Colors.white,
                                  image: Icon(
                                    Icons.switch_camera_outlined,
                                    color: Colors.black,
                                  ),
                                  center: true,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  cubit.toggleMuted();
                                },
                                child: DefaultCircleImage(
                                  bgColor: Colors.white,
                                  image: cubit.muteIcon,
                                  center: true,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AgoraVideoView buildLocalView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _liveCubit.engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }
}
