import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';

class InterestedUserSwapItemsRepository {
  final FirebaseFirestore _firestore;

  InterestedUserSwapItemsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getInterestedUsersItems({required String userID}) {
    return _firestore
        .collection('swapItems')
        .where('uid', isEqualTo: userID)
        .where('isSwapped', isEqualTo: false)
        .snapshots();
  }

  Future<void> passItem({
    required String currentUserID,
    required String otherItemID,
    required String otherUserID,
  }) {
    return Appreciation.ref.doc('swap_$currentUserID$otherItemID').set(Appreciation(
          interestBy: currentUserID,
          itemID: otherItemID,
          uid: otherUserID,
          state: ApTypes.dislike.name,
          timestamp: FieldValue.serverTimestamp(),
        ));
  }

  Future<void> acceptItem({
    required String currentUserID,
    required String otherUserID,
    required String otherItemID,
  }) {
    return Appreciation.ref.doc('swap_$currentUserID$otherItemID').set(Appreciation(
          interestBy: currentUserID,
          itemID: otherItemID,
          uid: otherUserID,
          state: ApTypes.like.name,
          timestamp: FieldValue.serverTimestamp(),
        ));
  }
}
