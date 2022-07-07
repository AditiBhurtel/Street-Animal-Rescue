import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/services/print_services.dart';

import 'InputDeco_design.dart';
import 'home_screen.dart';
import 'organization_register.dart';

class OrganizationLogin extends StatefulWidget {
  @override
  _OrganizationLoginState createState() => _OrganizationLoginState();
}

class _OrganizationLoginState extends State<OrganizationLogin> {
  late String _name, _email, _phone;

  //TextController to read text entered in text field
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.userModel != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => HomeScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Organization Login',
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
                      controller: _emailController,
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: buildInputDecoration(Icons.key, "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
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
                      onPressed: () async {
                        _formkey.currentState!.save();
                        if (_formkey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          sPrint('pass: $password && email: $email');
                          await context.read<AuthCubit>().loginOrganization(
                                email: email,
                                password: password,
                                context: context,
                              );
                          // Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen()));
                        }
                      },
                      child: Text("Login", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (ctx) => OrganizationRegister(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
