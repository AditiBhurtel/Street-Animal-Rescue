import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'otp_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "+977";
  TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                child: Image.asset("images/login.jpg"),
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
                margin: EdgeInsets.only(top: 10, right: 10, left: 10),
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
              SizedBox(height: 30,),
                SizedBox(
                  width: 200,
                  height: 40,
                child: ElevatedButton(
                    style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.transparent),
                ) ,
              )
        ),
                  onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) =>
                              OtpPage(
                                phone: _controller.text,
                                codeDigits: dialCodeDigits,
                              )));

                  },
                  child: Text(
                    'Next',

                    style: TextStyle(

                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
