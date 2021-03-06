import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';

import 'InputDeco_design.dart';
import 'organization_register.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _name, _email, _phone;
  File? _pickedImage;
  //TextController to read text entered in text field
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.teal.shade300),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration(Icons.person, "Full Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                onSaved: (String? name) {
                  _name = name!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration(Icons.email, "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                    return 'Please enter a valid Email';
                  }
                  return null;
                },
                onSaved: (String? email) {
                  _email = email!;
                },
              ),
            ),
            SizedBox(
              height: 60,
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
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen()));
                    }
                  },
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                )),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text("Register as an organization?"),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizationRegister()));
                },
                child: Text(
                  "Click Here",
                  style: TextStyle(color: Colors.teal[200], fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ])
          ],
        ),
      ))),
    );
  }
}
