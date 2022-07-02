import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:street_animal_rescue/modal/user_model.dart';
import 'package:street_animal_rescue/services/encrypt_decrypt_services.dart';
import 'package:street_animal_rescue/services/print_services.dart';

class AuthRepository {
  final _firestore = FirebaseFirestore.instance;
  final _fireAuth = FirebaseAuth.instance;
  static final userCollection = 'users';

  Future<UserModel?> registerUser({
    required String verificationCode,
    required String smsCode,
  }) async {
    print('verification code: $verificationCode && $smsCode');
    final phoneAuthCred = PhoneAuthProvider.credential(
      verificationId: verificationCode,
      smsCode: smsCode,
    );
    print("phone auth token: ${phoneAuthCred.token}");
    final userCred = await _fireAuth.signInWithCredential(
      phoneAuthCred,
    );
    UserModel? um;
    if (userCred.user != null) {
      final token = await userCred.user!.getIdToken();
      sPrint('user phone number: ${userCred.user?.phoneNumber}');
      sPrint('user method: ${userCred.credential?.signInMethod}');
      final userModel = UserModel(
        phoneNumber: userCred.user?.phoneNumber,
        uid: userCred.user?.uid,
        token: token,
      );

      if (userCred.user?.email == null) {
        final randomPass = randomAlphaNumeric(10);
        final testEmail = '${userCred.user?.phoneNumber}@sar.com';
        await userCred.user?.linkWithCredential(EmailAuthProvider.credential(
          email: testEmail,
          password: randomPass,
        ));
        userModel.password = EncryptDecryptServices().encryptData(randomPass);
        userModel.email = testEmail;
      }

      um = userModel;
      await _firestore.collection(userCollection).doc(userModel.uid).set(userModel.toMap());
    } else {
      throw 'Opt invalid!';
    }
    return um;
  }

  Future<UserModel?> loginWithToken({required String token, required Map<String, dynamic> tokenDetails, required String passKey}) async {
    sPrint('token details: $tokenDetails');
    final authCred = EmailAuthProvider.credential(
      email: tokenDetails['email'],
      password: EncryptDecryptServices().decryptData(passKey),
    );
    // final
    // final vId = await _fireAuth.signInWithPhoneNumber(tokenDetails['phone_number']);
    // final userCred = await vId.confirm(vId.verificationId);
    final userCred = await _fireAuth.signInWithCredential(authCred);
    sPrint('user cred with token: ${userCred.user}');
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
