import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class SwapItemReport {
  final String? reportID;
  final String? messageContent;
  final String? reportedUID;
  final String? reportingUID;
  final String? reason;
  final List<String>? screenshots;
  final String? reportedItemID;
  final dynamic timestamp;

  SwapItemReport({
    this.reportID,
    this.messageContent,
    this.reportedUID,
    this.reportingUID,
    this.reason,
    this.screenshots,
    this.reportedItemID,
    this.timestamp,
  });

  static String reportsCollection = 'reports';

  static CollectionReference<SwapItemReport> get ref =>
      FirebaseFirestore.instance.collection(reportsCollection).withConverter<SwapItemReport>(
            fromFirestore: (snapshot, options) => SwapItemReport.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static storageRef({required String reportID}) => 'reports/reportSwapItem/$reportID';

  factory SwapItemReport.fromFirestore(Map<String, dynamic> doc) {
    return SwapItemReport(
        reportID: getField(doc, ReLabels.reportID.name, String),
        messageContent: getField(doc, ReLabels.messageContent.name, String),
        reportedUID: getField(doc, ReLabels.reportedUID.name, String),
        reportingUID: getField(doc, ReLabels.reportingUID.name, String),
        reason: getField(doc, ReLabels.reason.name, String),
        screenshots: getField(doc, ReLabels.screenshots.name, List),
        reportedItemID: getField(doc, ReLabels.reportedItemID.name, String),
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
      ReLabels.reportedItemID.name: reportedItemID,
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
      ReLabels.reportedItemID.name: reportedItemID,
    };
  }

  bool isValid() {
    if (reportedUID?.isNotEmpty == true &&
        reportingUID?.isNotEmpty == true &&
        reason?.isNotEmpty == true &&
        reportedItemID?.isNotEmpty == true) return true;
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
  reportedItemID,
  timestamp,
}
