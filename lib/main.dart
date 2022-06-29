import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:street_animal_rescue/view/screens/OrganizationRegisterPage.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';
import 'package:street_animal_rescue/view/screens/otp_page.dart';
import 'package:street_animal_rescue/view/screens/registration_page.dart';

import 'view/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get codeDigits => null;

  get phone => null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignIn with Phone Number',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFF80CBC4)),
      ),
      home: LoginScreen(),
      routes: {
        '/login_screen' :(context)=>LoginScreen(),
        '/registration_page' :(context)=>Register(),
        '/OrganizationRegisterPage' :(context)=>OrganizationRegister(),
        '/home_screen' : (context)=>HomeScreen()
      },
    );
  }
}

