import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {


  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchPhone() async {
    if (await canLaunch("tel://+251912970734")) {
      await launch("tel://+251912970734");
    } else {
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Color(0xff29b6f6).withOpacity(0.9),),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text('Contact Us'),
        backgroundColor: Color(0xff2a2e42),
      ),
      body: Container(
        child:ListView(
          children: <Widget>[
            SizedBox(
              height: 25.0,
            ),
            Card(
              elevation: 5.0,
              child: Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Text('Mall ET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Text('Mall ET is Created and Owned by Qemer Software Technology P.L.C',
                        style: TextStyle(
                            fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Card(
              elevation: 6.0,
              child: Container(
                height: 140.0,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Contact Us',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.call,color: Color(0xff29b6f6).withOpacity(0.9),),
                              onPressed: (){
                                _launchPhone();
                              },
                            ),
                            Text('Call Us')
                          ],
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.send,color: Color(0xff29b6f6).withOpacity(0.9),),
                              onPressed: (){
                                const url = 'https://t.me/MallEtClients';
                                _launchURL(url);
                              },
                            ),
                            Text('Telegram')
                          ],
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.location_on,color: Color(0xff29b6f6).withOpacity(0.9),),
                              onPressed: (){
                                var latitude=8.99547222;
                                var longitude=38.76666667;
                                String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                _launchURL(googleUrl);
                              },
                            ),
                            Text('Office')
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),


          ],
        )
      ),
    );
  }
}
