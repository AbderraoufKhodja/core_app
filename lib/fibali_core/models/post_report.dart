import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class ReportPost {
  final String? reportID;
  final String? messageContent;
  final String? reportedUID;
  final String? reportingUID;
  final String? reason;
  final List<String>? screenshots;
  final String? postID;
  final dynamic timestamp;

  ReportPost({
    this.reportID,
    this.messageContent,
    this.reportedUID,
    this.reportingUID,
    this.reason,
    this.screenshots,
    this.postID,
    this.timestamp,
  });

  static String reportsCollection = 'reports';

  static CollectionReference<ReportPost> get ref =>
      FirebaseFirestore.instance.collection(reportsCollection).withConverter<ReportPost>(
            fromFirestore: (snapshot, options) => ReportPost.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static storageRef({required String reportID}) => 'reports/reportPost/$reportID';

  factory ReportPost.fromFirestore(Map<String, dynamic> doc) {
    return ReportPost(
        reportID: getField(doc, ReLabels.reportID.name, String),
        messageContent: getField(doc, ReLabels.messageContent.name, String),
        reportedUID: getField(doc, ReLabels.reportedUID.name, String),
        reportingUID: getField(doc, ReLabels.reportingUID.name, String),
        reason: getField(doc, ReLabels.reason.name, String),
        screenshots: getField(doc, ReLabels.screenshots.name, List),
        postID: getField(doc, ReLabels.postID.name, String),
        timestamp: getField(doc, ReLabels.timestamp.name, Timestamp));
  }

  Map<String, dynamic> toFirestore() {
    return {
      ReLabels.reportID.name: reportID,
      ReLabels.messageContent.name: messageContent,
      ReLabels.reportedUID.name: reportedUID,
      ReLabels.reportingUID.name: reportingUID,
      ReLabels.reason.name: reason,
      ReLabels.screenshots.name: screenshots,
      ReLabels.postID.name: postID,
      ReLabels.timestamp.name: timestamp,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      ReLabels.reportID.name: reportID,
      ReLabels.messageContent.name: messageContent,
      ReLabels.reportedUID.name: reportedUID,
      ReLabels.reportingUID.name: reportingUID,
      ReLabels.reason.name: reason,
      ReLabels.screenshots.name: screenshots,
      ReLabels.postID.name: postID,
    };
  }

  bool isValid() {
    if (reportedUID?.isNotEmpty == true &&
        reportingUID?.isNotEmpty == true &&
        reason?.isNotEmpty == true &&
        postID?.isNotEmpty == true) return true;
    return false;
  }
}

enum ReLabels {
  reportID,
  messageContent,
  reportedUID,
  reportingUID,
  reason,
  screenshots,
  postID,
  timestamp,
}
