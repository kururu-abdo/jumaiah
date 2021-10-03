import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _PofilePageState createState() => _PofilePageState();
}

class _PofilePageState extends State<ProfilePage> {
  String name;
  String lang;
  String login;
  String timeZone;
  String id;
  String image;

  fetchData() {
    setState(() {
      name = sharedPrefs.getName();
      id = sharedPrefs.getID();
      lang = sharedPrefs.getLang();
      timeZone = sharedPrefs.getTZ();
      login = sharedPrefs.getLogin();
      image = sharedPrefs.getImage();
    });
  }

  @override
  void initState() {
    fetchData();
    Base64ToImage(image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   resizeToAvoidBottomInset: false,

        appBar: AppBar(
          title: new Center(
              child: new Text('البروفايل', textAlign: TextAlign.center)),

          backgroundColor: Colors.amber, // status bar color
          brightness: Brightness.dark, // status bar brightness
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/12.png'), fit: BoxFit.cover),
            ),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ])),
                  profileView()
                ])))
        // profileView()

        //  Container(
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage('assets/12.png'), fit: BoxFit.cover),
        //     ),
        //     child: Container(
        //         width: MediaQuery.of(context).size.width,
        //         height: MediaQuery.of(context).size.height,
        //         child: Stack(children: <Widget>[
        //           Container(
        //             width: double.infinity,
        //             height: double.infinity,
        //           ),
        //           Container(
        //               child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: <Widget>[
        //                 Center(
        //                     child: Image.asset(
        //                   "assets/logo.png",
        //                   height: 130,
        //                   width: 200,
        //                   alignment: Alignment.center,
        //                 )),
        //                 profileView()
        //               ]))
        //         ])))

        );
  }

  Uint8List _bytesImage;

  Base64ToImage(String image) {
    print(image);
    setState(() {
      _bytesImage = base64Decode(image);
    });
  }

  Widget profileView() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: CircleAvatar(
            radius: 70,
            child: ClipOval(
              child:
                      _bytesImage== null  ||  sharedPrefs.getImage()==null || sharedPrefs.getImage()=="null"
                      
                  ? Image.asset(
                      "assets/logo.png",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  :
                 
                   Image.memory(
                      _bytesImage,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          // decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          // gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)])),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(width: 1.0, color: Colors.amber.shade800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        lang,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(width: 1.0, color: Colors.amber.shade800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        timeZone,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(width: 1.0, color: Colors.amber.shade800)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
