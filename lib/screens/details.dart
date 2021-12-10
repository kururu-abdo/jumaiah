import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumaiah/components/nav-drawer.dart';
import 'package:jumaiah/screens/add_photo.dart';
import 'package:jumaiah/screens/attachmentscreen.dart';
import 'package:jumaiah/screens/photo_view.dart';
import 'package:jumaiah/screens/searchview.dart';
import 'package:jumaiah/screens/signin.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/custom_transition.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:jumaiah/widgets/anim_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  int use_id;
  final dynamic prop_lat;
  final website;
  final dynamic image,
      name,
      location,
      owner,
      property_status,
      certificate_no,
      certificate_date;
  final int pt_id;

  Details(this.use_id,
      {Key key,
      @required this.image,
      this.location,
      this.name,
      this.certificate_date,
      this.certificate_no,
      this.owner,
      this.property_status,
      @required this.pt_id,
      this.website,
      this.prop_lat})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            snap: true,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              // title: Text(widget.name,
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 30,
              //         color: Colors.white)), //Text
              background: Hero(
                  tag: widget.use_id.toString().trim(),
                  child: Image.memory(
                    base64Decode(widget.image.toString().trim() == "false"
                        ? DEFAULT_IMG
                        : widget.image),
                    fit: BoxFit.cover,
                  )), //Images.network
            ), //FlexibleSpaceBar
            expandedHeight: 200,
            // backgroundColor: Colors.greenAccent[400],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ), //IconButton
            //<Widget>[]
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('معلومات العقار',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black)),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "اسم العقار",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.name,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "حالة العقار",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.property_status.toString(),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "المالك",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.owner,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "رقم الصك",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.certificate_no,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "تاريخ الصك",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.certificate_date,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      if (widget.toString().startsWith("http")) {
                        if (await launch(widget.website.toString().trim())) {
                          launch(widget.website.toString().trim());
                        } else {
                          throw 'Could not launch ';
                        }
                      } else {
                        if (await launch(
                            "http://" + widget.website.toString().trim())) {
                          launch("http://" + widget.website.toString().trim());
                        } else {
                          throw 'Could not launch ';
                        }
                      }
                    },
                    title: Text(
                      "الموقع الإلكتروني",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(widget.website.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                  ),
                  ListTile(
                    onTap: () async {
                      _launchMap(widget.prop_lat);
                    },
                    title: Text(
                      "الموقع الجغرافي",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.location,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        //  margin: EdgeInsets.all(8.0),
                        // width:80 ,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttachScreen(
                                    pt_id: widget.pt_id.toString(),
                                  ),
                                ));
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "المرفقات",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        // margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                  PhotoPage(widget.pt_id),
                                ));
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "معرض الصور",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        // margin: EdgeInsets.all(8.0),
                        // width: 50,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: RaisedButton(
                          onPressed: () {
                            if (sharedPrefs.getUserType() == "GUEST") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      action: SnackBarAction(
                                        label: 'حسنا',
                                        onPressed: () {
                                          sharedPrefs.setLogin(false);
                                          sharedPrefs.saveUserType(null);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignIn()));
                                          preferences.clear();
                                        },
                                        textColor: Colors.white,
                                        disabledTextColor: Colors.grey,
                                      ),
                                      duration: const Duration(seconds: 8),
                                      content: Text(
                                          "غير مصرح لك بإضافة عقار قم بالتسجيل ")));
                            } else {
                              ///TODO:  show snackbar
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                    AddPhoto(widget.pt_id),
                                  ));
                            }
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "إضافة صور",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ] //SliverAppBar
                )),
      ),
    );
  }

  _launchMap(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Couldn't launch URL";
    }
  }
}
