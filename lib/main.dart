import 'package:flutter/material.dart';
import 'package:mallet_shop/products/products.dart';
import 'package:mallet_shop/scoped_models/auth.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

import 'package:mallet_shop/setting/ChangeBackground.dart';
import 'package:mallet_shop/setting/ChangePassword.dart';
import 'auth/SignIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final MainModel _model = new MainModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model.autoAuthenticate();
    _model.getShopBackGround(_model.shopId);
    _model.getShopCredit(_model.shopId);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: FutureBuilder(
        future: _model.autoAuthenticate(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return CircularProgressIndicator();
          }
          print('project snapshot data is: ${projectSnap.data}');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: projectSnap.data != null ? ProductPage(_model) : SignIn(),
            routes: {
              '/home':(BuildContext context)=>ProductPage(_model),
              '/change':(BuildContext context)=>ChangePassword(),
              '/changeImage':(BuildContext context)=>ChangeBackground(_model,_model.shopId),
            },
          );
        },

      ),
    );
  }
}
