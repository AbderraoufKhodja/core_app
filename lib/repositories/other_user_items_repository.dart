import 'package:cloud_firestore/cloud_firestore.dart';

class OtherUserItemsRepository {
  final FirebaseFirestore _firestore;

  OtherUserItemsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOtherUserItems({
    required String? otherUserID,
  }) {
    return _firestore.collection('items').where('storeOwnerID', isEqualTo: otherUserID).snapshots();
  }
}
