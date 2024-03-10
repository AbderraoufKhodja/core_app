// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Call {
//   String generateChannelId() {
//     return Random().nextInt(1000).toString();
//   }

//   placeVideoCall() {
//     final channelId = generateChannelId();

//     ///place instance to callers db
//     FirebaseFirestore.instance.collection("calls").doc().set({
//       "callerId": null,
//       "callerDeleteId": widget.senderId,
//       "callerName": widget.senderName,
//       "callerImage": widget.senderImage,
//       "isCaller": true, // used to identify who s placing the call
//       "callingChannel": channelId,
//       "receiverId": widget.receiverId,
//       "receiverName": widget.receverName,
//       "receiverImage": widget.receiverImage,
//       "received_by_recepient": false, //used to determine if the receiver picked the call
//       "outgoing": true, //haitumiki sawa ..to show he made the call
//       "time": DateTime.now().millisecondsSinceEpoch.toString(),
//     }).then((r) {
//       FirebaseFirestore.instance.collection("calls").doc(widget.receiverId).set({
//         "callerId": widget.senderId,
//         "callerDeleteId": widget.senderId,
//         "callerName": widget.senderName,
//         "callerImage": widget.senderImage,
//         "isCaller": false,
//         "callingChannel": channelId,
//         "receiverId": widget.receiverId,
//         "receiverName": widget.receverName,
//         "receiverImage": widget.receiverImage,
//         "received_by_recepient": false, //kwa receiver this haitumiki
//         "incoming": true,
//         "time": DateTime.now().millisecondsSinceEpoch.toString(),
//       }).then((r) {});
//     });
//   }
// }
