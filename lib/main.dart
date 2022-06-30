import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/view/screens/OrganizationRegisterPage.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';
import 'package:street_animal_rescue/view/screens/registration_page.dart';
import 'package:street_animal_rescue/view/screens/splash_screen.dart';

import 'view/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp(
    sp: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.sp}) : super(key: key);
  final SharedPreferences sp;
  get codeDigits => null;

  get phone => null;
  final botToastBuilder = BotToastInit();
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferences>(
          create: (ctx) => sp,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SignIn with Phone Number',
          theme: ThemeData(
            primarySwatch: generateMaterialColor(color: Color(0xFF80CBC4)),
          ),
          home: SplashScreen(),
          builder: (context, child) {
            child = botToastBuilder(context, child);
            return child;
          },
          navigatorObservers: [BotToastNavigatorObserver()],
          routes: {'/login_screen': (context) => LoginScreen(), '/registration_page': (context) => Register(), '/OrganizationRegisterPage': (context) => OrganizationRegister(), '/home_screen': (context) => HomeScreen()},
        ),
      ),
    );
  }
}
