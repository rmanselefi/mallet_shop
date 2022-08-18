import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mallet_shop/shared/image.dart';
import 'package:mallet_shop/widgets/remaining_credit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mallet_shop/widgets/contact_us.dart';
import 'package:mallet_shop/auth/SignIn.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrawerCustom extends StatefulWidget {
  final MainModel model;

  DrawerCustom(this.model);

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  _launchURL(var url) async {
//    const url = 'https://t.me/No_one47';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.getShopCredit(widget.model.shopId);
  }

  File? _image;

  void _setImage(File image) {
    _image = image;
    print("_formData_formData_formData$_image");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imageMessage = '';

  void _showSettingsPanel() {
    showModalBottomSheet(
        elevation: 10.0,
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Update your background image',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ImageInput(_setImage),
                  Text(
                    imageMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
//                  ScopedModelDescendant<MainModel>(builder:
//                      (BuildContext context, Widget child, MainModel model) {
//                    if (model.uploadBackTask != null) {
//                      return StreamBuilder<StorageTaskEvent>(
//                          stream: model.uploadBackTask.events,
//                          builder: (_, snapshot) {
//                            if (model.uploadBackTask.isInProgress) {
//                              return Center(child: CircularProgressIndicator());
//                            } else if (model.uploadBackTask.isComplete) {
//                              return Container();
//                            } else {
//                              return Container();
//                            }
//                          });
//                    }
//                    return Container();
//                  }),
                  MaterialButton(
                    height: 40.0,
                    minWidth: 300.0,
                    child: Text('Update'),
                    color: Colors.pink[400],
                    onPressed: () async {
                      print("_image_image_image_image $_image");
                      if (_image == null) {
                        Fluttertoast.showToast(
                            msg:
                            "Please select an image,Image is required",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (_image != null) {
                        Navigator.pop(context);
                        var res = await widget.model
                            .updateShopBack(widget.model.shopId, _image as File);

                        if (res != true) {
                          Fluttertoast.showToast(
                              msg: "Something is wrong",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          await widget.model.getShopBackGround(widget.model.shopId);
                          Fluttertoast.showToast(
                              msg:"Your Background Image is updated Succesfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.model.shopName),
            backgroundColor: const Color(0xff29b6f6).withOpacity(0.9),
          ),
          Container(
            height: 10.0,
            color: const Color(0xff29b6f6).withOpacity(0.9),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0xff2a2e42),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.inbox,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUs()),
                    );
                  },
                ),
                ScopedModelDescendant<MainModel>(builder:
                    (BuildContext context, Widget child, MainModel model) {
                  return ListTile(
                    trailing: model.remaining != null && model.remaining <= 10
                        ? Container(
                      padding:const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(200),
                        ),
                        color: Colors.red,
                      ),
                          child: Text(
                              model.remaining<=0?'0':model.remaining.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                        )
                        : const Text(""),
                    leading: Icon(Icons.credit_card,
                        color: const Color(0xff29b6f6).withOpacity(0.9)),
                    title: const Text(
                      'Credit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RemainingCredit(
                                widget.model, widget.model.shopId)),
                      );
                    },
                  );
                }),
                ListTile(
                  leading: Icon(Icons.star,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title: const Text('Rate Us', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _launchURL("https://play.google.com/store/apps/details?id=com.qemer.mallet_shop");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title:
                      const Text('Share App', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.qemer.mallet_shop');
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.people,
                //       color: Color(0xff29b6f6).withOpacity(0.9)),
                //   title: Text('Join Us',
                //       style: TextStyle(color: Colors.white)),
                //   onTap: () {
                //     _launchURL("https://t.me/MallEtClients");
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.send,
                //       color: Color(0xff29b6f6).withOpacity(0.9)),
                //   title: Text('Quick Support',
                //       style: TextStyle(color: Colors.white)),
                //   onTap: () {
                //     _launchURL("https://t.me/MallETclientSupport");
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.update,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title: const Text('Update', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _launchURL("https://play.google.com/store/apps/details?id=com.qemer.mallet_shop");
                  },
                ),
                Divider(
                  color: const Color(0xff29b6f6).withOpacity(0.9),
                ),
                ListTile(
                  leading: Icon(Icons.person,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title: const Text('Change Password',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushNamed(context, '/change');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image,
                      color: const Color(0xff29b6f6).withOpacity(0.9)),
                  title: const Text('Change Background Image',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
//                  Navigator.pushNamed(context, '/changeImage');
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => ChangeBackground(
//                              widget.model, widget.model.shopId)),
//                    );
                    _showSettingsPanel();
                  },
                ),
                Divider(
                  color: const Color(0xff29b6f6).withOpacity(0.9),
                ),
                ScopedModelDescendant(
                  builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: const Color(0xff29b6f6).withOpacity(0.9),
                      ),
                      title:
                          const Text('Logout', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        model.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
