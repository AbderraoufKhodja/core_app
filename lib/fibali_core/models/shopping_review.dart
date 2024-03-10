import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShoppingReview {
  String? uid;
  String? itemID;
  String? storeID;
  String? orderID;
  String? userName;
  List<dynamic>? photoUrls;
  String? reviewText;
  num? rating;
  dynamic timestamp;

  ShoppingReview({
    required this.uid,
    required this.itemID,
    required this.storeID,
    required this.orderID,
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.photoUrls,
    required this.timestamp,
  });

  static const reviewsCollection = "reviews";

  static CollectionReference<ShoppingReview> get ref =>
      FirebaseFirestore.instance.collection(reviewsCollection).withConverter<ShoppingReview>(
            fromFirestore: (snapshot, options) => ShoppingReview.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Reference storageRef({required String reviewID}) {
    return FirebaseStorage.instance
        .ref()
        .child(reviewsCollection)
        .child(reviewID)
        .child('reviewPhotos');
  }

  factory ShoppingReview.fromFirestore(Map<String, dynamic> doc) {
    return ShoppingReview(
      uid: getField(doc, SRLabels.uid.name, String),
      itemID: getField(doc, SRLabels.itemID.name, String),
      storeID: getField(doc, SRLabels.storeID.name, String),
      orderID: getField(doc, SRLabels.orderID.name, String),
      userName: getField(doc, SRLabels.userName.name, String),
      photoUrls: getField(doc, SRLabels.photoUrls.name, List),
      reviewText: getField(doc, SRLabels.reviewText.name, String),
      rating: getField(doc, SRLabels.rating.name, num),
      timestamp: getField(doc, SRLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SRLabels.uid.name: uid,
      SRLabels.itemID.name: itemID,
      SRLabels.storeID.name: storeID,
      SRLabels.orderID.name: orderID,
      SRLabels.userName.name: userName,
      SRLabels.photoUrls.name: photoUrls,
      SRLabels.reviewText.name: reviewText,
      SRLabels.rating.name: rating,
      SRLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (uid != null &&
        itemID != null &&
        storeID != null &&
        rating != null &&
        orderID != null &&
        timestamp != null) return true;
    return false;
  }
}

enum SRLabels {
  uid,
  itemID,
  storeID,
  orderID,
  userName,
  photoUrls,
  reviewText,
  rating,
  timestamp,
}
