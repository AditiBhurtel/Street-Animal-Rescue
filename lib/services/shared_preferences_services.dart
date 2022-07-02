import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static final userDetailSharedKey = "USER_DETAIL_SHARED_KEY";
  static final userPassKey = "USER_PASS_KEY";

  Future<void> saveUserDetail({required BuildContext context, required String token, required String passKey}) async {
    await context.read<SharedPreferences>().setString(userDetailSharedKey, token);
    await context.read<SharedPreferences>().setString(userPassKey, passKey);
  }

  List<String>? getUserDetail(BuildContext context) {
    final token = context.read<SharedPreferences>().getString(userDetailSharedKey);
    final passKey = context.read<SharedPreferences>().getString(userPassKey);
    return [token ?? '', passKey ?? ''];
  }

  Future<bool> removeUserDetail(BuildContext context) async {
    return await context.read<SharedPreferences>().remove(userDetailSharedKey);
  }
}
