import 'package:flutter/material.dart';
import 'package:mallet_shop/models/shop.dart';
import 'package:mallet_shop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class RemainingCredit extends StatefulWidget {
  final MainModel model;
  final String id;
  RemainingCredit(this.model,this.id);

  @override
  _RemainingCreditState createState() => _RemainingCreditState();
}

class _RemainingCreditState extends State<RemainingCredit> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("credit.idcredit ${widget.id}");
    widget.model.getShopCredit(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Color(0xff29b6f6).withOpacity(0.9),),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text('Credit'),
        backgroundColor:  Color(0xff2a2e42),
      ),
      body: ScopedModelDescendant<MainModel>(
          builder:  (BuildContext context, Widget child, MainModel model)  {

            return FutureBuilder<Shop?>(
              future: model.getShopCredit(widget.id),
              builder: (context,snap) {
                if (!snap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  if (snap.data!.shopCredit == '') {
                    return Center(
                      child: Text('No data to show'),
                    );
                  }
                  var credit=int.parse(snap.data!.shopCredit.toString());
                  final creditedAt = snap.data!.creditedDate;
                  final date2 = DateTime.now();
                  final difference = date2.difference(creditedAt as DateTime).inDays;
                  var remaining=credit-difference;
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xff2a2e42)
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 200.0,),
                        Container(
                          child: Text('Remaining time',style: TextStyle(color:Colors.grey),),
                        ),
                        remaining<=0?
                        Container(
                          child: Center(
                              child: Text(
                                  'Your Account is about to expire please contact the adimistrator',
                                  style: TextStyle(color: Colors.grey, fontSize: 18)
                              ),
                        ))
                            :
                        Container(
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text:'${remaining.toString()}',
                              style: TextStyle(color: Colors.white,fontSize: 100.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Days', style: TextStyle(color: Colors.grey, fontSize: 18)
                                  )
                                ]
                            ),

                            )

                          ),
                        ),
                      ],
                    ),
                  );
                }

              }
            );
          }),
    );

  }
}
