import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
class Register extends StatefulWidget{
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register>{
    late String _name,_email,_phone;

    //TextController to read text entered in text field
    TextEditingController _password = TextEditingController();
    TextEditingController _confirmpassword = TextEditingController();

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration'),),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image.network("https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png"),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:15,left: 10,right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person,"Full Name"),
                    validator: (value){
                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    onSaved: (String? name){
                      _name = name!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:buildInputDecoration(Icons.email,"Email"),
                    validator: (value){
                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter Email';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: ( String? email){
                      _email = email!;
                    },
                  ),
                ),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => HomeScreen()));

                      if(_formkey.currentState!.validate())
                      {
                        print("successful");

                        return;
                      }else{
                        print("UnSuccessfull");
                      }
                    },

                    child: Text("Submit"),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


