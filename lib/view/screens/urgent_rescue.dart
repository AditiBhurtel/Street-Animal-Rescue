import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_animal_rescue/view/screens/new_post_screen.dart';

class UrgentRescue extends StatefulWidget {
  @override
  _UrgentRescueState createState() => _UrgentRescueState();
}

class _UrgentRescueState extends State<UrgentRescue> {
  final ImagePicker _picker = ImagePicker();

  captureImageWithCamera() async {
    Navigator.pop(context);
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );

    if (imageFile != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (ctx) => NewPostScreen(file: imageFile),
        ),
      );
    } else {
      BotToast.showText(text: 'Image is required.');
    }
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    if (imageFile != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (ctx) => NewPostScreen(file: imageFile),
        ),
      );
    } else {
      BotToast.showText(text: 'Image is required.');
    }
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

  @override
  Widget build(BuildContext context) {
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
}
