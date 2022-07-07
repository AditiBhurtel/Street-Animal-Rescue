import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:street_animal_rescue/modal/user_model.dart';
import 'package:street_animal_rescue/services/print_services.dart';
import 'package:street_animal_rescue/services/shared_preferences_services.dart';

import '../repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  final _authRepo = AuthRepository();
  final sps = SharedPreferencesServices();
  Future<void> loginOrRegisterUser({required String vId, required String smsCode, required BuildContext context}) async {
    BotToast.showLoading();
    try {
      final userModel = await _authRepo.loginOrRegisterUser(verificationCode: vId, smsCode: smsCode);
      if (userModel != null) {
        if (userModel.token != null) {
          await sps.saveUserDetail(context: context, token: userModel.token!, passKey: userModel.password ?? '');
        }
      }
      emit(AuthState(userModel: userModel));
      BotToast.showText(text: 'Login successful.');
      BotToast.closeAllLoading();
    } catch (e) {
      sPrint('error in login :$e');
      BotToast.showText(text: 'Error in login!');
      BotToast.closeAllLoading();
      emit(AuthState());
    }
  }

  Future<void> loginOrganization({required String email, required String password, required BuildContext context}) async {
    BotToast.showLoading();
    try {
      final userModel = await _authRepo.loginOrganization(email: email, password: password);

      if (userModel != null) {
        if (!userModel.isVerifiedUser) {
          emit(AuthState());
          BotToast.showText(text: 'User not verified !, please contact your service provider.');
          BotToast.closeAllLoading();
        } else {
          if (userModel.token != null) {
            await sps.saveUserDetail(context: context, token: userModel.token!, passKey: userModel.password ?? '');
          }
          emit(AuthState(userModel: userModel));
          BotToast.showText(text: 'Organization Login successful.');
          BotToast.closeAllLoading();
        }
      } else {
        throw 'Your _message';
      }
    } catch (e) {
      sPrint('error in login org :$e');
      BotToast.showText(text: 'Error in login Organization!');
      BotToast.closeAllLoading();
      emit(AuthState());
    }
  }

  Future<void> registerOrganization(
      {required String email, required String password, required String phoneNumber, required String address, required String organizationName, required BuildContext context}) async {
    BotToast.showLoading();
    try {
      await _authRepo.registerOrganization(
        address: address,
        phoneNumber: phoneNumber,
        password: password,
        email: email,
        organizationName: organizationName,
      );
      emit(AuthState(isOrganizationRegister: true));
      BotToast.showText(text: 'Organization registered successfully.');
      BotToast.closeAllLoading();
    } catch (e) {
      sPrint('error in organization register :$e');
      BotToast.showText(text: 'Error in organization register!');
      BotToast.closeAllLoading();
      emit(AuthState());
    }
  }

  Future<void> loginWithToken(BuildContext context) async {
    BotToast.showLoading();
    try {
      final token = sps.getUserDetail(context) ?? [];
      sPrint('token : ${token.length}');

      if (token.isNotEmpty) {
        Map<String, dynamic> payload = Jwt.parseJwt(token[0]);
        sPrint('jswt decoded: $payload');
        if (Jwt.isExpired(token[0])) {
          emit(AuthState());
          BotToast.showText(text: 'Session expired!');
          BotToast.closeAllLoading();
        } else {
          final userModel = await _authRepo.loginWithToken(token: token[0], tokenDetails: payload, passKey: token[1]);
          emit(AuthState(userModel: userModel));
          BotToast.showText(text: 'Login successful.');
          BotToast.closeAllLoading();
        }
      } else {
        emit(AuthState(userModel: state.userModel));
        BotToast.closeAllLoading();
      }
    } catch (e) {
      sPrint('error in login with token :$e');
      // BotToast.showText(text: 'Error in login!');
      BotToast.closeAllLoading();
      emit(AuthState(userModel: state.userModel));
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    BotToast.showLoading();
    try {
      await _authRepo.logout();
      await sps.removeUserDetail(context);
      BotToast.showText(text: 'Logout successful.');
      BotToast.closeAllLoading();
      emit(AuthState());
    } catch (e) {
      sPrint('error in login :$e');
      BotToast.showText(text: 'Error in login!');
      BotToast.closeAllLoading();
      emit(AuthState(userModel: state.userModel));
    }
  }
}

class AuthState {
  final UserModel? userModel;
  final bool isOrganizationRegister;
  AuthState({
    this.userModel,
    this.isOrganizationRegister = false,
  });
}
