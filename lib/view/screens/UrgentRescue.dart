import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UrgentRescue extends StatefulWidget {
  @override
  _UrgentRescueState createState() => _UrgentRescueState();
}

class _UrgentRescueState extends State<UrgentRescue> {
  XFile? file;
  final ImagePicker _picker = ImagePicker();
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
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
            onPressed: () => {},
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
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
