import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static final userDetailSharedKey = "USER_DETAIL_SHARED_KEY";

  Future<void> saveUserDetail({required BuildContext context, required String token}) async {
    await context.read<SharedPreferences>().setString(userDetailSharedKey, token);
  }

  String? getUserDetail(BuildContext context) {
    return context.read<SharedPreferences>().getString(userDetailSharedKey);
  }

  Future<bool> removeUserDetail(BuildContext context) async {
    return await context.read<SharedPreferences>().remove(userDetailSharedKey);
  }
}
