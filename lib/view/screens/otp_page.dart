import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/services/print_services.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  final String codeDigits;

  OtpPage({required this.phone, required this.codeDigits});
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.grey,
      ));

  @override
  void initState() {
    verifyPhoneNumber();
    super.initState();
  }

  verifyPhoneNumber() async {
    sPrint('verification phone called : ${widget.codeDigits} , ${widget.phone}');
    BotToast.showLoading();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigits + widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          /*await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => Register()));
          }
        });*/
          BotToast.closeAllLoading();
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
          BotToast.showText(text: 'Opt code successfully sent.');
          setState(() {
            verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          BotToast.closeAllLoading();
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: Duration(seconds: 120),
      );
    } catch (e) {
      BotToast.closeAllLoading();
      sPrint('error in verification call: $e');
    }
  }

  final defaultPinPutTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
    sPrint('dbu9;');
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('OTP Verification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/otp.jpg"),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      verifyPhoneNumber();
                    },
                    child: Text(
                      "Verifying : ${widget.codeDigits}-${widget.phone}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Pinput(
                  length: 6,
                  /*textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,*/
                  defaultPinTheme: defaultPinPutTheme,
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                  focusNode: _pinOTPCodeFocus,
                  controller: _pinOTPCodeController,
                  // submittedFieldDecoration: pinOTPCodeDecoration,
                  // followingFieldDecoration: pinOTPCodeDecoration,
                  pinAnimationType: PinAnimationType.rotation,
                  onCompleted: (pin) async {
                    sPrint('pin : $pin');
                    //Navigator.of(context).push(MaterialPageRoute(builder: (c) => Register()));

                    if (verificationCode == null) {
                      BotToast.showText(text: 'Phone number not verified.');
                      return;
                    }
                    await BlocProvider.of<AuthCubit>(context).loginOrRegisterUser(
                      vId: verificationCode!,
                      smsCode: pin,
                      context: context,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
