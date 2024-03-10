import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SwapReview {
  String? uid;
  String? swapID;
  String? userName;
  List<dynamic>? photoUrls;
  Map<String, dynamic>? receiverItemsID;
  Map<String, dynamic>? senderItemsID;

  String? reviewText;
  num? rating;
  dynamic timestamp;

  SwapReview({
    required this.uid,
    required this.swapID,
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.photoUrls,
    required this.receiverItemsID,
    required this.senderItemsID,
    required this.timestamp,
  });

  static CollectionReference<SwapReview> ref({required String userID}) => FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(userID)
      .collection('swapReviews')
      .withConverter<SwapReview>(
          fromFirestore: (snapshot, options) => SwapReview.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  static Reference storageRef({required String swapID}) {
    return FirebaseStorage.instance.ref().child('swapReviews').child(swapID).child('reviewPhotos');
  }

  factory SwapReview.fromFirestore(Map<String, dynamic> doc) {
    return SwapReview(
      uid: getField(doc, SRLabels.uid.name, String),
      swapID: getField(doc, SRLabels.swapID.name, String),
      userName: getField(doc, SRLabels.userName.name, String),
      photoUrls: getField(doc, SRLabels.photoUrls.name, List),
      receiverItemsID: getField(doc, SRLabels.receiverItemsID.name, Map<String, dynamic>),
      senderItemsID: getField(doc, SRLabels.senderItemsID.name, Map<String, dynamic>),
      reviewText: getField(doc, SRLabels.reviewText.name, String),
      rating: getField(doc, SRLabels.rating.name, num),
      timestamp: getField(doc, SRLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SRLabels.uid.name: uid,
      SRLabels.swapID.name: swapID,
      SRLabels.userName.name: userName,
      SRLabels.photoUrls.name: photoUrls,
      SRLabels.receiverItemsID.name: receiverItemsID,
      SRLabels.senderItemsID.name: senderItemsID,
      SRLabels.reviewText.name: reviewText,
      SRLabels.rating.name: rating,
      SRLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (uid != null && rating != null && swapID != null && timestamp != null) {
      return true;
    }

    return false;
  }
}

enum SRLabels {
  uid,
  swapID,
  userName,
  photoUrls,
  receiverItemsID,
  senderItemsID,
  reviewText,
  rating,
  timestamp,
}
