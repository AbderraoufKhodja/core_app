import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class CallModel {
  late String callID;
  String? appointmentID;
  String? token;
  String? type;
  String? callMethod;
  Map<String, dynamic>? lastCallEvent;
  String? channelName;
  String? callerId;
  String? callerName;
  String? callerPhotoUrl;
  String? receiverId;
  String? receiverName;
  String? receiverPhotoUrl;
  num? createAt;
  dynamic timestamp;
  dynamic lastEventTimestamp;
  bool? current;
  UserCallInfo? otherUser; //UI

  CallModel({
    required this.callID,
    required this.appointmentID,
    required this.token,
    required this.type,
    required this.callMethod,
    required this.lastCallEvent,
    required this.channelName,
    required this.callerId,
    required this.callerName,
    required this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.createAt,
    required this.timestamp,
    required this.lastEventTimestamp,
    required this.current,
    required this.otherUser,
  });

  static ref() => FirebaseFirestore.instance.collection('calls').withConverter<CallModel>(
        fromFirestore: (snapshot, options) => CallModel.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  CallModel.fromFirestore(Map<String, dynamic> json) {
    callID = getField(json, CallLabels.callID.name, String);
    appointmentID = getField(json, CallLabels.appointmentID.name, String);
    token = getField(json, CallLabels.token.name, String);
    type = getField(json, CallLabels.type.name, String);
    callMethod = getField(json, CallLabels.callMethod.name, String);
    lastCallEvent = getField(json, CallLabels.lastCallEvent.name, Map<String, dynamic>);
    channelName = getField(json, CallLabels.channelName.name, String);
    callerId = getField(json, CallLabels.callerId.name, String);
    callerName = getField(json, CallLabels.callerName.name, String);
    callerPhotoUrl = getField(json, CallLabels.callerPhotoUrl.name, String);
    receiverId = getField(json, CallLabels.receiverId.name, String);
    receiverName = getField(json, CallLabels.receiverName.name, String);
    receiverPhotoUrl = getField(json, CallLabels.receiverPhotoUrl.name, String);
    createAt = getField(json, CallLabels.createAt.name, num);
    timestamp = getField(json, CallLabels.timestamp.name, dynamic);
    lastEventTimestamp = getField(json, CallLabels.lastEventTimestamp.name, dynamic);

    current = getField(json, CallLabels.current.name, bool);
  }

  Map<String, dynamic> toFirestore() {
    return {
      CallLabels.callID.name: callID,
      CallLabels.appointmentID.name: appointmentID,
      CallLabels.token.name: token,
      CallLabels.type.name: type,
      CallLabels.callMethod.name: callMethod,
      CallLabels.lastCallEvent.name: lastCallEvent,
      CallLabels.channelName.name: channelName,
      CallLabels.callerId.name: callerId,
      CallLabels.callerName.name: callerName,
      CallLabels.callerPhotoUrl.name: callerPhotoUrl,
      CallLabels.receiverId.name: receiverId,
      CallLabels.receiverName.name: receiverName,
      CallLabels.receiverPhotoUrl.name: receiverPhotoUrl,
      CallLabels.createAt.name: createAt,
      CallLabels.timestamp.name: timestamp,
      CallLabels.lastEventTimestamp.name: lastEventTimestamp,
      CallLabels.current.name: current
    };
  }

  Map<String, dynamic> toCloudFunctions() {
    return {
      CallLabels.callID.name: callID,
      CallLabels.appointmentID.name: appointmentID,
      CallLabels.token.name: token,
      CallLabels.type.name: type,
      CallLabels.callMethod.name: callMethod,
      CallLabels.lastCallEvent.name: lastCallEvent,
      CallLabels.channelName.name: channelName,
      CallLabels.callerId.name: callerId,
      CallLabels.callerName.name: callerName,
      CallLabels.callerPhotoUrl.name: callerPhotoUrl,
      CallLabels.receiverId.name: receiverId,
      CallLabels.receiverName.name: receiverName,
      CallLabels.receiverPhotoUrl.name: receiverPhotoUrl,
      CallLabels.createAt.name: createAt,
      CallLabels.timestamp.name: null,
      CallLabels.lastEventTimestamp.name: null,
      CallLabels.current.name: current
    };
  }
}

class UserCallInfo {
  String? name;
  String? photoUrl;
  UserCallInfo({
    this.name,
    this.photoUrl,
  });
  UserCallInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}

enum CallLabels {
  callID,
  appointmentID,
  token,
  type,
  callMethod,
  lastCallEvent,
  channelName,
  callerId,
  callerName,
  callerPhotoUrl,
  receiverId,
  receiverName,
  receiverPhotoUrl,
  createAt,
  timestamp,
  lastEventTimestamp,
  current,
}

enum CallTypes { translationCall, personalCall }

enum CallMethods { inApp, sim }

//Call State
enum CallStatus {
  unknown,
  none,
  connecting,
  dialing,
  ringing,
  accept,
  reject,
  unAnswer,
  cancel,
  end,
}
