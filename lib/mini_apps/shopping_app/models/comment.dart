import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserBook {
  const UserBook({this.name, this.photosUrl, this.favoriteCategories});

  final String? name;
  final String? photosUrl;
  final List<String>? favoriteCategories;

  static const currentUser = UserBook(
    name: 'Kevin',
    photosUrl: 'https://i.ibb.co/992SLrQ/120603136-2461308150844778-7380402767182275816-n.jpg',
    favoriteCategories: [
      'Food',
      'Technology',
      'Programming',
      'Thriller',
      'Physic',
      'Sci-Fi',
    ],
  );
}

class Comment {
  final String? type;
  final String? postID;
  final String? commentID;
  final String? commentRef;
  final String? authorID;
  final String? senderID;
  final String? senderName;
  final String? senderPhoto;
  final String? text;
  final num? numComments;
  final bool? hasReplies;
  final num? numLikes;
  final List<dynamic>? photoUrls;
  final dynamic timestamp;

  Comment({
    required this.type,
    required this.postID,
    required this.commentID,
    required this.commentRef,
    required this.authorID,
    required this.senderName,
    required this.senderPhoto,
    required this.senderID,
    required this.numComments,
    required this.hasReplies,
    required this.numLikes,
    required this.text,
    required this.photoUrls,
    required this.timestamp,
  });
  static ref({required String postID}) => FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('comments')
      .withConverter<Comment>(
        fromFirestore: (snapshot, options) => Comment.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore(),
      );

  static Reference storageRef({required String commentPath}) {
    return FirebaseStorage.instance.ref().child(commentPath);
  }

  factory Comment.fromFirestore(Map<String, dynamic> doc) {
    return Comment(
      type: getField(doc, ComLabels.type.name, String),
      postID: getField(doc, ComLabels.postID.name, String),
      commentID: getField(doc, ComLabels.commentID.name, String),
      commentRef: getField(doc, ComLabels.commentRef.name, String),
      authorID: getField(doc, ComLabels.authorID.name, String),
      senderName: getField(doc, ComLabels.senderName.name, String),
      senderPhoto: getField(doc, ComLabels.senderPhoto.name, String),
      senderID: getField(doc, ComLabels.senderID.name, String),
      numComments: getField(doc, ComLabels.numComments.name, num),
      hasReplies: getField(doc, ComLabels.hasReplies.name, bool),
      numLikes: getField(doc, ComLabels.numLikes.name, num),
      text: getField(doc, ComLabels.text.name, String),
      photoUrls: getField(doc, ComLabels.photoUrls.name, List<dynamic>),
      timestamp: getField(doc, ComLabels.timestamp.name, Timestamp),
    );
  }

  bool isValid() {
    if (type != null &&
        postID != null &&
        commentID != null &&
        // commentRef != null &&
        authorID != null &&
        senderID != null &&
        senderName != null &&
        (text != null || photoUrls != null)) return true;
    return false;
  }

  Map<String, dynamic> toFirestore() {
    return {
      ComLabels.type.name: type,
      ComLabels.postID.name: postID,
      ComLabels.commentID.name: commentID,
      ComLabels.commentRef.name: commentRef,
      ComLabels.authorID.name: authorID,
      ComLabels.senderName.name: senderName,
      ComLabels.senderPhoto.name: senderPhoto,
      ComLabels.senderID.name: senderID,
      ComLabels.numComments.name: numComments,
      ComLabels.hasReplies.name: hasReplies,
      ComLabels.numLikes.name: numLikes,
      ComLabels.text.name: text,
      ComLabels.photoUrls.name: photoUrls,
      ComLabels.timestamp.name: timestamp,
    };
  }
}

enum ComLabels {
  type,
  postID,
  commentID,
  commentRef,
  authorID,
  senderID,
  senderName,
  senderPhoto,
  text,
  numComments,
  hasReplies,
  numLikes,
  photoUrls,
  timestamp,
}
