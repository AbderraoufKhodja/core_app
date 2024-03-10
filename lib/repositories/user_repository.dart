import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

class UserRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<bool> isFirstTime({required String userId}) async {
    late bool exist;
    await FirebaseFirestore.instance.collection(usersCollection).doc(userId).get().then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
