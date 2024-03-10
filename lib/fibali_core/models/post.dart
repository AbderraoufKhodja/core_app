import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:uuid/uuid.dart';

class Post {
  String? postID;
  String? uid;
  String? postType;
  String? authorName;
  String? authorPhoto;
  List<dynamic>? photoUrls;
  List<dynamic>? thumbnailUrls100x100;
  List<dynamic>? thumbnailUrls250x375;
  List<dynamic>? thumbnailUrls500x500;
  String? description;
  String? token;
  String? channelName;
  dynamic videoUrl;
  dynamic firebaseVideoUrl;
  final num? numLikes;
  final num? numViews;
  final num? numComments;
  String? category;
  String? privacy;
  String? country;
  Map<String, dynamic>? location;
  Map<String, dynamic>? lastLiveEvent;

  String? province;
  String? subProvince;
  String? subSubProvince;
  List<dynamic>? tags;
  bool? isActive;
  dynamic timestamp;

  Post({
    required this.uid,
    required this.postID,
    required this.postType,
    required this.authorName,
    required this.authorPhoto,
    required this.description,
    required this.token,
    required this.channelName,
    required this.videoUrl,
    required this.firebaseVideoUrl,
    required this.numLikes,
    required this.numViews,
    required this.numComments,
    required this.category,
    required this.privacy,
    required this.country,
    required this.location,
    required this.lastLiveEvent,
    required this.province,
    required this.subProvince,
    required this.subSubProvince,
    required this.tags,
    required this.photoUrls,
    required this.thumbnailUrls100x100,
    required this.thumbnailUrls250x375,
    required this.thumbnailUrls500x500,
    required this.isActive,
    required this.timestamp,
  });
  static const followingUsersPostsCollection = 'followingUsersPosts';
  static CollectionReference<Post> get ref =>
      FirebaseFirestore.instance.collection(postsCollection).withConverter<Post>(
          fromFirestore: (snapshot, options) => Post.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  static CollectionReference<Post> followingRef({required String userID}) =>
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userID)
          .collection(followingUsersPostsCollection)
          .withConverter<Post>(
            fromFirestore: (snapshot, options) => Post.fromFirestore(snapshot.data()!),
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Reference photoStorageRef({required String postID}) {
    return FirebaseStorage.instance.ref().child(postsCollection).child(postID).child('postPhotos');
  }

  static Reference videoStorageRef({required String postID}) {
    final videoID = const Uuid().v4();
    return FirebaseStorage.instance
        .ref()
        .child(postsCollection)
        .child(postID)
        .child('postVideo')
        .child(videoID + '.mp4');
  }

  factory Post.fromFirestore(Map<String, dynamic> doc) {
    return Post(
      uid: getField(doc, PoLabels.uid.name, String),
      postID: getField(doc, PoLabels.postID.name, String),
      postType: getField(doc, PoLabels.postType.name, String),
      authorName: getField(doc, PoLabels.authorName.name, String),
      authorPhoto: getField(doc, PoLabels.authorPhoto.name, String),
      tags: getField(doc, PoLabels.tags.name, List<dynamic>),
      description: getField(doc, PoLabels.description.name, String),
      token: getField(doc, PoLabels.token.name, String),
      channelName: getField(doc, PoLabels.channelName.name, String),
      videoUrl: getField(doc, PoLabels.videoUrl.name, dynamic),
      firebaseVideoUrl: getField(doc, PoLabels.firebaseVideoUrl.name, dynamic),
      numLikes: getField(doc, PoLabels.numLikes.name, num),
      numViews: getField(doc, PoLabels.numViews.name, num),
      numComments: getField(doc, PoLabels.numComments.name, num),
      category: getField(doc, PoLabels.category.name, String),
      privacy: getField(doc, PoLabels.privacy.name, String),
      country: getField(doc, PoLabels.country.name, String),
      location: getField(doc, PoLabels.location.name, Map<String, dynamic>),
      lastLiveEvent: getField(doc, PoLabels.lastLiveEvent.name, Map<String, dynamic>),
      province: getField(doc, PoLabels.province.name, String),
      subProvince: getField(doc, PoLabels.subProvince.name, String),
      subSubProvince: getField(doc, PoLabels.subSubProvince.name, String),
      photoUrls: getField(doc, PoLabels.photoUrls.name, List<dynamic>),
      thumbnailUrls100x100: getField(doc, PoLabels.thumbnailUrls100x100.name, List<dynamic>),
      thumbnailUrls250x375: getField(doc, PoLabels.thumbnailUrls250x375.name, List<dynamic>),
      thumbnailUrls500x500: getField(doc, PoLabels.thumbnailUrls500x500.name, List<dynamic>),
      isActive: getField(doc, PoLabels.isActive.name, bool),
      timestamp: getField(doc, PoLabels.timestamp.name, Timestamp),
    );
  }
  factory Post.empty() {
    return Post(
      uid: null,
      postID: null,
      postType: null,
      authorName: null,
      authorPhoto: null,
      tags: null,
      description: null,
      token: null,
      channelName: null,
      videoUrl: null,
      firebaseVideoUrl: null,
      numLikes: null,
      numViews: null,
      numComments: null,
      category: null,
      privacy: null,
      country: null,
      location: null,
      lastLiveEvent: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      photoUrls: null,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      isActive: null,
      timestamp: null,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      PoLabels.uid.name: uid,
      PoLabels.postID.name: postID,
      PoLabels.postType.name: postType,
      PoLabels.authorName.name: authorName,
      PoLabels.authorPhoto.name: authorPhoto,
      PoLabels.description.name: description,
      PoLabels.token.name: token,
      PoLabels.channelName.name: channelName,
      PoLabels.videoUrl.name: videoUrl,
      PoLabels.firebaseVideoUrl.name: firebaseVideoUrl,
      PoLabels.numLikes.name: numLikes,
      PoLabels.numViews.name: numViews,
      PoLabels.numComments.name: numComments,
      PoLabels.category.name: category,
      PoLabels.privacy.name: privacy,
      PoLabels.country.name: country,
      PoLabels.location.name: location,
      PoLabels.lastLiveEvent.name: lastLiveEvent,
      PoLabels.province.name: province,
      PoLabels.subProvince.name: subProvince,
      PoLabels.subSubProvince.name: subSubProvince,
      PoLabels.tags.name: tags,
      PoLabels.photoUrls.name: photoUrls,
      PoLabels.thumbnailUrls100x100.name: thumbnailUrls100x100,
      PoLabels.thumbnailUrls250x375.name: thumbnailUrls250x375,
      PoLabels.thumbnailUrls500x500.name: thumbnailUrls500x500,
      PoLabels.isActive.name: isActive,
      PoLabels.timestamp.name: timestamp,
    };
  }

  Map<String, dynamic> toLinkJson() {
    return {
      PoLabels.uid.name: uid,
      PoLabels.postID.name: postID,
      PoLabels.postType.name: postType,
      PoLabels.authorName.name: authorName,
      PoLabels.authorPhoto.name: authorPhoto,
      PoLabels.description.name: description,
      PoLabels.token.name: token,
      PoLabels.channelName.name: channelName,
      PoLabels.videoUrl.name: videoUrl,
      PoLabels.firebaseVideoUrl.name: firebaseVideoUrl,
      PoLabels.numLikes.name: null,
      PoLabels.numViews.name: null,
      PoLabels.numComments.name: null,
      PoLabels.category.name: null,
      PoLabels.privacy.name: null,
      PoLabels.country.name: null,
      PoLabels.location.name: null,
      PoLabels.lastLiveEvent.name: null,
      PoLabels.province.name: null,
      PoLabels.subProvince.name: null,
      PoLabels.subSubProvince.name: null,
      PoLabels.tags.name: null,
      PoLabels.photoUrls.name: photoUrls,
      PoLabels.thumbnailUrls100x100.name: thumbnailUrls100x100,
      PoLabels.thumbnailUrls250x375.name: thumbnailUrls250x375,
      PoLabels.thumbnailUrls500x500.name: thumbnailUrls500x500,
      PoLabels.isActive.name: null,
      PoLabels.timestamp.name: null,
    };
  }

  bool isValid() {
    if (uid != null &&
        postID != null &&
        authorName != null &&
        (photoUrls != null ||
            videoUrl != null ||
            thumbnailUrls100x100 != null ||
            thumbnailUrls250x375 != null ||
            thumbnailUrls500x500 != null ||
            description != null ||
            (token != null && channelName != null))) return true;

    return false;
  }

  factory Post.fromPreferences({required SharedPreferences prefs}) {
    return Post(
      uid: null,
      postID: null,
      postType: null,
      authorName: null,
      authorPhoto: null,
      description: prefs.getString("description"),
      token: prefs.getString("token"),
      channelName: prefs.getString("channelName"),
      videoUrl: prefs.getString("videoUrl"),
      firebaseVideoUrl: prefs.getString("firebaseVideoUrl"),
      numLikes: null,
      numViews: null,
      numComments: null,
      category: prefs.getString("category"),
      privacy: prefs.getString("privacy"),
      country: null,
      location: null,
      lastLiveEvent: null,
      province: null,
      subProvince: null,
      subSubProvince: null,
      tags: prefs.getStringList("tags"),
      photoUrls: null,
      thumbnailUrls100x100: null,
      thumbnailUrls250x375: null,
      thumbnailUrls500x500: null,
      isActive: null,
      timestamp: null,
    );
  }

  String? getThumbnailUrl100x100(int idx) {
    // if idx is out of range, return null
    if ((idx + 1) > (thumbnailUrls100x100?.length ?? 0)) return null;

    return thumbnailUrls100x100![idx];
  }

  String? getThumbnailUrl250x375(int idx) {
    // if idx is out of range, return null
    if ((idx + 1) > (thumbnailUrls250x375?.length ?? 0)) return null;

    return thumbnailUrls250x375![idx];
  }

  String? getThumbnailUrl500x500(int idx) {
    // if idx is out of range, return null
    if ((idx + 1) > (thumbnailUrls500x500?.length ?? 0)) return null;

    return thumbnailUrls500x500![idx];
  }
}

enum PoLabels {
  uid,
  postID,
  postType,
  authorName,
  authorPhoto,
  description,
  token,
  channelName,
  videoUrl,
  firebaseVideoUrl,
  numLikes,
  numViews,
  numComments,
  category,
  privacy,
  country,
  location,
  lastLiveEvent,
  province,
  subProvince,
  subSubProvince,
  tags,
  photoUrls,
  thumbnailUrls100x100,
  thumbnailUrls250x375,
  thumbnailUrls500x500,
  isActive,
  timestamp,
}

enum PostPrivacyType { public, friends, followers, me }

enum PostTypes { textOnly, image, video, live }
