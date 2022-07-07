import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:street_animal_rescue/enum/user_type_enum.dart';
import 'package:street_animal_rescue/modal/user_model.dart';
import 'package:street_animal_rescue/services/encrypt_decrypt_services.dart';
import 'package:street_animal_rescue/services/print_services.dart';

class AuthRepository {
  final _firestore = FirebaseFirestore.instance;
  final _fireAuth = FirebaseAuth.instance;
  static final userCollection = 'users';

  Future<UserModel?> loginOrRegisterUser({
    required String verificationCode,
    required String smsCode,
  }) async {
    print('verification code: $verificationCode && $smsCode');
    final phoneAuthCred = PhoneAuthProvider.credential(
      verificationId: verificationCode,
      smsCode: smsCode,
    );
    print("phone auth token: ${phoneAuthCred.token}");
    var userCred = await _fireAuth.signInWithCredential(
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

      final existedUserModel = await _firestore.collection(userCollection).doc(userCred.user?.uid).get().then((docSnap) {
        final data = docSnap.data();
        print('existed data : $data');
        if (data != null) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      });
      if (existedUserModel != null) {
        userModel.url = existedUserModel.url;
        userModel.image = existedUserModel.image;
        userModel.email = existedUserModel.email;
        userModel.password = existedUserModel.password;
        userModel.isVerifiedUser = existedUserModel.isVerifiedUser;
        userModel.userType = existedUserModel.userType;
        userModel.name = existedUserModel.name;
        userModel.additionalPhoneNumber = existedUserModel.additionalPhoneNumber;
        userModel.address = existedUserModel.address;
        userModel.createdAt = existedUserModel.createdAt;
        userModel.updatedAt = DateTime.now();
        if (existedUserModel.email == null) {
          final randomPass = randomAlphaNumeric(10);
          print("password : $randomPass");
          final testEmail = '${userCred.user?.phoneNumber}@sar.com';
          if (userCred.user?.email == null) {
            final res = await userCred.user?.linkWithCredential(EmailAuthProvider.credential(
              email: testEmail,
              password: randomPass,
            ));
            if (res != null) {
              userCred = res;
            }
          }
          userModel.password = EncryptDecryptServices().encryptData(randomPass);
          userModel.email = testEmail;
        }
      } else {
        final randomPass = randomAlphaNumeric(10);
        print("password : $randomPass");
        final testEmail = '${userCred.user?.phoneNumber}@sar.com';
        if (userCred.user?.email == null) {
          final res = await userCred.user?.linkWithCredential(EmailAuthProvider.credential(
            email: testEmail,
            password: randomPass,
          ));
          if (res != null) {
            userCred = res;
          }
        }
        userModel.password = EncryptDecryptServices().encryptData(randomPass);
        userModel.email = testEmail;
      }

      print('user model: ${userModel.toMap()}');

      // if (userCred.user?.email == null) {

      um = userModel;
      await _firestore.collection(userCollection).doc(userModel.uid).set(userModel.toMap());
    } else {
      throw 'Opt invalid!';
    }
    return um;
  }

  Future<void> registerOrganization({
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String organizationName,
    /*required String file*/
  }) async {
    final userCred = await _fireAuth.createUserWithEmailAndPassword(email: email, password: password);
    if (userCred.user != null) {
      final nowDate = DateTime.now();
      UserModel userModel = UserModel(
        email: email,
        password: EncryptDecryptServices().encryptData(password),
        name: organizationName,
        phoneNumber: phoneNumber,
        createdAt: nowDate,
        updatedAt: nowDate,
        uid: userCred.user?.uid,
        userType: UserTypeEnum.Organization.index,
        address: address,
      );
      await _firestore.collection(userCollection).doc(userModel.uid).set(userModel.toMap());
    }
  }

  Future<UserModel?> loginOrganization({
    required String email,
    required String password,
    /*required String file*/
  }) async {
    final userCred = await _fireAuth.signInWithEmailAndPassword(email: email, password: password);
    if (userCred.user != null) {
      final existedUserModel = await _firestore.collection(userCollection).doc(userCred.user?.uid).get().then((docSnap) {
        final data = docSnap.data();
        print('existed data : $data');
        if (data != null) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      });
      if (existedUserModel != null) {
        final token = await userCred.user?.getIdToken();
        if (token != null) {
          existedUserModel.token = token;
        }
      }
      return existedUserModel;
    } else {
      return null;
    }
  }

  Future<UserModel?> loginWithToken({required String token, required Map<String, dynamic> tokenDetails, required String passKey}) async {
    sPrint('token details: $tokenDetails && passwowr: ${EncryptDecryptServices().decryptData(passKey)}');
    print('token email :${tokenDetails['email']}');
    UserModel? userModel;
    if (tokenDetails['user_id'] != null) {
      userModel = await _firestore.collection(userCollection).doc(tokenDetails['user_id']).get().then((docSnap) {
        final data = docSnap.data();
        if (data != null) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      });
    }
    if (userModel != null) {
      final authCred = EmailAuthProvider.credential(
        email: userModel.email ?? '',
        password: EncryptDecryptServices().decryptData(passKey),
      );
      // final
      // final vId = await _fireAuth.signInWithPhoneNumber(tokenDetails['phone_number']);
      // final userCred = await vId.confirm(vId.verificationId);
      final userCred = await _fireAuth.signInWithCredential(authCred);
      sPrint('user cred with token: ${userCred.user}');
    }

    return userModel;
  }

  Future<void> logout() async {
    await _fireAuth.signOut();
  }
}
