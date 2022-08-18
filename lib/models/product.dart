import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Product{
  String? Id;
  String? productName;
  String? productPrice;
  String? cardPlace;
  String? productImage;
  String? productDescription;
  String? backgroundImage;

  bool? isNormal;
  XFile? file;
  Product({this.isNormal,this.productPrice,this.productName,this.productImage,this.Id,this.cardPlace,this.file,this.productDescription,this.backgroundImage});

}