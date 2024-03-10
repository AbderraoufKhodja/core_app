import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class UserSwapItemsRepository {
  final FirebaseFirestore _firestore;

  UserSwapItemsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<SwapItem>> getUserItems({required String userId}) {
    return SwapItem.ref.where(SILabels.uid.name, isEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot<Appreciation>> getChosenList({required String userID}) {
    return Appreciation.ref
        .where(ApLabels.interestBy.name, isEqualTo: userID)
        .orderBy(ApLabels.timestamp.name, descending: true)
        .limit(150)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMatchedList({required String userID}) {
    return _firestore
        .collection(swapMatchesCollection)
        .where(userID, whereIn: [false, true]).snapshots();
  }

  Stream<QuerySnapshot<Appreciation>> getInterestedUsers({required String userID}) {
    return Appreciation.ref
        .where(ApLabels.uid.name, isEqualTo: userID)
        .where(ApLabels.state.name, isEqualTo: 'like')
        .orderBy(ApLabels.timestamp.name, descending: true)
        .limit(50)
        .snapshots();
  }
}
