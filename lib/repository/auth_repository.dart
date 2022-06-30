import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_animal_rescue/modal/user_model.dart';
import 'package:street_animal_rescue/services/print_services.dart';

class AuthRepository {
  final _firestore = FirebaseFirestore.instance;
  final _fireAuth = FirebaseAuth.instance;
  static final userCollection = 'users';

  Future<UserModel?> registerUser({
    required String verificationCode,
    required String smsCode,
  }) async {
    final userCred = await _fireAuth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: smsCode,
      ),
    );
    UserModel? um;
    if (userCred.user != null) {
      final token = await userCred.user!.getIdToken();
      sPrint('user token: $token');
      final userModel = UserModel(
        phoneNumber: userCred.user?.phoneNumber,
        uid: userCred.user?.uid,
        token: token,
      );
      um = userModel;
      await _firestore.collection(userCollection).doc(userModel.uid).set(userModel.toMap());
    } else {
      throw 'Opt invalid!';
    }
    return um;
  }

  Future<UserModel?> loginWithToken({required String token, required Map<String, dynamic> tokenDetails}) async {
    final authCredential = AuthCredential(
      providerId: tokenDetails['iss'],
      signInMethod: 'phone',
    );
    final vId = await _fireAuth.signInWithPhoneNumber(tokenDetails['phone_number']);
    final userCred = await vId.confirm(vId.verificationId);
    UserModel? userModel;
    if (userCred.user != null) {
      userModel = await _firestore.collection(userCollection).doc(userCred.user?.uid).get().then((docSnap) {
        final data = docSnap.data();
        if (data != null) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      });
    }
    return userModel;
  }

  Future<void> logout() async {
    await _fireAuth.signOut();
  }
}
