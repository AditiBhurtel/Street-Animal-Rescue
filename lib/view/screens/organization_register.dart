import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';

import 'InputDeco_design.dart';

class OrganizationRegister extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<OrganizationRegister> {
  late String _name, _email, _phone;

  //TextController to read text entered in text field
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _organizationNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.isOrganizationRegister) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _organizationNameController,
                      decoration: buildInputDecoration(Icons.person, "Organization Name"),
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: buildInputDecoration(Icons.email, "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        } else {
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        }
                      },
                      onSaved: (String? email) {
                        _email = email!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: buildInputDecoration(Icons.person, "Phone Number"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        /*if(value.length == 10 ){
                          return 'Phone number must be of length 10';
                        }*/
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
                      controller: _addressController,
                      decoration: buildInputDecoration(Icons.person, "Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        /*if(value.length == 10 ){
                          return 'Phone number must be of length 10';
                        }*/
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: buildInputDecoration(Icons.key, "Confirm Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        } else {
                          if (value != _passwordController.text) {
                            return 'Doesn\'t match with password.';
                          }
                          return null;
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
                            final oName = _organizationNameController.text;
                            final email = _emailController.text;
                            final phoneNumber = _phoneNumberController.text;
                            final address = _addressController.text;
                            final password = _passwordController.text;
                            await context.read<AuthCubit>().registerOrganization(
                                  email: email,
                                  password: password,
                                  phoneNumber: phoneNumber,
                                  address: address,
                                  organizationName: oName,
                                  context: context,
                                );
                          }
                        },
                        child: Text("Register", style: TextStyle(color: Colors.white)),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
