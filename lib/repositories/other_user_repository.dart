import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class OtherUserRepository {
  final FirebaseFirestore _firestore;

  OtherUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOtherUser({required String userID}) {
    return _firestore.collection(usersCollection).doc(userID).snapshots();
  }
}
