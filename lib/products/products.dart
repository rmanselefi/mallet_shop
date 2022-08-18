import 'package:flutter/material.dart';
import 'package:mallet_shop/widgets/drawer.dart';
import 'package:mallet_shop/products/product_list.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';


class ProductPage extends StatefulWidget {
  final MainModel model;
  ProductPage(this.model);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
//          appBar: AppBar(
//            iconTheme: new IconThemeData(color: Color(0xff29b6f6)),
//          ),
          drawer: DrawerCustom(widget.model),
          resizeToAvoidBottomInset: true,
          body: ConnectivityWidgetWrapper(
            message: 'Connecting......',
            child: ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(0xff2a2e42)
                    ),
                    child: model.userProducts.length == 0 && model.isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ProductList(widget.model,widget.model.shopId),
                  );
                }),
          )),
      );
  }
}
