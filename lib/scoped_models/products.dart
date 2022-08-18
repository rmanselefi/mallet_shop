import 'dart:async';
import 'dart:io';
import 'package:mallet_shop/models/shop.dart';
import 'package:path/path.dart';
import 'package:mallet_shop/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'connected_models.dart';

mixin ProductModel on ConnectedModels {
  bool isFinished = false;
  Stream<TaskSnapshot?>? uploadTask;
  Stream<TaskSnapshot?>? uploadBackTask;
  StreamSubscription<TaskSnapshot?>? streamSubscription;
  double? progress;

  Future<List<Product>?> fetchProducts() async {
    userProducts.clear();
    specialProducts.clear();
    isLoading = true;
    try {
      Shop? shop = await getAuthenticatedShop();

      if (shop != null) {
        shopName = shop.shopName.toString();
        shopCategory = shop.shopCategory.toString();
        shopId = shop.Id.toString();
      }
      var products =
          await FirebaseFirestore.instance.collection('product').get();
      if (shopId != '') {
        var product = products.docs
            .where((sh) => sh.data()['shop']['id'] == shopId)
            .toList();

        for (var i = 0; i < product.length; i++) {
          var data = product[i].data();
          final Product prod = Product(
            Id: product[i].id,
            cardPlace: data.containsKey('card_place') ? data['card_place'] : '',
            productName:
                data.containsKey('product_name') ? data['product_name'] : '',
            productPrice:
                data.containsKey('product_price') ? data['product_price'] : '',
            productDescription: data.containsKey('product_description')
                ? data['product_description']
                : '',
            productImage: data.containsKey('image') ? data['image'] : '',
            isNormal: data.containsKey('isNormal') ? data['isNormal'] : '',
          );
          var isNormal = data.containsKey('isNormal') ? data['isNormal'] : '';
          if (isNormal) {
            userProducts.add(prod);
          } else {
            specialProducts.add(prod);
          }
        }
        isLoading = false;
        notifyListeners();
      }

      return userProducts;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print("errorerrorerrorerrorerrorerror $error");
    }
  }

  Future<String> uploadImage(Product prod, {String? path}) async {
    String fileName = basename(prod.file!.path);
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("${prod.productName}_images/$fileName");

    uploadTask = storageReference.putFile(prod.file as File).snapshotEvents;
    streamSubscription = uploadTask!.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event}');
    });

    notifyListeners();

