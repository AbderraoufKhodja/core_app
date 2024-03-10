import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';

class UserTerms {
  String? userTerms;
  Map<String, dynamic>? inter;
  dynamic timestamp;

  UserTerms({
    required this.userTerms,
    required this.inter,
    required this.timestamp,
  });

  factory UserTerms.fromFirestore(Map<String, dynamic> doc) {
    return UserTerms(
      userTerms: getField(doc, UTLabels.userTerms.name, String),
      inter: getField(doc, UTLabels.inter.name, Map<String, dynamic>),
      timestamp: getField(doc, UTLabels.timestamp.name, Timestamp),
    );
  }
  static String userTermsCollection = 'userTerms';
  static CollectionReference<UserTerms> ref() =>
      FirebaseFirestore.instance.collection(userTermsCollection).withConverter<UserTerms>(
            fromFirestore: (snapshot, options) => UserTerms.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Query<UserTerms> get latestRef => FirebaseFirestore.instance
      .collection(userTermsCollection)
      .orderBy(UTLabels.timestamp.name, descending: true)
      .limit(1)
      .withConverter<UserTerms>(
        fromFirestore: (snapshot, options) => UserTerms.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  Map<String, dynamic> toFirestore() {
    return {
      UTLabels.userTerms.name: userTerms,
      UTLabels.inter.name: inter,
      UTLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    return false;
  }
}

enum UTLabels {
  userTerms,
  inter,
  timestamp,
}
