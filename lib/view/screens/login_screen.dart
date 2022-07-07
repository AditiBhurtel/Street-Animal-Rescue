import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';

import '../../services/print_services.dart';
import 'otp_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "+977";
  TextEditingController _controller = TextEditingController();

  verifyPhoneNumber() async {
    sPrint('verification phone called : ${dialCodeDigits} , ${_controller.text}');
    BotToast.showLoading();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${dialCodeDigits + _controller.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          /*await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => Register()));
          }
        });*/
          sPrint('credential: $credential');
        },
        verificationFailed: (FirebaseAuthException e) {
          sPrint('verifif cati: ${e.message}');
          BotToast.closeAllLoading();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
              duration: Duration(seconds: 3),
            ),
          );
        },
        codeSent: (String vID, int? resendToken) {
          sPrint('cocde sendg: $vID');
          BotToast.closeAllLoading();
          BotToast.showText(text: 'Opt code send successfully.');
          setState(() {
            // verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          BotToast.closeAllLoading();
          setState(() {
            // verificationCode = vID;
          });
        },
        timeout: Duration(seconds: 120),
      );
    } catch (e) {
      BotToast.closeAllLoading();
      sPrint('error in verification call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.userModel != null) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => HomeScreen()),
            (route) => false,
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: Image.asset("images/login.png"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "OTP Authentication",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        dialCodeDigits = country.dialCode!;
                      });
                    },
                    initialSelection: "NP",
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    favorite: ["+977", "NP"],
                    enabled: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dialCodeDigits,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    )),
                    onPressed: () async {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (c) {
                            return OtpPage(
                              phone: _controller.text,
                              codeDigits: dialCodeDigits,
                            );
                          },
                        ),
                      );
                      // await verifyPhoneNumber();
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
