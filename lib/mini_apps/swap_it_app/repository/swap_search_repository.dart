import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SwapSearchRepository {
  final db = FirebaseFirestore.instance;

  Future<void> likeItem({
    required String currentUserId,
    required String selectedUserId,
    required String selectedItemId,
  }) {
    final batch = db.batch();
    final likeRef = Appreciation.ref.doc('swap_$currentUserId$selectedItemId');
    final swapAppreciationListsRef = SwapAppreciationList.ref(currentUserId);

    final appreciation = Appreciation(
      interestBy: currentUserId,
      itemID: selectedItemId,
      uid: selectedUserId,
      state: ApTypes.like.name,
      timestamp: FieldValue.serverTimestamp(),
    );

    // Analytics
    FAC.logEvent(FAEvent.like_swap_item);

    batch.set(likeRef, appreciation);
    batch.set(
      swapAppreciationListsRef,
      SwapAppreciationList(
        listID: 'swapAppreciationList',
        items: [
          SwapAppreciationRecord(
            uid: selectedUserId,
            itemID: selectedItemId,
            timestamp: Timestamp.now(),
          ).toFirestore(),
        ],
        timestamp: FieldValue.serverTimestamp(),
      ),
      SetOptions(merge: true),
    );

    return batch.commit();
  }

  Future<void> passItem({
    required String currentUserId,
    required String selectedItemId,
    required String selectedUserId,
  }) async {
    final batch = db.batch();
    final appreciationRef = Appreciation.ref.doc('swap_$currentUserId$selectedItemId');
    final swapAppreciationListsRef = SwapAppreciationList.ref(currentUserId);

    final appreciation = Appreciation(
      interestBy: currentUserId,
      itemID: selectedItemId,
      uid: selectedUserId,
      state: ApTypes.dislike.name,
      timestamp: FieldValue.serverTimestamp(),
    );

    // Analytics
    FirebaseAnalytics.instance.logEvent(
      name: 'pass_swap_item',
      parameters: appreciation.toJson(),
    );

    batch.set<Appreciation>(appreciationRef, appreciation);

    batch.set<SwapAppreciationList>(
      swapAppreciationListsRef,
      SwapAppreciationList(
        listID: 'swapAppreciationList',
        items: [
          SwapAppreciationRecord(
            uid: selectedUserId,
            itemID: selectedItemId,
            timestamp: Timestamp.now(),
          ).toFirestore(),
        ],
        timestamp: FieldValue.serverTimestamp(),
      ),
      SetOptions(merge: true),
    );

    return batch.commit();
  }

  Future<AppUser> getUser({required String userID}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection(usersCollection).doc(userID).get();
    return AppUser.fromFirestore(documentSnapshot.data() ?? {});
  }

  Future<List<String>> getChosenList({required String userId}) async {
    List<String> chosenList = [];
    await Appreciation.ref
        .where(ApLabels.interestBy.name, isEqualTo: userId)
        .orderBy(ApLabels.timestamp.name, descending: true)
        .get()
        .then((querySnapshot) {
      chosenList = querySnapshot.docs
          .map((doc) => getField(doc, LiLabels.itemID.name, String) as String)
          .toList();
    });
    return chosenList;
  }

  Future<List<SwapItem>> getSwapItems({
    required List<SwapItemRecord> swapItemsRecords,
    required String swapItemRecordRef,
  }) {
    return Future.wait(
      swapItemsRecords.map((itemRecord) => SwapItem.ref.doc(itemRecord.itemID).get()),
    ).then((docs) => docs
        .where((doc) {
          if (doc.exists == false) {
            SwapItemsList.ref.doc(swapItemRecordRef).update({
              SILLabels.items.name: FieldValue.arrayRemove([
                swapItemsRecords.firstWhere((element) => element.itemID == doc.id).toFirestore()
              ])
            });
          }
          return (doc.data()?.isValid() == true && doc.data()?.isSwapped == false);
        })
        .map((doc) => doc.data()!)
        .toList());
  }

  Future<List<SwapItemRecord>> getSwapListItems({
    required String docID,
    required String currentUserID,
  }) {
    return SwapItemsList.ref.doc(docID).get().then((itemsListDoc) =>
        itemsListDoc
            .data()
            ?.items
            ?.map((itemMap) => SwapItemRecord.fromFirestore(itemMap))
            .where((record) => record.uid != currentUserID)
            .toList() ??
        <SwapItemRecord>[]);
  }

  Future<List<SwapAppreciationRecord>> getSwapAppreciationList({
    required String currentUserID,
  }) {
    return SwapAppreciationList.ref(currentUserID).get().then((itemsListDoc) {
      final list = itemsListDoc.data()?.items;
      return list
              ?.whereType<Map<String, dynamic>>()
              .map((itemMap) => SwapAppreciationRecord.fromFirestore(itemMap))
              .toList() ??
          <SwapAppreciationRecord>[];
    });
  }
}

