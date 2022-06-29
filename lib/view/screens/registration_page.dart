import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_animal_rescue/global/global.dart';
import 'package:street_animal_rescue/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
import 'OrganizationRegisterPage.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget{
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register>{
    late String _name,_email,_phone;
    XFile? imgXFile;
    final ImagePicker imagePicker = ImagePicker();
    String downloadUrlImage = "";
    //TextController to read text entered in text field
    TextEditingController passwordTextEditingController = TextEditingController();
    TextEditingController emailTextEditingController = TextEditingController();
    TextEditingController nameTextEditingController = TextEditingController();

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    getImageFromGallery() async{
      imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
      setState((){
        imgXFile;
      });

    }




    formValidation() async
    {
      if (imgXFile == null) {
        Fluttertoast.showToast(msg: "Please select an image.");
      }
      else //image is already selected
          {
        if (nameTextEditingController.text.isNotEmpty &&
            emailTextEditingController.text.isNotEmpty) {
          //upload image to storage
          String fileName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();
          fStorage.Reference storageRef =
          fStorage.FirebaseStorage.instance.ref()
              .child("usersImages")
              .child(fileName);
          fStorage.UploadTask uploadImageTask =
          storageRef.putFile(File(imgXFile!.path));

          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask
              .whenComplete(() {});
          taskSnapshot.ref
              .getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });

          //save the user info to firestore database
          saveInformationToDatabase();
        }
        else
        {
          Fluttertoast.showToast(msg: "Please complete the form.");
        }
      }
    }

    saveInformationToDatabase() async
    {
      //authenticate the user first
      User? currentUser;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
      ).then((auth)
      {
        currentUser = auth.user;
      }).catchError((errorMessage)
    {
      Fluttertoast.showToast(msg: "Error Occurred \n $errorMessage");
    });

      if(currentUser != null)
        {
          //save info to database and save locally using shared preferences
          saveInfoToFirestoreAndLocally(currentUser!);

        }
    }

    saveInfoToFirestoreAndLocally(User currentUser) async
    {
      //save to firestore
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .set(
          {
            "uid": currentUser.uid,
            "email" : currentUser.email,
            "name" : nameTextEditingController.text.trim(),
            "photoUrl" : downloadUrlImage,
            "status" : "approved",
          });
      //save locally
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", currentUser.email!);
        await sharedPreferences!.setString("name", nameTextEditingController.text.trim());
        await sharedPreferences!.setString("photoUrl", downloadUrlImage);

    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors:[
              Colors.blueAccent,
              Colors.blueGrey,
            ],
            begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
          ),
        ),
        title: Text('Registration'),
      centerTitle: true,
      ),



      body: Center
        (
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(

              children: [

                const SizedBox(height: 12,),
                //get-capture image
                GestureDetector(
                  onTap: ()
                      {
                        getImageFromGallery();
                      },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    backgroundColor: Colors.white,
                    backgroundImage: imgXFile == null
                        ? null
                        :FileImage(
                        File(imgXFile!.path)
                  ),
                    child: imgXFile == null ?
                    Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.20,
                    ) : null,
                  ),
                ),

                const SizedBox(height: 40,),
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
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.blueAccent),
                      ) ,
                      )
                    ),
                    onPressed: (){
                      formValidation();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => HomeScreen()));

                      if(_formkey.currentState!.validate())
                      {
                        print("successful");

                        return;
                      }else{
                        print("UnSuccessful");
                      }
                      formValidation();
                    },
                    child: Text("Register"),

                      )
                  ),
                SizedBox(
                  height:30
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Register as an organization?"),
                      GestureDetector(
                        onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => OrganizationRegister()));
                        },
                        child: Text(
                          "Click Here",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),

                    ])

              ],
            ),
          ))
      ),
        );
  }
}



