import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: InitializerWidget(),
      routes: {
        '/login_screen' :(context)=>LoginScreen(),
        '/registration_page' :(context)=>Register(),
        '/OrganizationRegisterPage' :(context)=>OrganizationRegister(),
        '/home_screen' : (context)=>HomeScreen()
      },
    );
  }
}
class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {

  late FirebaseAuth _auth;

  late User _user;

  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser!;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    // ignore: unnecessary_null_comparison
    ) : _user == null ? LoginScreen() : HomeScreen();
  }
}
