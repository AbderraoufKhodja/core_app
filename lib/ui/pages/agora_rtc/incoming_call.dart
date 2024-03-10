import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';

class IncomingCallPage extends StatefulWidget {
  final String callId;
  final String receiverId;
  final String callerId;
  final String callerName;
  final String callerPhoto;
  final String channelName;

  const IncomingCallPage(
      {super.key,
      required this.callerId,
      required this.callerName,
      required this.channelName,
      required this.callId,
      required this.receiverId,
      required this.callerPhoto});

  @override
  IncomingCallPageState createState() => IncomingCallPageState();
}

class IncomingCallPageState extends State<IncomingCallPage> {
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
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterRingtonePlayer.stop();
  }

  handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
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
                'Incoming Video Call',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                widget.callerName,
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
                  imageUrl: widget.callerPhoto,
                  useOldImageOnUrlChange: true,
                  placeholder: (context, url) => const Icon(Icons.person),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/profilephoto.ong",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FunctionalButton(
                    title: 'Receive',
                    color: Colors.green,
                    icon: Icons.videocam,
                    onPressed: () {
                      FlutterRingtonePlayer.stop();
                      FirebaseFirestore.instance
                          .collection("calls")
                          .doc(widget.callerId)
                          .update({"received_by_recepient": true}).then(
                        (r) {
                          handleCameraAndMic();
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => JoinChannelVideo(

                          //       token: ,
                          //       channelId: widget.channelName,
                          //     ),
                          //   ),
                          // );
                        },
                      );

                      ///place instance to callers db
                      // FirebaseFirestore.instance
                      //     .collection("calls")
                      //     .doc(widget.callerid)
                      //     .collection(widget.receiverid)
                      //     .doc(widget.callid)
                      //     .update({
                      //   "received_by_recepient": true,
                      // } //)
                      //         ).then((r) {
                      //   FirebaseFirestore.instance
                      //       .collection("calls")
                      //       .doc(widget.receiverid)
                      //       .collection(widget.callerid)
                      //       .doc(widget.callid)
                      //       .update(
                      //     {"received_by_recepient": true},
                      //   ).then((r) async {
                      //     // update input validation

                      //     // await for camera and mic permissions before pushing video page
                      //     //await _handleCameraAndMic();
                      //     // push video page with given channel name
                      //     Navigator.push(
                      //         context,
                      //         CupertinoPageRoute(
                      //             builder: (context) => new CallPage(
                      //                   channelName: widget.channelName,
                      //                 )));
                      //   });
                      // });
                    },
                  ),
                  FunctionalButton(
                    title: 'End',
                    color: Colors.red,
                    icon: Icons.videocam_off,
                    onPressed: () {
                      ///place instance to callers db
                      FirebaseFirestore.instance
                          .collection("calls")
                          .doc(widget.receiverId)
                          .delete();
                      FirebaseFirestore.instance
                          .collection("calls")
                          .doc(widget.callerId)
                          .delete();

                      FlutterRingtonePlayer.stop();
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // FloatingActionButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   elevation: 50.0,
              //   shape: CircleBorder(side: BorderSide(color: Colors.red)),
              //   mini: false,
              //   child: Icon(
              //     Icons.call_end,
              //     color: Colors.red,
              //   ),
              //   backgroundColor: Colors.red[100],
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              // Text(
              //   "Waiting Time : ${_timmer}",
              //   style: TextStyle(
              //       color: Colors.red,
              //       fontWeight: FontWeight.w300,
              //       fontSize: 15),
              // ),
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
