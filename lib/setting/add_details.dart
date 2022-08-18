import 'package:flutter/material.dart';
import 'package:mallet_shop/models/shop.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class AddDetail extends StatefulWidget {
  @override
  _AddDetailState createState() => _AddDetailState();
}

class _AddDetailState extends State<AddDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Shop _formData= Shop(
    shopPhone: '',
    shopDescription: '',
    shopWebsite: ''
  );
  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model)
        {
          return MaterialButton(
            height: 50.0,
            minWidth: 350.0,
            color: Color(0xff29b6f6),
            splashColor: Colors.teal,
            textColor: Colors.white,
            child: new Text('Save'),
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                var result = await model.updateShopDetailInfo(_formData);
                if (result is String) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Could not save your data'),
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
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Your data is succesfully saved'),
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
              }
            },
          );
        }

    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          var shopp=model.shop;
      return Expanded(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                  Text(
                  'Add Details',
                  style: TextStyle(
                      fontSize: 18.0,
                    color: Colors.white
                  ),
                ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    initialValue: shopp!.shopPhone,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color:Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                    onSaved: (val) {
                      setState(() {
                        _formData.shopPhone = val;
                      });
                    },
                  ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.white
                      ),
                      initialValue: shopp.shopWebsite,
                      decoration: InputDecoration(
                          labelText: 'Website',
                          labelStyle: TextStyle(color:Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      onSaved: (val) {
                        setState(() {
                          _formData.shopWebsite = val;
                        });
                      },
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: shopp.shopDescription,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color:Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                    onSaved: (val) {
                      setState(() {
                        _formData.shopDescription = val;
                      });
                    },
                  ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildSubmitButton()
                  ]
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