class SwapItemRecord {
  String? itemID;
  GeoPoint? geopoint;
  String? geohash;
  String? uid;
  dynamic timestamp;

  SwapItemRecord({
    required this.uid,
    required this.itemID,
    required this.geopoint,
    required this.geohash,
    required this.timestamp,
  });

  factory SwapItemRecord.fromFirestore(Map<String, dynamic> doc) {
    return SwapItemRecord(
      uid: getField(doc, SIRLabels.uid.name, String),
      itemID: getField(doc, SIRLabels.itemID.name, String),
      geopoint: getField(doc, SIRLabels.geopoint.name, GeoPoint),
      geohash: getField(doc, SIRLabels.geohash.name, String),
      timestamp: getField(doc, SIRLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SIRLabels.uid.name: uid,
      SIRLabels.itemID.name: itemID,
      SIRLabels.geopoint.name: geopoint,
      SIRLabels.geohash.name: geohash,
      SIRLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (uid != null && itemID != null) return true;

    return false;
  }
}

enum SIRLabels {
  uid,
  itemID,
  geopoint,
  geohash,
  timestamp,
}

class SwapItemsList {
  String? listID;
  List<dynamic>? items;
  Map<String, dynamic>? location;
  dynamic lastCheckTimestamp;

  SwapItemsList({
    required this.listID,
    required this.items,
    required this.location,
    required this.lastCheckTimestamp,
  });

  static CollectionReference<SwapItemsList> get ref =>
      FirebaseFirestore.instance.collection(swapItemsListsCollection).withConverter<SwapItemsList>(
          fromFirestore: (snapshot, options) => SwapItemsList.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory SwapItemsList.fromFirestore(Map<String, dynamic> doc) {
    return SwapItemsList(
      listID: getField(doc, SILLabels.listID.name, String),
      items: getField(doc, SILLabels.items.name, List<dynamic>),
      location: getField(doc, SILLabels.location.name, Map<String, dynamic>),
      lastCheckTimestamp: getField(doc, SILLabels.lastCheckTimestamp.name, Timestamp),
    );
  }

  factory SwapItemsList.empty() {
    return SwapItemsList(
      listID: null,
      items: null,
      location: null,
      lastCheckTimestamp: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SILLabels.listID.name: listID,
      if (items != null) SILLabels.items.name: FieldValue.arrayUnion(items!),
      SILLabels.location.name: location,
      SILLabels.lastCheckTimestamp.name: lastCheckTimestamp,
    };
  }

  bool isValid() {
    return false;
  }
}

enum SILLabels {
  listID,
  items,
  location,
  lastCheckTimestamp,
}

class SwapAppreciationList {
  String? listID;
  List<dynamic>? items;

  dynamic timestamp;

  SwapAppreciationList({
    required this.listID,
    required this.items,
    required this.timestamp,
  });

  static DocumentReference<SwapAppreciationList> ref(String userID) => FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(userID)
      .collection(appreciationListsCollection)
      .doc('swapAppreciationList')
      .withConverter<SwapAppreciationList>(
          fromFirestore: (snapshot, options) =>
              SwapAppreciationList.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore());

  factory SwapAppreciationList.fromFirestore(Map<String, dynamic> doc) {
    return SwapAppreciationList(
      listID: getField(doc, SALLabels.listID.name, String),
      items: getField(doc, SALLabels.items.name, List<dynamic>),
      timestamp: getField(doc, SALLabels.timestamp.name, Timestamp),
    );
  }

  factory SwapAppreciationList.empty() {
    return SwapAppreciationList(
      listID: null,
      items: null,
      timestamp: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SALLabels.listID.name: listID,
      if (items != null) SALLabels.items.name: FieldValue.arrayUnion(items!),
      SALLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    return false;
  }
}

enum SALLabels {
  listID,
  items,
  timestamp,
}

class SwapAppreciationRecord {
  String? itemID;
  String? uid;
  dynamic timestamp;

  SwapAppreciationRecord({
    required this.uid,
    required this.itemID,
    required this.timestamp,
  });

  factory SwapAppreciationRecord.fromFirestore(Map<String, dynamic> doc) {
    return SwapAppreciationRecord(
      uid: getField(doc, SARLabels.uid.name, String),
      itemID: getField(doc, SARLabels.itemID.name, String),
      timestamp: getField(doc, SARLabels.timestamp.name, Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      SARLabels.uid.name: uid,
      SARLabels.itemID.name: itemID,
      SARLabels.timestamp.name: timestamp,
    };
  }

  bool isValid() {
    if (uid != null && itemID != null) return true;

    return false;
  }
}

enum SARLabels {
  uid,
  itemID,
  timestamp,
}
