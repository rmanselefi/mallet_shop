import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PasswordEmailSend extends StatefulWidget {
  @override
  _PasswordEmailSendState createState() => _PasswordEmailSendState();
}

class _PasswordEmailSendState extends State<PasswordEmailSend> {
  bool _saving = false;
  String email='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: ConnectivityWidgetWrapper(
        message: 'Connecting......',
        disableInteraction: true,
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height:  MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExactAssetImage('assets/background.png'),
                            fit: BoxFit.fill,
                          alignment:Alignment.topCenter,
                        )
                    ),
                    child: Column(
                      children:<Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height/2,),

                        Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        labelText: 'Enter your Email',
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
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      if(val!.isEmpty){
                                        return 'Please Enter Email';
                                      }
                                    },
                                    onSaved: (val){
                                      setState(() {
                                        email=val.toString();
                                      });
                                    },
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  MaterialButton(
                                    height: 40.0,
                                    minWidth: 350.0,
                                    color: Color(0xff29b6f6),
                                    splashColor: Colors.teal,
                                    textColor: Colors.white,
                                    child: Text('Send',style: TextStyle(color: Colors.white),),
                                    onPressed: () async {
                                      _formKey.currentState!.save();
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _saving = true;
                                        });
                                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((res){
                                          setState(() {
                                            _saving = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Password Reset Link is sent to your email,Please check your email",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
//                                      Navigator.of(context).pop();
                                        }).catchError((Object error){
                                          if(error is PlatformException){
                                            setState(() {
                                              _saving = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: error.message.toString(),
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }
                                          else{
                                            setState(() {
                                              _saving = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: error.toString(),
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }

                                        });
                                      }

                                      },
                                  )
                                ],
                              )
                          ),
                        ),],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Reset Link has been sent to your email'));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
