import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/call/call_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/shared_widgets.dart';
import '../cubit/call/call_state.dart';
import '../widgets/call_widgets/default_circle_image.dart';
import '../widgets/call_widgets/user_info_header.dart';

class CallScreen extends StatefulWidget {
  final bool isReceiver;
  final Chat chat;
  const CallScreen({super.key, required this.isReceiver, required this.chat});

  static Future<dynamic>? show({required Chat chat, required bool isReceiver}) {
    return Get.to(
      () => BlocProvider(
        create: (context) => CallCubit(),
        child: CallScreen(
          isReceiver: isReceiver,
          chat: chat,
        ),
      ),
    );
  }

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late CallCubit _callCubit;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentCallID", widget.chat.chatID!));
    _callCubit = CallCubit.get(context);
    _callCubit.listenToCallStatus(
        context: context, chat: widget.chat, isReceiver: widget.isReceiver);
    if (!widget.isReceiver) {
      //Caller
      _callCubit.initAgoraAndJoinChannel(
          channelToken: widget.chat.token!, channelName: widget.chat.channelName!, isCaller: true);
    } else {
      //Receiver
      _callCubit.playContactingRing(isCaller: !widget.isReceiver);
    }
  }

  Future<void> _dispose() async {
    await _callCubit.engine?.leaveChannel();
    await _callCubit.engine?.release();
  }

  @override
  void dispose() {
    _dispose();

    _callCubit.player.dispose();
    if (!widget.isReceiver) {
      //Sender
      _callCubit.countDownTimer.cancel();
    }
    _callCubit.performEndCall(chat: widget.chat);
    SharedPreferences.getInstance().then((prefs) => prefs.remove("currentCallID"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallCubit, CallState>(
      listener: (BuildContext _, Object? state) {
        if (state is ErrorUnAnsweredVideoChatState) {
          showToast(msg: 'UnExpected Error!: ${state.error}');
        }
        if (state is DownCountCallTimerFinishState) {
          if (_callCubit.remoteUid == null) {
            _callCubit.updateCallStatusToUnAnswered(chat: widget.chat);
          }
        }

        if (state is StopTimerAudioEvent) {
          //remote user join channel
          if (!widget.isReceiver) {
            //Caller
            _callCubit.countDownTimer.cancel();
          }
          _callCubit.player.stop(); //Sender, Receiver
        }

        //Call States
        if (state is CallNoAnswerState) {
          if (!widget.isReceiver) {
            //Caller
            showToast(msg: 'No response!');
          }
          Navigator.of(context).pop();
        }
        if (state is CallCancelState) {
          if (widget.isReceiver) {
            //Receiver
            showToast(msg: 'Caller cancel the call!');
          }
          Navigator.of(context).pop();
        }
        if (state is CallRejectState) {
          if (!widget.isReceiver) {
            //Caller
            showToast(msg: 'Receiver reject the call!');
          }
          if (mounted) Navigator.of(context).pop();
        }
        if (state is CallEndState) {
          showToast(msg: 'Call ended!');
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, state) {
        final cubit = CallCubit.get(context);
        debugPrint('the state$state${cubit.remoteUid}');

        return ModalProgressHUD(
          inAsyncCall: false,
          child: Scaffold(
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                cubit.remoteUid == null
                    ? !widget.isReceiver
                        ? Container(
                            color: const Color.fromARGB(255, 44, 49, 52), child: buildLocalView())
                        : PhotoWidgetNetwork(
                            label: Utils.getInitial(widget.chat.senderName),
                            photoUrl: widget.chat.senderPhoto ?? '',
                          )
                    : Stack(
                        children: [
                          Center(
                            child: _remoteVideo(),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 122,
                              height: 219.0,
                              child: Center(child: buildLocalView()),
                            ),
                          ),
                        ],
                      ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      !widget.isReceiver
                          ? UserInfoHeader(
                              //Caller -> Show Receiver INFO
                              avatar: widget.chat.receiverPhoto,
                              name: widget.chat.receiverName,
                            )
                          : UserInfoHeader(
                              //Receiver -> Show Caller INFO
                              avatar: widget.chat.senderPhoto,
                              name: widget.chat.senderName,
                            ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      cubit.remoteUid == null
                          ? Expanded(
                              child: widget.isReceiver
                                  ? Text(
                                      '${widget.chat.senderName} is calling you..',
                                      style: const TextStyle(color: Colors.white, fontSize: 39.0),
                                    )
                                  : const Text(
                                      'Contacting..',
                                      style: TextStyle(color: Colors.white, fontSize: 39.0),
                                    ),
                            )
                          : Expanded(child: Container()),
                      cubit.remoteUid == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.isReceiver
                                    ? Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            //receiverAcceptVideoChat
                                            _callCubit.updateCallStatusToAccept(chat: widget.chat);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text(
                                            'Acceptance',
                                            style: TextStyle(color: Colors.white, fontSize: 13.0),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.isReceiver
                                    ? const SizedBox(
                                        width: 15.0,
                                      )
                                    : Container(),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (widget.isReceiver) {
                                        //receiverRejectVideoChat
                                        EasyLoading.show(dismissOnTap: true);
                                        _callCubit
                                            .updateCallStatusToReject(call: widget.chat)
                                            .then((value) {
                                          EasyLoading.dismiss();
                                          if (mounted) Get.back();
                                        });
                                      } else {
                                        //callerCancelVideoChat
                                        EasyLoading.show(dismissOnTap: true);
                                        _callCubit
                                            .updateCallStatusToCancel(call: widget.chat)
                                            .then((value) {
                                          EasyLoading.dismiss();
                                          if (mounted) Get.back();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text(
                                      widget.isReceiver
                                          ? RCCubit.instance.getText(R.reject)
                                          : RCCubit.instance.getText(R.cancel),
                                      style: const TextStyle(color: Colors.white, fontSize: 13.0),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
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
                                        cubit.updateCallStatusToEnd(call: widget.chat);
                                      },
                                      child: const DefaultCircleImage(
                                        bgColor: Colors.red,
                                        image: Icon(
                                          Icons.call_end_rounded,
                                          color: Colors.white,
                                        ),
                                        center: true,
                                        width: 55,
                                        height: 55,
                                      )),
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
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      cubit.disableVideo();
                                    },
                                    child: DefaultCircleImage(
                                      bgColor: Colors.white,
                                      image: cubit.disableCamera,
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
        );
      },
    );
  }

  AgoraVideoView buildLocalView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _callCubit.engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_callCubit.remoteUid != null && widget.chat.channelName != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _callCubit.engine!,
          canvas: VideoCanvas(uid: _callCubit.remoteUid!),
          connection: RtcConnection(channelId: widget.chat.channelName!),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
