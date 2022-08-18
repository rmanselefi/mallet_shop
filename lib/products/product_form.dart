
import 'dart:io';
import 'package:mallet_shop/models/product.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:mallet_shop/shared/image.dart';
import 'package:mallet_shop/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProductForm extends StatefulWidget {
  final id;
  final  name;

  final  price;
  final  image;
  final description;
  ProductForm(this.id,this.name,this.price,this.image,this.description);
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String? prodid;
  String imageMessage='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Product _formData=Product(
      Id: '',
      productName: '',
      productPrice: '',
      productImage: '',
      productDescription: '',
      file: null
  );
  void _setImage(XFile? image) {
    _formData.file = image;
    print("_formData_formData_formData${_formData.file}");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prodid=widget.id;
    _formData.Id = prodid;
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding:  const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: widget.name,
                    decoration: InputDecoration(labelText: 'Product/Service Name'),
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                    val!.isEmpty ? 'Please Enter a name' : null,
                    onSaved: (val) {
                      setState(() {
                        _formData.productName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: widget.price,
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    onSaved: (val) {
                      setState(() {
                        _formData.productPrice = val;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    initialValue: widget.description,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (val) {
                      setState(() {
                        _formData.productDescription = val;
                      });
                    },
                  ),

                  ImageInput(_setImage),
                  Text(imageMessage,style: TextStyle(color:Colors.red),),
                  SizedBox(height: 5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Update'),
                        color: Colors.pink[400],
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            if(widget.image!='' || _formData.file!=null){
                              Navigator.pop(context);
                              var res =await model.updateProduct(_formData);
                              if (res is String) {
                                await model.fetchProducts();
                                Fluttertoast.showToast(
                                    msg: "Something is wrong",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "Your Product Card is updated Succesfully",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }

                            }
                           else{
                              setState(() {
                                imageMessage='Please select an image, Image is required';
                              });
                            }
                          }
                        },
                      ),
                      widget.name!=''?RaisedButton(
                        child: Icon(Icons.delete_forever),
                        color: Colors.red[400],
                        onPressed: () async {
                          Widget cancelButton = FlatButton(
                            child: Text("Cancel"),
                            onPressed:  () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          );
                          Widget continueButton = FlatButton(
                            child: Text("Continue"),
                            onPressed:  () {
                              model.deleteProduct(_formData);
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: "Your Product Card is deleted Succesfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Confirm Delete"),
                            content: Text("Are you sure you want to delete this product?"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text("Are you sure you want to delete this product?"),
                                actions: [
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed:  () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Continue"),
                                      onPressed:  () {
                                        model.deleteProduct(_formData);
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Your Product Card is deleted Succesfully",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    )
                                ],
                              );;
                            },
                          );
                        },
                      ):Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

    });


  }

  }

