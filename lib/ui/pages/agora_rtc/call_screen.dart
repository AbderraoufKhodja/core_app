// import 'package:fibali/fibali_core/models/video_session.dart';
// import 'package:fibali/settings.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wakelock/wakelock.dart';

// class CallScreen extends StatefulWidget {
//   /// non-modifiable channel name of the page
//   final String channelName;
//   final String callerId;
//   final String receiverId;

//   /// Creates a call page with given channel name.
//   const CallScreen(
//       {Key? key, required this.callerId, required this.receiverId, required this.channelName})
//       : super(key: key);

//   @override
//   _CallScreenState createState() {
//     return new _CallScreenState();
//   }
// }

// class _CallScreenState extends State<CallScreen> {
//   static final _sessions = <VideoSession>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   String username = " Muli";
//   late RtcEngine _engine;

//   updateChatroomNumber(number) {
//     return FirebaseFirestore.instance.collection("videocon").doc().set({
//       widget.channelName: {"number": number}
//     });
//   }

//   updateDestroyChatRoom() {
//     return FirebaseFirestore.instance.collection("videocon").doc().delete();
//   }

//   @override
//   void dispose() async {
//     _sessions.clear();
//     await _engine.leaveChannel();
//     await _engine.destroy();

//     super.dispose();
//   }

//   @override
//   void initState() {
//     Wakelock.enable();
//     super.initState();
//     // initialize agora sdk
//     _initialize();
//   }

//   void _initialize() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add("APP_ID missing, please provide your APP_ID in settings.dart");
//         _infoStrings.add("Video Engine is not starting");
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     // use _addRenderView everytime a native video view is needed
//     _addRenderView(0, (viewId) async {
//       if (defaultTargetPlatform == TargetPlatform.android) {
//         await [Permission.microphone, Permission.camera].request();
//       }
//       _engine.startPreview();
//       // state can access widget directly
//       await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//       await _engine.setClientRole(ClientRole.Broadcaster);
//       await _engine.joinChannel(null, widget.channelName, null, 0);
//     });
//   }

//   /// Create agora sdk instance and initialze
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(APP_ID);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(
//       error: (dynamic code) {
//         setState(() {
//           final info = 'onError: ' + code.toString();
//           _infoStrings.add(info);
//         });
//       },
//       joinChannelSuccess: (String channel, int uid, int elapsed) {
//         setState(() {
//           final info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
//           _infoStrings.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           _infoStrings.add('onLeaveChannel');
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           final info = 'userJoined: ' + uid.toString();
//           _infoStrings.add(info);
//           _addRenderView(uid, (viewId) {
//             _engine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
//           });
//         });
//       },
//       userOffline: (uid, reason) {
//         FirebaseFirestore.instance.collection("calls").doc(widget.callerId).delete().then((r) {
//           FirebaseFirestore.instance.collection("calls").doc(widget.receiverId).delete();
//         });
//         setState(() {
//           final info = 'userOffline: ' + uid.toString();
//           _infoStrings.add(info);
//           _removeRenderView(uid);
//         });
//       },
//       firstRemoteVideoFrame: (int uid, int width, int height, int elapsed) {
//         setState(() {
//           final info = 'firstRemoteVideo: ' +
//               uid.toString() +
//               ' ' +
//               width.toString() +
//               'x' +
//               height.toString();
//           _infoStrings.add(info);
//         });
//       },
//     ));
//   }

//   /// Create a native view and add a new video session object
//   /// The native viewId can be used to set up local/remote view
//   void _addRenderView(int uid, Function(int viewId) finished) {
//     final view = _engine.createNativeView((viewId) {
//       setState(() {
//         _getVideoSession(uid).viewId = viewId;
//         if (finished != null) {
//           finished(viewId);
//         }
//       });
//     });
//     VideoSession session = VideoSession(uid: uid, view: view);
//     _sessions.add(session);
//   }

//   /// Remove a native view and remove an existing video session object
//   void _removeRenderView(int uid) {
//     VideoSession session = _getVideoSession(uid);
//     if (session != null) {
//       _sessions.remove(session);
//     }
//     _engine.removeNativeView(session.viewId);
//   }

//   /// Helper function to filter video session with uid
//   VideoSession _getVideoSession(int uid) {
//     return _sessions.firstWhere((session) {
//       return session.uid == uid;
//     });
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     return _sessions.map((session) => session.view).toList();
//   }

//   /// Video view wrapper
//   Widget _videoView(
//     view,
//   ) {
//     return Expanded(child: Container(child: view));
//   }

//   Widget _tvideoView(view, view2) {
//     return Expanded(
//         child: Container(
//             child: Stack(
//       children: <Widget>[
//         view,
//         Positioned(
//             right: MediaQuery.of(context).size.width * 0.05,
//             bottom: MediaQuery.of(context).size.height * 0.12,
//             child: Row(
//               children: <Widget>[
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                     ),
//                     height: MediaQuery.of(context).size.width * 0.5,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: Card(
//                       child: view2,
//                       clipBehavior: Clip.hardEdge,
//                     )

