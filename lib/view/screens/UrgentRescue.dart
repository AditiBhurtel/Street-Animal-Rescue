import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_animal_rescue/modal/user_model.dart';

class UrgentRescue extends StatefulWidget {
  final UserModel gCurrentUser;
  UrgentRescue({required this.gCurrentUser});

  @override
  _UrgentRescueState createState() => _UrgentRescueState();
}

class _UrgentRescueState extends State<UrgentRescue> {
  XFile? file;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );

    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Post",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Capture Image with Camera",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Capture Image with Gallery",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  displayUploadScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: new Text(
                "Upload image",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.teal.shade200,
              onPressed: () => takeImage(context),
            ),
          ),
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country}, '; //to get
    locationTextEditingController.text = completeAddressInfo;
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: removeImage),
        title: Text(
          "New Post",
          style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => print("tapped"),
            child: Text(
              "Share",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  child: Image.file(
                    File(file!.path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.gCurrentUser.url!,
              ),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Say something about the image",
                  hintStyle: TextStyle(color: Colors.blue),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 36.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Write the location here",
                  hintStyle: TextStyle(color: Colors.blue),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 220.0,
            height: 110.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
              label: Text(
                "Get my Current Location",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: getUserCurrentLocation,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
