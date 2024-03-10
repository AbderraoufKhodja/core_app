import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class OutgoingVideoCall extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String recipientPhoto;
  final String channelId;

  const OutgoingVideoCall(
      {super.key,
      required this.recipientId,
      required this.recipientName,
      required this.channelId,
      required this.recipientPhoto});

  @override
  OutgoingVideoCallState createState() => OutgoingVideoCallState();
}

class OutgoingVideoCallState extends State<OutgoingVideoCall> {
  Timer? _timerInstance;
  int _start = 0;
  String _timer = '';

  void startTimer() {
    var oneSec = const Duration(seconds: 1);
    _timerInstance = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 0) {
                _timerInstance?.cancel();
              } else {
                _start = _start + 1;
                _timer = getTimerTime(_start);
              }
            }));
  }

  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0$minutes';
    } else {
      sMinute = minutes.toString();
    }

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0$seconds';
    } else {
      sSeconds = seconds.toString();
    }

    return '$sMinute:$sSeconds';
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    //  Ringtone.play();
  }

  @override
  void dispose() {
    super.dispose();
    _timerInstance?.cancel();
    FlutterRingtonePlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff172630),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xff172630),
          ),
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              const Text(
                'Outgoing Video Call',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                widget.recipientName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.25,
                //  backgroundImage:

                child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                    // fit: BoxFit.cover,
                    fadeInCurve: Curves.easeInOutCirc,
                    fadeInDuration: const Duration(seconds: 2),
                    fadeOutCurve: Curves.easeInOutCirc,
                    fadeOutDuration: const Duration(seconds: 2),
                    imageUrl: widget.recipientPhoto,
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) => const Icon(Icons.person),
                    errorWidget: (context, url, error) => Image.asset(
                          "assets/profilephoto.png",
                          fit: BoxFit.cover,
                        )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              FloatingActionButton(
                onPressed: () {
                  //TODO: set call status to over

                  FlutterRingtonePlayer.stop();
                  // Navigator.pop(context);
                },
                elevation: 50.0,
                shape: const CircleBorder(side: BorderSide(color: Colors.red)),
                mini: false,
                backgroundColor: Colors.red[100],
                child: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final title;
  final icon;
  final color;
  final Function() onPressed;

  const FunctionalButton({
    Key? key,
    this.title,
    this.color,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Colors.red,
          fillColor: Colors.white,
          elevation: 10.0,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              widget.icon,
              size: 30.0,
              color: widget.color,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        )
      ],
    );
  }
}

Future<void> showOutgoingCallPage(
  BuildContext context, {
  required String recipientId,
  required String recipientName,
  required String recipientPhoto,
  required String channelId,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: const [
          // BlocProvider(create: (context) => CallingBloc()),
        ],
        child: OutgoingVideoCall(
          recipientId: '',
          recipientName: '',
          recipientPhoto: '',
          channelId: channelId,
        ),
      ),
    ),
  );
}
