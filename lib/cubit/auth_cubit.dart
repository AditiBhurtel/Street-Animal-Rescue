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
      final userModel = await _authRepo.registerUser(verificationCode: vId, smsCode: smsCode);
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

  Future<void> loginWithToken(BuildContext context) async {
    BotToast.showLoading();
    try {
      final token = sps.getUserDetail(context);
      sPrint('token : $token');

      if (token != null) {
        Map<String, dynamic> payload = Jwt.parseJwt(token[0]);
        sPrint('jswt decoded: $payload');
        final userModel = await _authRepo.loginWithToken(token: token[0], tokenDetails: payload, passKey: token[1]);
        emit(AuthState(userModel: userModel));
        BotToast.showText(text: 'Login successful.');
        BotToast.closeAllLoading();
      } else {
        emit(AuthState(userModel: state.userModel));
        BotToast.closeAllLoading();
      }
    } catch (e) {
      sPrint('error in login :$e');
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
  AuthState({this.userModel});
}