// Cancel your subscription when done.
    var imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  Future updateProduct(Product prod) async {
    if (prod.file != null) {
      if (prod.productImage != '') {
        await deleteImage(prod.productImage.toString());
      }
      await uploadImage(prod).then((res) {
        print('imageuriimageuriimageuri$res');
        if (res != null) {
          prod.productImage = res;
        }
      });
      try {
        FirebaseFirestore.instance.collection('product').doc(prod.Id).update({
          'product_name': prod.productName,
          'product_price': prod.productPrice,
          'product_description': prod.productDescription,
          'image': prod.productImage,
          'updated_at': new DateTime.now()
        }).whenComplete((fetchProducts));
        notifyListeners();
        return true;
      } catch (e) {
        notifyListeners();
        return e.toString();
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('product')
            .doc(prod.Id)
            .update({
          'product_name': prod.productName,
          'product_price': prod.productPrice,
          'product_description': prod.productDescription,
          'updated_at': new DateTime.now()
        });
        notifyListeners();
        return true;
      } catch (e) {
        notifyListeners();
        return e.toString();
      }
    }
  }

  Future updateShopDetailInfo(Shop? shop) async {
    Shop? shopp = await getAuthenticatedShop();
    try {
      await FirebaseFirestore.instance
          .collection('shop')
          .doc(shopp!.Id.toString())
          .update({
        'phone': shop!.shopPhone.toString(),
        'shop_website': shop.shopWebsite,
        'description': shop.shopDescription,
        'updated_at': new DateTime.now()
      }).whenComplete((getAuthenticatedShop));
      notifyListeners();
      return true;
    } catch (e) {
      print("updateupdate ${e.toString()}");
      notifyListeners();
      return e.toString();
    }
  }

  Future<Null> deleteProduct(Product prod) async {
    FirebaseFirestore.instance.collection('product').doc(prod.Id).update({
      'product_name': '',
      'product_price': '',
      'product_description': '',
      'contact': '',
      'image': '',
      'updated_at': new DateTime.now()
    }).whenComplete((fetchProducts));
    notifyListeners();
  }

  Future<String> getShopBackGround(String id) async {
    try {
      var docs = await FirebaseFirestore.instance.collection('shop').get();
      if (docs.docs.isNotEmpty) {
        var doc = docs.docs.where((d) => d.id == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data();
          shopImage =
              docdata.containsKey('back_image') ? docdata['back_image'] : '';
        }
      }
      return shopImage;
    } catch (err) {
      print("errorerrorerrorerrorerrorerror $err");
      return "err";
    }
  }

  Future<Shop?> getShopCredit(String id) async {
    try {
      var docs = await FirebaseFirestore.instance.collection('shop').get();
      if (docs.docs.isNotEmpty) {
        var doc = docs.docs.where((d) => d.id == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data();
          shopCr = Shop(
              creditedDate: docdata.containsKey('credited_at')
                  ? docdata['credited_at'].toDate()
                  : null,
              shopCredit: docdata.containsKey('remaining_time')
                  ? docdata['remaining_time']
                  : '');
          shopCredit = docdata.containsKey('remaining_time')
              ? docdata['remaining_time']
              : '';
          var credit = int.parse(shopCredit);
          final creditedAt = docdata.containsKey('credited_at')
              ? docdata['credited_at'].toDate()
              : null;
          final date2 = DateTime.now();
          final difference = date2.difference(creditedAt).inDays;
          remaining = credit - difference;
          notifyListeners();
        }
      }
      return shopCr;
    } catch (err) {
      print("errorcredit $err");
//      return err;
    }
  }

  Future<int> getRemaining(String id) async {
    try {
      var docs = await FirebaseFirestore.instance.collection('shop').get();
      if (docs.docs.isNotEmpty) {
        var doc = docs.docs.where((d) => d.id == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data();
          shopCredit = docdata.containsKey('remaining_time')
              ? docdata['remaining_time']
              : '';
          var credit = int.parse(shopCredit);
          final creditedAt = docdata.containsKey('credited_at')
              ? docdata['credited_at'].toDate()
              : null;
          final date2 = DateTime.now();
          final difference = creditedAt.difference(date2).inDays;
          remaining = credit - difference;
          notifyListeners();
        }
      }
      return remaining;
    } catch (err) {
      print("errorremaining $err");
      return remaining;
    }
  }

  Future<String> uploadBackImage(File back, {String? path}) async {
    // final mimetypeData = lookupMimeType(image.path).split('/');
    String fileName = basename(back.path);
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("background_images/$fileName");

    uploadBackTask = storageReference.putFile(back).snapshotEvents;

    streamSubscription = uploadBackTask!.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.

      notifyListeners();
      print('EVENT ${event}');
    });
    // uploadBackTask!.snapshot.((taskSnapshot) {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //     // ...
    //       break;
    //     case TaskState.paused:
    //     // ...
    //       break;
    //     case TaskState.success:
    //     // ...
    //       break;
    //     case TaskState.canceled:
    //     // ...
    //       break;
    //     case TaskState.error:
    //     // ...
    //       break;
    //   }
    // });

// Cancel your subscription when done.
//     var up = await uploadBackTask.onComplete;
    var imageUrl = await storageReference.getDownloadURL();
    // streamSubscription.cancel();
    notifyListeners();
    return imageUrl;
  }

  Future<bool> updateShopBack(String id, File file) async {
    var backImage = '';
    try {
      if (file != null) {
        var back = await getShopBackGround(id);
        if (back != null) {
          await deleteImage(back);
        }
        await uploadBackImage(file).then((res) {
          print('imageuriimageuriimageuri$res');
          if (res != null) {
            backImage = res;
          }
        });

        FirebaseFirestore.instance.collection('shop').doc(id).update({
          'back_image': backImage,
          'updated_at': new DateTime.now()
        }).whenComplete((fetchProducts));
        return true;
      }
      return false;
    } catch (err) {
      print("errorerrorerrorerrorerrorerror $err");
      return false;
    }
  }
}

Future deleteImage(String url) async {
  try {
    if (url != null) {
      Reference photoRef = await FirebaseStorage.instance.refFromURL(url);
      await photoRef.delete();
    }
  } catch (e) {}
}