//                     //color: Colors.red,
//                     )
//               ],
//             ))
//       ],
//     )));
//   }

//   Widget _tvideoView2(view, view2, view3) {
//     return Expanded(
//         child: Container(
//             child: Stack(
//       children: <Widget>[
//         view,
//         Positioned(
//             right: MediaQuery.of(context).size.width * 0.05,
//             bottom: MediaQuery.of(context).size.height * 0.12,
//             child: Row(
//               children: <Widget>[
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                     ),
//                     height: MediaQuery.of(context).size.width * 0.5,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: Card(
//                       child: view2,
//                       clipBehavior: Clip.hardEdge,
//                     )

//                     //color: Colors.red,
//                     ),
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                     ),
//                     height: MediaQuery.of(context).size.width * 0.5,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: Card(
//                       child: view3,
//                       clipBehavior: Clip.hardEdge,
//                     )

//                     //color: Colors.red,
//                     )
//               ],
//             ))
//       ],
//     )));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     List<Widget> wrappedViews = views
//         .map((Widget view) => _videoView(
//               view,
//             ))
//         .toList();
//     return Expanded(child: Row(children: wrappedViews));
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     List<Widget> views = _getRenderViews();
//     debugPrint(views);
//     debugPrint(views.length);

//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             // _tviews(views[0])]

//             _videoView(views[0])
//           ],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[_tvideoView(views[1], views[0])],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _tvideoView(
//               //view[0]
//               views[2], //index 1 is mine
//               views[1], //index 2 callers
//             )
//           ],
//         ));
//       case 4:
//         updateChatroomNumber(4);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       case 5:
//         updateChatroomNumber(5);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 5))
//           ],
//         ));
//       case 6:
//         updateChatroomNumber(6);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 6))
//           ],
//         ));
//       case 7:
//         updateChatroomNumber(7);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 7))
//           ],
//         ));
//       case 8:
//         updateChatroomNumber(8);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 8))
//           ],
//         ));
//       case 9:
//         updateChatroomNumber(9);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 9))
//           ],
//         ));
//       case 10:
//         updateChatroomNumber(10);
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 10))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: () => _onToggleMute(),
//             child: new Icon(
//               muted ? Icons.mic : Icons.mic_off,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               FirebaseFirestore.instance
//                   .collection("calls")
//                   .doc(widget.callerId)
//                   .delete()
//                   .then((r) {
//                 FirebaseFirestore.instance.collection("calls").doc(widget.receiverId).delete();
//               }).then((r) {
//                 Navigator.pop(context);
//               });
//             },
//             child: new Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onSwitchCamera(),
//             child: new Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//         padding: EdgeInsets.symmetric(vertical: 48),
//         alignment: Alignment.bottomCenter,
//         child: FractionallySizedBox(
//           heightFactor: 0.5,
//           child: Container(
//               padding: EdgeInsets.symmetric(vertical: 48),
//               child: ListView.builder(
//                   reverse: true,
//                   itemCount: _infoStrings.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (_infoStrings.length == 0) {
//                       return SizedBox();
//                     }
//                     return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: [
//                           Flexible(
//                               child: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                                   decoration: BoxDecoration(
//                                       //color: Colors.yellowAccent,
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: Text(_infoStrings[index],
//                                       style: TextStyle(color: Colors.blueGrey))))
//                         ]));
//                   })),
//         ));
//   }

//   void _onCallEnd(BuildContext context) {
//     dispose();
//     Navigator.pop(context);
//     //dispose();
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   title: Text('Conference Room'),
//         // ),
//         backgroundColor: Colors.black,
//         body: Center(
//             child: Stack(
//           children: <Widget>[_viewRows(), /* _panel(),*/ _toolbar()],
//         )));
//   }
// }
