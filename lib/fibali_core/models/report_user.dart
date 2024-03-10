import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class ReportProfile {
  final String? reportID;
  final String? messageContent;
  final String? reportedUID;
  final String? reportingUID;
  final String? reason;
  final List<String>? screenshots;
  final dynamic timestamp;

  ReportProfile({
    this.reportID,
    this.messageContent,
    this.reportedUID,
    this.reportingUID,
    this.reason,
    this.screenshots,
    this.timestamp,
  });

  static String reportsCollection = 'reports';

  static CollectionReference<ReportProfile> get ref =>
      FirebaseFirestore.instance.collection(reportsCollection).withConverter<ReportProfile>(
            fromFirestore: (snapshot, options) => ReportProfile.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static storageRef({required String reportID}) => 'reports/user/$reportID';

  factory ReportProfile.fromFirestore(Map<String, dynamic> doc) {
    return ReportProfile(
        reportID: getField(doc, ReLabels.reportID.name, String),
        messageContent: getField(doc, ReLabels.messageContent.name, String),
        reportedUID: getField(doc, ReLabels.reportedUID.name, String),
        reportingUID: getField(doc, ReLabels.reportingUID.name, String),
        reason: getField(doc, ReLabels.reason.name, String),
        screenshots: getField(doc, ReLabels.screenshots.name, List),
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
    };
  }

  bool isValid() {
    if (reportedUID?.isNotEmpty == true &&
        reportingUID?.isNotEmpty == true &&
        reason?.isNotEmpty == true) return true;
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
  timestamp,
}
