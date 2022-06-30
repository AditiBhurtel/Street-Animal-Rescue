import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/view/screens/login_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      context.read<AuthCubit>().loginWithToken(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.userModel != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => HomeScreen()),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: Text('Splash loading...'),
            ),
          ),
        ),
      ),
    );
  }
}
