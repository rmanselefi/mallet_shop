import 'package:flutter/material.dart';
import 'package:mallet_shop/models/product.dart';
import 'package:mallet_shop/products/product_form.dart';
import 'package:mallet_shop/products/shopdetail_card.dart';
import 'package:mallet_shop/products/top.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:mallet_shop/setting/add_details.dart';
import 'package:mallet_shop/shared/ShopMode.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProductList extends StatefulWidget {
  final MainModel model;
  final String id;

  ProductList(this.model, this.id);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ShopeMode _mode = ShopeMode.Home;
  Future<List<Product>?>? fetch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch = widget.model.fetchProducts();
    widget.model.getShopBackGround(widget.id);
  }

  void _showSettingsPanel(String Id, String image, String price, String name,String description) {
    showModalBottomSheet(
        context: context,
        elevation: 10.0,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: ProductForm(Id, name, price, image, description));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return FutureBuilder<List<Product>?>(
            future: fetch,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                if (snapshot.data == null) {
                  return Center(
                    child: Text('No data to show'),
                  );
                }
                return Column(
                  children: <Widget>[
                    ShopDetailTop(model: model,
                      shopName: model.shopName,
                      backImg: model.shopImage,),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mode = ShopeMode.Home;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(left: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: _mode == ShopeMode.Home
                                      ? BorderSide(
                                      width: 2, color: Colors.lightBlue)
                                      : BorderSide(
                                      width: 2, color: Colors.white))
                              ),
                              child: Text('Home', style: TextStyle(
                                  color: _mode == ShopeMode.Home ? Colors
                                      .lightBlue : Colors.black26),),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mode = ShopeMode.Detail;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(left: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: _mode == ShopeMode.Detail
                                          ? BorderSide(
                                          width: 2, color: Colors.lightBlue)
                                          : BorderSide(
                                          width: 2, color: Colors.white))
                              ),
                              child: Text('Detail Info', style: TextStyle(
                                  color: _mode == ShopeMode.Detail ? Colors
                                      .lightBlue : Colors.black26),),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mode = ShopeMode.BigSell;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(left: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: _mode == ShopeMode.BigSell
                                          ? BorderSide(
                                          width: 2, color: Colors.lightBlue)
                                          : BorderSide(
                                          width: 2, color: Colors.white))
                              ),
                              child: Text(model.shopCategory == 'Furniture' ||
                                  model.shopCategory == 'Cloths/Apparel' || model.shopCategory == 'Stationary' ||
                                  model.shopCategory == 'Materials' || model.shopCategory=='Electronics'
                                  ? 'BIG Sale'
                                  : 'Special', style: TextStyle(
                                  color: _mode == ShopeMode.BigSell ? Colors
                                      .lightBlue : Colors.black26),),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Builder(
                        builder: (context) {
                          if (_mode == ShopeMode.Home) {
                            return Expanded(
                              child: RefreshIndicator(
                                onRefresh: widget.model.fetchProducts,
                                child: ResponsiveGridList(
                                    minSpacing: 5,
                                    desiredItemWidth: MediaQuery
                                        .of(context)
                                        .size
                                        .width > 370 ? 180 : 120,
                                    scroll: true,
                                    children: model.userProducts.map<Widget>((
                                        f) {
                                      return new GestureDetector(
                                          onTap: () {
                                            _showSettingsPanel(
                                              f.Id.toString(),
                                              f.productImage.toString(),
                                              f.productPrice.toString(),
                                              f.productName.toString(),
                                              f.productDescription.toString(),
                                            );
                                          },
                                          child: ShopDetailCard(
                                            name: f.productName.toString(),
                                            price: f.productPrice.toString(),
                                            url: f.productImage.toString(),));
                                    }).toList()

                                ),
                              ),
                            );
                          } else if (_mode == ShopeMode.BigSell) {
                            return Expanded(
                              child: RefreshIndicator(
                                onRefresh: widget.model.fetchProducts,
                                child: ResponsiveGridList(
                                    minSpacing: 5,
                                    desiredItemWidth: MediaQuery
                                        .of(context)
                                        .size
                                        .width > 370 ? 180 : 120,
                                    scroll: true,
                                    children: model.specialProducts.map<
                                        Widget>((f) {
                                      return new GestureDetector(
                                          onTap: () {
                                            _showSettingsPanel(
                                                f.Id.toString(),
                                                f.productImage.toString(),
                                                f.productPrice.toString(),
                                                f.productName.toString(),
                                                f.productDescription.toString()
                                            );
                                          },
                                          child: ShopDetailCard(
                                            name: f.productName.toString(),
                                            price: f.productPrice.toString(),
                                            url: f.productImage.toString(),));
                                    }).toList()

                                ),
                              ),
                            );
                          }
                          else {
                            return AddDetail();
                          }
                        })
                  ],
                );
              }
            },
          );
        });
  }
}

class Prod {
}
