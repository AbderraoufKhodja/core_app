import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';

class InterestedUsersRepository {
  Stream<QuerySnapshot<Appreciation>> getIntrestedUsers({required String itemID}) {
    return Appreciation.ref
        .where(ApLabels.itemID.name, isEqualTo: itemID)
        .where(ApLabels.state.name, isEqualTo: ApTypes.like.name)
        .orderBy(ApLabels.timestamp.name, descending: true)
        .limit(50)
        .snapshots();
  }
}
