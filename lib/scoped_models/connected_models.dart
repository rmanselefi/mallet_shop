import 'package:mallet_shop/models/product.dart';
import 'package:mallet_shop/models/shop.dart';
import 'package:mallet_shop/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin ConnectedModels on Model{
  bool isLoading=true;
  UserModel? authenticatedUser;
  List<Product> userProducts=[];
  List<Product> specialProducts=[];
   Shop? shop;
  var shopName='';
  var shopId='';
  var shopImage='';
  var shopCredit='';
  Shop? shopCr;
  var shopCategory='';
  var password='';
  var remaining;

  Future<Shop?> getAuthenticatedShop() async {
    try{
      var docs = await FirebaseFirestore.instance.collection('shop').get();
      if (docs.docs.isNotEmpty) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        if(pref.containsKey('user_id')) {
          final String? userID = pref.getString('user_id');
          if(userID!=null) {
            var doc = docs.docs
                .where((sh) => sh.data()['user_id'] == userID)
                .toList();
            var data = doc[0].data();

            shop = Shop(
                Id: doc[0].id,
                shopName: data.containsKey('shop_name')
                    ? data['shop_name']
                    : '',
                shopCategory: data.containsKey('category')
                    ? data['category']['name']
                    : '',
                shopPhone: data.containsKey('phone') ? data['phone'] : '',
                shopWebsite: data.containsKey('shop_website')
                    ? data['shop_website']
                    : '',
                shopDescription: data.containsKey('description')
                    ? data['description']
                    : ''
            );

            return shop;
          }
        }
      }
    }
    catch(e){

    }

  }
}