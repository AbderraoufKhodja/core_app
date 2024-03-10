import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class SwapItemRepository {
  final FirebaseFirestore _firestore;

  SwapItemRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<SwapItem>> getMatchedItems({
    required String userID,
  }) {
    return SwapItem.ref.where(SILabels.uid.name, isEqualTo: userID).snapshots();
  }

  Future<void> addViewMatch({required String matchID, required String userID}) {
    return _firestore.collection(swapMatchesCollection).doc(matchID).update({userID: true});
  }
}
