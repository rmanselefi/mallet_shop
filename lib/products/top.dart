import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopDetailTop extends StatefulWidget {
  final String? shopName;
  final String? backImg;
  final MainModel? model;

  ShopDetailTop({this.shopName, this.backImg, this.model});

  @override
  _ShopDetailTopState createState() => _ShopDetailTopState();
}

class _ShopDetailTopState extends State<ShopDetailTop> {
  @override
  Widget build(BuildContext context) {
    var name = widget.shopName;
    return Stack(children: <Widget>[
      CachedNetworkImage(
          imageUrl: widget.backImg.toString(),
          imageBuilder: (context, imageProvider) => Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill)),
              ),
          placeholder: (context, url) => Container(
                height: 60,
                width: 60,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          errorWidget: (context, url, error) {
            return Container(
              padding: EdgeInsets.all(10),
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: AssetImage('assets/back.jpg'))),
            );
          }),
      Container(
        height: 200.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff2a2e42).withOpacity(0.7),
        ),
      ),
      Positioned.fill(
        top: 50.0,
        child: Align(
          alignment: Alignment.centerRight,
          child: Center(
            child: Text(
              name.toString(),
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ),
      ),
      ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        if (model.uploadTask != null) {
          return StreamBuilder<TaskSnapshot?>(
              stream: model.uploadTask ,
              builder: (_, snapshot) {

                if (snapshot.data!.state == TaskState.running) {
                  return Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: CircularProgressIndicator(),
                      ));
                }
                if (snapshot.data!.state == TaskState.error) {
//                return Alert(
//                  context: context,
//                  type: AlertType.success,
//                  title: "Message",
//                  desc: "Your Product Card is updated Successfully",
//                  style: AlertStyle(isOverlayTapDismiss: true),
//                  buttons: [
//                    DialogButton(
//                      child: Text(
//                        "OK",
//                        style: TextStyle(color: Colors.white, fontSize: 20),
//                      ),
//                      onPressed: () => Navigator.of(context).pop(),
//                      width: 120,
//                    )
//                  ],
//                ).show();
//                showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return AlertDialog(
//                      title: Text("Success"),
//                      content: Text("Your Product Card is Updated Succesfully"),
//                      actions: [
//                        FlatButton(
//                          child: Text("Cancel"),
//                          onPressed:  () {
//                            Navigator.of(context, rootNavigator: true).pop();
//                          },
//                        ),
//                      ],
//                    );
//                  },
//                );
                }
                return Container();
              });
        }
        if (model.uploadBackTask != null) {
          return StreamBuilder<TaskSnapshot?>(
              stream: model.uploadBackTask,
              builder: (_, snapshot) {
                if (snapshot.data!.state == TaskState.running) {
                  return Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: CircularProgressIndicator(),
                      ));
                } else if (snapshot.data!.state == TaskState.success) {
                  return Container();
                } else {
                  return Container();
                }
              });
        }
        else {
          return Container();
        }
      }),
      Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xff29b6f6),
          ),
          onPressed: () {
            if (Scaffold.of(context).isDrawerOpen) {
              Scaffold.of(context).openDrawer();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
          color: Colors.white,
        ),
      ),
    ]);
  }
}
