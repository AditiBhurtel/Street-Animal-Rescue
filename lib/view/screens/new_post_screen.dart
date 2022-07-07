import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/post_cubit.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key, required this.file}) : super(key: key);
  final XFile file;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (ctx, postState) {
        if (postState.isAdded) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.teal,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "New Post",
            style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                await context.read<PostCubit>().sharePost(title: 'Test Title', xFile: file);
              },
              child: Text(
                "Share",
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              FutureBuilder<Uint8List>(
                future: file.readAsBytes(),
                builder: (ctx, imageArray) {
                  if (imageArray.hasData) {
                    if (imageArray.data != null) {
                      return Image.memory(
                        imageArray.data!,
                        height: 200,
                        width: 200,
                        errorBuilder: (b, o, s) {
                          return Container(
                            height: 200,
                            width: 200,
                            color: Colors.red.withOpacity(0.2),
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),

              ///todo place other form here related to post and after adding remove this todo
            ],
          ),
        ),
      ),
    );
  }
}
