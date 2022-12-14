

import 'package:flutter/material.dart';
import 'package:jumaiah/components/nav-drawer.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/screens/add_photo.dart';
import 'package:jumaiah/screens/attachmentscreen.dart';
import 'package:jumaiah/screens/photo_view.dart';
import 'package:jumaiah/screens/signin.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/custom_transition.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:jumaiah/utils/utils.dart';

import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  int use_id;
  final dynamic prop_lat;
  final website;
  final dynamic image,
      name,
      location,
      ptLocation ,
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
      this.prop_lat, this.ptLocation})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isLoading = false;
var scaffoldKey = GlobalKey<ScaffoldState>();
 UriData imageData;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  

  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
            body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            snap: true,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              // title: Text(widget.name,
              //     style: TextStyle(
              //         
              // : FontWeight.bold,
              //         fontSize: 30,
              //         color: Colors.white)), //Text
              background: Image.memory(
                // base64Decode(
                  // DEFAULT_IMG
            widget.image==null  ||      widget.image.toString() == "false" 
                    ? 
                    convertBase64Image(DEFAULT_IMG)
                    
                    :
                    // : base64Decode(widget.image.toString().replaceAll("\s+", ''))
                    
                    convertBase64Image(widget.image.toString())
                    ,
                    // ),
                fit: BoxFit.cover,
              ), //Images.network
            ), //FlexibleSpaceBar
            expandedHeight: 200,
            // backgroundColor: Colors.greenAccent[400],
            leading:

            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                width: 69,
                height:71 ,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor ,
                  borderRadius: BorderRadius.circular(11)
                ),
                child: Center(child:Icon(Icons.arrow_back ,size: 18,) ,),
              ),
            )
            
            //  IconButton(
            //   icon: const Icon(Icons.arrow_back),
            //   color: Colors.white,
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ), //IconButton
            //<Widget>[]
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('?????????????? ????????????',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black)),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "?????? ????????????",
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
                      "???????? ????????????",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(

                     showStatsText( widget.property_status.toString().trim()),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "????????????",
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
                      "?????? ????????",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      getCertificationNo(widget.certificate_no),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "?????????? ????????",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                       widget.certificate_date.toString()=='false' ||  widget.certificate_date.toString()==''?
                       '?????? ??????????':
                      widget.certificate_date,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
               
                      if (widget.website.toString().startsWith("http")) {
                        if (await canLaunch(widget.website.toString().trim())) {
                      await    launch(widget.website.toString().trim());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Row(children: [
                            Text('???????????? ?????? ????????') ,
                            TextButton(onPressed: (){
scaffoldMessangerKey.currentState.hideCurrentSnackBar();
                            }, child: Text('????????'))
                          ],)));
                         // throw 'Could not launch ';
                        }
                      } else {
                        
                        if (await canLaunch(
                            "http://" + widget.website.toString().trim())) {
                        await  launch("http://" + widget.website.toString().trim());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Row(children: [
                            Text('???????????? ?????? ????????') ,
                            TextButton(onPressed: (){
scaffoldMessangerKey.currentState.hideCurrentSnackBar();
                            }, child: Text('????????'))
                          ],)));
                        }
                      }
                    },
                    title: Text(
                      "???????????? ????????????????????",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                       widget.website==false ||  widget.website==''?
                '?????? ??????????':
                      
                      widget.website.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                  ),
                  ListTile(
                    onTap: () async {

                      print(widget.prop_lat);
                      //  _launchMap(widget.prop_lat);
                    },
                    title: Text(
                      "???????????? ????????????????",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      widget.ptLocation==false ||widget.ptLocation==''?
                      '?????? ??????????':widget.ptLocation
                       ,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
               
                ],
              ),
            ),
          )
        ] //S liverAppBar
                ),
              
                floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
                floatingActionButton: Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFF1CD6CE),
child: Center(
  child: Icon(Icons.location_on_outlined ,
  
  ),
),
                    onPressed: () {
_launchMap(widget.prop_lat);
                    },
                   ),
                ),
                bottomSheet: Container(
                  height: 80,
                  width: double.infinity,
                  child:      Container(
                    margin: EdgeInsets.all(10.0),
                    child: Row(
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
                            color: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "????????????????",
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
                            color: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "???????? ??????????",
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
                                          label: '????????',
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
                                            "?????? ???????? ???? ???????????? ???????? ???? ???????????????? ")));
                              } else {
                                ///TODO:  show snackbar
                                Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      AddPhoto(widget.pt_id),
                                    ));
                              }
                            },
                            color: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "?????????? ??????",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              
            
                ),
                
                
                ),
      ),
    );
  }
 String   showStatsText(String status) {
     switch (status) {
       case  'ok':
         return '?????? ??????????';
         break;
         case 'cancel':
          return '??????????';

        case 'draft':
        return '??????????';
       default:
       return '[?????? ??????????]';
     }
   }
  _launchMap(url) async {
    print('///////////////////////////////////////////');
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
     ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        action: SnackBarAction(
                                          label: '????????',
                                          onPressed: () {  

                                             ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          }  ) ,
                                          content: Text('???????????? ?????? ????????'),

                                    )
                                    );
    }
  }

  String getCertificationNo(dynamic certificate_no) {
    if (
      
      certificate_no==false || certificate_no==null ||
      certificate_no
      .toString()=="false") {
      return '?????? ??????????' ;
    }else {
      return certificate_no.toString();
    }
  }
}
