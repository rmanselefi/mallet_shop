import 'package:flutter/material.dart';
import 'package:mallet_shop/models/product.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeBackground extends StatefulWidget {
  final MainModel model;
  final String id;
  ChangeBackground(this.model, this.id);

  @override
  _ChangeBackgroundState createState() => _ChangeBackgroundState();
}

class _ChangeBackgroundState extends State<ChangeBackground> {
  XFile? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.idwidget.idwidget.id ${widget.id}");
    widget.model.getShopBackGround(widget.id);
  }

  final Product _formData = Product(
      Id: '', productName: '', productPrice: '', productImage: '', file: null);

  void _setImage(XFile? image) {
    setState(() {
      _formData.file = image;
    });
  }

  Future getImage(BuildContext context, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source, maxWidth: 400.0);
    print("imageimageimageimage$image");
    setState(() {
      _image = image;
    });
    print("imageimageimageimage$image");
    _setImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2a2e42),
        title: Text('Change your background image'),
        actions: <Widget>[
          _image != null
              ? ScopedModelDescendant<MainModel>(builder:
                  (BuildContext context, Widget child, MainModel model) {
                  if (model.uploadTask != null) {
                    return StreamBuilder<TaskSnapshot?>(
                        stream: model.uploadBackTask,
                        builder: (_, snapshot) {
                          var event = snapshot.data;
                          double progressPercent = event != null
                              ? event.bytesTransferred / event.totalBytes
                              : 0;
                          if (event!.state == TaskState.running) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return MaterialButton(
                              height: 30.0,
                              minWidth: 50.0,
                              color: Color(0xff29b6f6),
                              splashColor: Colors.teal,
                              textColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              onPressed: () async {});
                        });
                  } else {
                    return MaterialButton(
                        height: 30.0,
                        minWidth: 50.0,
                        color: Color(0xff29b6f6),
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          widget.model
                              .updateShopBack(widget.id, _image as File);

                          Fluttertoast.showToast(
                              msg:
                                  "Your Background Image is changed Succesfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                  }
                })
              : Container()
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return ListView(
          children: <Widget>[
            FutureBuilder(
                future: model.getShopBackGround(model.shopId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data == "") {
                      return  Card(
                          elevation: 5.0,
                          child:  Container(
                              height:
                                  2 * MediaQuery.of(context).size.height / 3,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  top: 0.0, bottom: 25.0, left: 0.0),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 50.0,
                                    ),
                                  ),
                                  _image != null
                                      ? Image.file(
                                          _image as File,
                                          fit: BoxFit.fill,
                                          height: 500.0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.topCenter,
                                        )
                                      : Container(),
                                ],
                              )));
                    }
                    return new Card(
                        elevation: 5.0,
                        child: new Container(
                          height: 2 * MediaQuery.of(context).size.height / 3,
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.only(
                              top: 0.0, bottom: 25.0, left: 0.0),
                          child: Stack(children: <Widget>[
                            FadeInImage.memoryNetwork(
                              fit: BoxFit.fill,
                              placeholder: kTransparentImage,
                              image: model.shopImage,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 30.0,
                            ),
                            _image != null
                                ? Image.file(
                                    _image as File,
                                    fit: BoxFit.fill,
                                    height: 500.0,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.topCenter,
                                  )
                                : Container(),
                          ]),
                        ));
                  }
                }),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: RaisedButton(
                child: Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white),
                ),
                color: Color(0xff29b6f6),
                onPressed: () {
                  _openImagePicker(context);
                },
              ),
            )
          ],
        );
      }),
    );
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
                Divider(),
                _image == null ? Text('Please Pick an image') : Container(),
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
}
