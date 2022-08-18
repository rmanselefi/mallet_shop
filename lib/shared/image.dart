import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function setImage;
  ImageInput(this.setImage);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  XFile? _image;
  Future getImage(BuildContext context, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source, maxWidth: 400.0);

    setState(() {
      _image = image;
    });
    print("imageimageimageimage $image");
    widget.setImage(image);
    Navigator.of(context).pop();
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            height: 250.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                FlatButton(
                  child: Text('Use Gallery'),
                  onPressed: () {
                    getImage(context, ImageSource.gallery);
                  },
                  textColor: Colors.black45,
                ),
                FlatButton(
                  child: Text('Use Camera'),
                  onPressed: () {
                    getImage(context, ImageSource.camera);
                  },
                  textColor: Colors.black45,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        OutlinedButton(
          style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.0,
                  style: BorderStyle.solid))),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              Text(
                'Add Image',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
        _image == null
            ? Text('Please Pick an image')
            : Image.file(
                _image as File,
                fit: BoxFit.cover,
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              )
      ],
    );
  }
}
