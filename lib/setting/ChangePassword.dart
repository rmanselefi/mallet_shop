import 'package:flutter/material.dart';
import 'package:mallet_shop/setting/password_form.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _saving = false;
  String password='';
  String oldPassword='';
  String confirmPassword='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
//        resizeToAvoidBottomInset: true,
        body: ConnectivityWidgetWrapper(
          message: 'Connecting......',
          disableInteraction: true,
          child: ModalProgressHUD(
            inAsyncCall: _saving,
            child: Stack(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage('assets/background.jpg'),
                              fit: BoxFit.fill,
                            alignment:Alignment.topCenter,

                          )
                      ),
//                  padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 100.0),
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return SingleChildScrollView(
                    child: Stack(
                      children:<Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal:5.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: 'Enter your old password',
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        labelStyle: TextStyle(
                                            color:Colors.white
                                        )),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (val) =>
                                    val!.isEmpty ? 'Please Enter Old Password' : null,
                                    onSaved: (val){
                                      print("valvalvalvalval $val");
                                      setState(() {
                                        oldPassword=val.toString();
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: 'Enter your new password',
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        labelStyle: TextStyle(
                                            color:Colors.white
                                        )),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (val) =>
                                    val!.isEmpty ? 'Please Enter your new Password' : null,
                                    onSaved: (val){
                                      print("valvalvalvalval $val");
                                      setState(() {
                                        password=val.toString();
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        labelText: 'Confirm password',
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        ),
                                        labelStyle: TextStyle(
                                            color:Colors.white
                                        )),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (val) =>
                                    val!.isEmpty ? 'Please Confirm your password' : null,
                                    onSaved: (val){
                                      print("valvalvalvalval $val");
                                      setState(() {
                                        confirmPassword=val.toString();
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  MaterialButton(
                                    height: 50.0,
                                    minWidth: 350.0,
                                    child: Text('Change Password',style: TextStyle(color: Colors.white),),
                                    color: Color(0xff29b6f6),
                                    onPressed: () async {
                                      _formKey.currentState!.save();
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _saving = true;
                                        });
                                        final SharedPreferences prefs = await SharedPreferences
                                            .getInstance();
                                        var oldPass = prefs.getString('password');
                                        if (confirmPassword != password) {
                                          setState(() {
                                            _saving = false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'Please confirm your password'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Okay'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                        else if (oldPassword != oldPass) {
                                          setState(() {
                                            _saving = false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'Please enter a correct old password'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Okay'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                        else {
                                          var user =  FirebaseAuth.instance.currentUser;

                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          var email=prefs.getString('email');
                                          var passwordin=prefs.getString('password');
                                          AuthCredential credential = EmailAuthProvider.credential(email: email.toString(), password: passwordin.toString());
                                          user!.reauthenticateWithCredential(credential).then((value){
                                            user.updatePassword(password).then((res) {
                                              setState(() {
                                                _saving = false;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          'Password is Changed successfully'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('Okay'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }).catchError((err) {
                                              setState(() {
                                                _saving = false;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(err.toString()),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('Okay'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            });
                                          });

                                        }
                                      }
                                    },
                                  )
                                ],
                              )
                          ),
                        ),],
                    ),
                  );
                })

                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Color(0xff29b6f6),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
