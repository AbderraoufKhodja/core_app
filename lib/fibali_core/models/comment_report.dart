import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class ReportComment {
  final String? reportID;
  final String? messageContent;
  final String? reportedUID;
  final String? reportingUID;
  final String? reason;
  final List<String>? screenshots;
  final String? commentID;
  final String? commentRef;

  final dynamic timestamp;

  ReportComment({
    this.reportID,
    this.messageContent,
    this.reportedUID,
    this.reportingUID,
    this.reason,
    this.screenshots,
    this.commentID,
    this.commentRef,
    this.timestamp,
  });

  static String reportsCollection = 'reports';

  static CollectionReference<ReportComment> get ref =>
      FirebaseFirestore.instance.collection(reportsCollection).withConverter<ReportComment>(
            fromFirestore: (snapshot, options) => ReportComment.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static storageRef({required String reportID}) => 'reports/reportComment/$reportID';

  factory ReportComment.fromFirestore(Map<String, dynamic> doc) {
    return ReportComment(
        reportID: getField(doc, ReLabels.reportID.name, String),
        messageContent: getField(doc, ReLabels.messageContent.name, String),
        reportedUID: getField(doc, ReLabels.reportedUID.name, String),
        reportingUID: getField(doc, ReLabels.reportingUID.name, String),
        reason: getField(doc, ReLabels.reason.name, String),
        screenshots: getField(doc, ReLabels.screenshots.name, List),
        commentID: getField(doc, ReLabels.commentID.name, String),
        commentRef: getField(doc, ReLabels.commentRef.name, String),
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
      ReLabels.commentID.name: commentID,
      ReLabels.commentRef.name: commentRef,
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
      ReLabels.commentID.name: commentID,
      ReLabels.commentRef.name: commentRef,
    };
  }

  bool isValid() {
    if (reportedUID?.isNotEmpty == true &&
        reportingUID?.isNotEmpty == true &&
        reason?.isNotEmpty == true &&
        commentID?.isNotEmpty == true &&
        commentRef?.isNotEmpty == true) return true;

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
  commentID,
  commentRef,
  timestamp,
}
