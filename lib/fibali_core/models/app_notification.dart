import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class AppNotification {
  final String? notificationType;
  final String? notificationID;
  final String? chatID;
  final String? commentType;
  final String? type;
  final String? callStatus;
  final String? callID;
  final String? messageID;
  final String? postID;
  final String? orderID;
  final String? storeID;

  final String? itemID;
  final Map<String, dynamic>? order;
  final Map<String, dynamic>? item;
  final Map<String, dynamic>? senderItems;
  final Map<String, dynamic>? otherItems;
  final GeoPoint? location;
  final String? senderName;
  final String? senderPhoto;
  final String? senderID;
  final String? receiverID;
  final Map<String, dynamic>? isSeen;
  final String? description;
  final String? text;
  final String? title;
  String? photoUrl;
  final dynamic timestamp;

  AppNotification({
    required this.notificationType,
    required this.notificationID,
    required this.chatID,
    required this.commentType,
    required this.type,
    required this.callStatus,
    required this.callID,
    required this.messageID,
    required this.postID,
    required this.orderID,
    required this.storeID,
    required this.itemID,
    required this.order,
    required this.item,
    required this.senderItems,
    required this.otherItems,
    required this.location,
    required this.senderName,
    required this.senderPhoto,
    required this.senderID,
    required this.receiverID,
    required this.isSeen,
    required this.description,
    required this.text,
    required this.title,
    required this.photoUrl,
    required this.timestamp,
  });

  static CollectionReference<AppNotification> ref({required String userID}) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userID)
        .collection(notificationsCollection)
        .withConverter<AppNotification>(
          fromFirestore: (snapshot, options) => AppNotification.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        );
  }

  factory AppNotification.fromFirestore(Map<String, dynamic> doc) {
    return AppNotification(
      notificationType: getField(doc, AppNotLabels.notificationType.name, String),
      notificationID: getField(doc, AppNotLabels.notificationID.name, String),
      chatID: getField(doc, AppNotLabels.chatID.name, String),
      commentType: getField(doc, AppNotLabels.commentType.name, String),
      type: getField(doc, AppNotLabels.type.name, String),
      callStatus: getField(doc, AppNotLabels.callStatus.name, String),
      callID: getField(doc, AppNotLabels.callID.name, String),
      messageID: getField(doc, AppNotLabels.messageID.name, String),
      postID: getField(doc, AppNotLabels.postID.name, String),
      orderID: getField(doc, AppNotLabels.orderID.name, String),
      storeID: getField(doc, AppNotLabels.storeID.name, String),
      itemID: getField(doc, AppNotLabels.itemID.name, String),
      order: getField(doc, AppNotLabels.order.name, Map<String, dynamic>),
      item: getField(doc, AppNotLabels.item.name, Map<String, dynamic>),
      senderItems: getField(doc, AppNotLabels.senderItems.name, Map<String, dynamic>),
      otherItems: getField(doc, AppNotLabels.otherItems.name, Map<String, dynamic>),
      location: getField(doc, AppNotLabels.location.name, GeoPoint),
      senderName: getField(doc, AppNotLabels.senderName.name, String),
      senderPhoto: getField(doc, AppNotLabels.senderPhoto.name, String),
      senderID: getField(doc, AppNotLabels.senderID.name, String),
      receiverID: getField(doc, AppNotLabels.receiverID.name, String),
      isSeen: getField(doc, AppNotLabels.isSeen.name, Map<String, dynamic>),
      description: getField(doc, AppNotLabels.description.name, String),
      text: getField(doc, AppNotLabels.text.name, String),
      title: getField(doc, AppNotLabels.title.name, String),
      photoUrl: getField(doc, AppNotLabels.photoUrl.name, String),
      timestamp: getField(doc, AppNotLabels.timestamp.name, Timestamp),
    );
  }

  bool isValid() {
    if (notificationID != null &&
        notificationType != null &&
        type != null &&
        senderName != null &&
        senderID != null &&
        receiverID != null &&
        // isSeen != null &&
        (notificationType == AppNotTypes.relation.name ||
            orderID != null ||
            postID != null ||
            storeID != null ||
            order != null ||
            item != null ||
            callStatus != null ||
            callID != null ||
            senderItems != null ||
            otherItems != null ||
            location != null ||
            description != null ||
            text != null ||
            title != null ||
            photoUrl != null)) return true;
    return false;
  }

  Map<String, dynamic> toFirestore() {
    return {
      AppNotLabels.notificationType.name: notificationType,
      AppNotLabels.notificationID.name: notificationID,
      AppNotLabels.chatID.name: chatID,
      AppNotLabels.commentType.name: commentType,
      AppNotLabels.type.name: type,
      AppNotLabels.callStatus.name: callStatus,
      AppNotLabels.callID.name: callID,
      AppNotLabels.messageID.name: messageID,
      AppNotLabels.postID.name: postID,
      AppNotLabels.orderID.name: orderID,
      AppNotLabels.storeID.name: storeID,
      AppNotLabels.itemID.name: itemID,
      AppNotLabels.order.name: order,
      AppNotLabels.item.name: item,
      AppNotLabels.senderItems.name: senderItems,
      AppNotLabels.otherItems.name: otherItems,
      AppNotLabels.location.name: location,
      AppNotLabels.senderName.name: senderName,
      AppNotLabels.senderPhoto.name: senderPhoto,
      AppNotLabels.senderID.name: senderID,
      AppNotLabels.receiverID.name: receiverID,
      AppNotLabels.isSeen.name: isSeen,
      AppNotLabels.description.name: description,
      AppNotLabels.text.name: text,
      AppNotLabels.title.name: title,
      AppNotLabels.photoUrl.name: photoUrl,
      AppNotLabels.timestamp.name: timestamp,
    };
  }
}

enum AppNotLabels {
  notificationType,
  notificationID,
  chatID,
  commentType,
  type,
  callStatus,
  callID,
  messageID,
  postID,
  orderID,
  storeID,

  itemID,
  order,
  item,
  senderItems,
  otherItems,
  location,
  senderName,
  senderPhoto,
  senderID,
  receiverID,
  isSeen,
  description,
  text,
  title,
  photoUrl,
  timestamp,
}

enum AppNotTypes {
  relation,
  post,
  swap,
  message,
  orderEvent,
  translatorCall,
}

enum PostNotTypes {
  newPostComment,
  newPostLike,
  newPost,
  newCommentReply,
}

enum RelationNotTypes {
  friendRequest,
  friendRequestAccepted,
  newFollow,
}

enum SwapNotTypes {
  newSwapItemReview,
  newSwapItemLike,
  newMatch,
}

enum OrEvNotTypes {
  newOrder,
  remindSeller,
  orderReceived,
  refundApplication,
  addReview,
  itemPackaged,
  packageSent,
  confirmOrder,
  acceptRefund,
  declineRefund,
}
