import 'package:fibali/fibali_core/models/app_user.dart';

class CallEvent {
  late String callID;
  String? appointmentID;
  String? token;
  String? type;
  String? channelName;
  String? callerId;
  String? callerName;
  String? callerPhotoUrl;
  String? receiverId;
  String? receiverName;
  String? receiverPhotoUrl;
  String? status;
  num? createAt;
  num? timestamp;

  CallEvent({
    required this.callID,
    required this.appointmentID,
    required this.token,
    required this.type,
    required this.channelName,
    required this.callerId,
    required this.callerName,
    required this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.status,
    required this.createAt,
    required this.timestamp,
  });

  CallEvent.fromFirebase(Map<String, dynamic> json) {
    callID = getField(json, CallEventLabels.callID.name, String);
    appointmentID = getField(json, CallEventLabels.appointmentID.name, String);
    token = getField(json, CallEventLabels.token.name, String);
    type = getField(json, CallEventLabels.type.name, String);
    channelName = getField(json, CallEventLabels.channelName.name, String);
    callerId = getField(json, CallEventLabels.callerId.name, String);
    callerName = getField(json, CallEventLabels.callerName.name, String);
    callerPhotoUrl = getField(json, CallEventLabels.callerPhotoUrl.name, String);
    receiverId = getField(json, CallEventLabels.receiverId.name, String);
    receiverName = getField(json, CallEventLabels.receiverName.name, String);
    receiverPhotoUrl = getField(json, CallEventLabels.receiverPhotoUrl.name, String);
    status = getField(json, CallEventLabels.status.name, String);
    createAt = getField(json, CallEventLabels.createAt.name, num);
    timestamp = getField(json, CallEventLabels.timestamp.name, num);
  }

  Map<String, dynamic> toFirebase() {
    return {
      CallEventLabels.callID.name: callID,
      CallEventLabels.appointmentID.name: appointmentID,
      CallEventLabels.token.name: token,
      CallEventLabels.type.name: type,
      CallEventLabels.channelName.name: channelName,
      CallEventLabels.callerId.name: callerId,
      CallEventLabels.callerName.name: callerName,
      CallEventLabels.callerPhotoUrl.name: callerPhotoUrl,
      CallEventLabels.receiverId.name: receiverId,
      CallEventLabels.receiverName.name: receiverName,
      CallEventLabels.receiverPhotoUrl.name: receiverPhotoUrl,
      CallEventLabels.status.name: status,
      CallEventLabels.createAt.name: createAt,
      CallEventLabels.timestamp.name: timestamp,
    };
  }
}

enum CallEventLabels {
  callID,
  appointmentID,
  token,
  type,
  channelName,
  callerId,
  callerName,
  callerPhotoUrl,
  receiverId,
  receiverName,
  receiverPhotoUrl,
  status,
  createAt,
  timestamp,
}
