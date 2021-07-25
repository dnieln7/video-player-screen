import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player_screen/widget/text_icon_button.dart';

class PictureChooseOnClose extends StatefulWidget {
  @override
  _PictureChooseOnCloseState createState() => _PictureChooseOnCloseState();
}

class _PictureChooseOnCloseState extends State<PictureChooseOnClose> {
  bool working = false;

  @override
  Widget build(BuildContext context) {
    return working
        ? Container(
            height: MediaQuery.of(context).size.height * 0.10,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Loading picture...', style: TextStyle(fontSize: 16)),
              ],
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Text(
                    'Choose a video',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    children: [
                      TextIconButton(
                        icon: Icons.camera_sharp,
                        label: 'Camera',
                        action: openCamera,
                      ),
                      TextIconButton(
                        icon: Icons.photo_library_sharp,
                        label: 'Gallery',
                        action: openGallery,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> openGallery() async {
    final pickerFile = await ImagePicker().getVideo(
      source: ImageSource.gallery,
    );

    if (pickerFile != null) {
      finish(File(pickerFile.path));
    }
  }

  Future<void> openCamera() async {
    final pickerFile = await ImagePicker().getVideo(
      source: ImageSource.camera,
    );

    if (pickerFile != null) {
      finish(File(pickerFile.path));
    }
  }

  void finish(File picture) async {
    setState(() => working = true);

    if (picture != null) {
      Navigator.of(context).pop(picture);
    }
  }
}
