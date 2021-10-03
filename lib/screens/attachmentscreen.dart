import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/controllers/attachments_controller.dart';
import 'package:flutter_animated_splash_screen/enums/attachment_state.dart';
import 'package:flutter_animated_splash_screen/screens/signin.dart';
import 'package:flutter_animated_splash_screen/screens/upload_file.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:flutter_animated_splash_screen/utils/loader.dart';
import 'package:flutter_animated_splash_screen/utils/loading_overlay.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:flutter_animated_splash_screen/utils/theme.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_animated_splash_screen/screens/attachmentscreen.dart';
import 'package:flutter_animated_splash_screen/screens/shareemail.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_animated_splash_screen/screens/full_pdf_viewer_scaffold.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:universal_html/html.dart' as html;

import '../main.dart';

final orpc = OdooClient('http://142.93.55.190:8069/');
const GMAIL_SCHEMA = 'com.google.android.gm';
final Future<bool> gmailinstalled = FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

class AttachScreen extends StatefulWidget {
  final  name, res_model, res_id, pt_id, blob, blobimage, main_id;

  AttachScreen({
    Key key,
  
    this.pt_id,
    this.res_id,
    this.name,
    this.blob,
    this.main_id,
    this.blobimage,
    this.res_model,
  }) : super(key: key);

  @override
  _AttachScreenState createState() => _AttachScreenState();
}

class _AttachScreenState extends State<AttachScreen>   {
  String email, password;
  bool isLoading = false;


 @override
 void initState() { 
   Future.microtask(()async{
    await   context.read<AttachmentScreenCOntroller>().fetchContacts(widget.pt_id);


   });
   super.initState();
   
 }

  // Function to get the JSON data
  Future<dynamic> fetchContacts() async {
    await orpc.authenticate('Jumaiah', 'admin', '123456');

    var result = await orpc.callKw({
      'model': 'ir.attachment',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': [
          ['res_id', '=', widget.pt_id]
        ],
        'fields': [],
        'limit': 80,
      },
    });
    print(result);
    return result;
  }

  Widget buildListItem(Map<String, dynamic> record) {
    var name = record['name'];
    var res_id = record['res_id'];
    var res_model = record['res_model'];
    var main_id = record['id'];

    final blob = record['datas'];
    final _byteImage = Base64Decoder().convert(blob);
    var blobimage = Image.memory(_byteImage);
    return ListTile(
      title: Text(name),
      leading: Icon(Icons.picture_as_pdf),
      // trailing: SizedBox(
      //   width: 120,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       Align(
      //         alignment: Alignment.bottomCenter,
      //         child: RaisedButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => FilePickerDemo(
      //                     pt_id: record['id'].toString(),
      //                     name: record['name'][1],
      //                     res_id: record['res_id'].toString(),
      //                     res_model: record['res_model'],
      //                   ),
      //                 ));
      //           },
      //           color: Colors.amber,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Text("اضافة ملف"),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewPDF(blob: blob)));
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final MailOptions mailOptions = MailOptions(
        body: '_bodyController.text',
        subject: '_subjectController.text',
        recipients: ['brosoftsudan@gmail.com'],
        attachments: [widget.blobimage]);

    String platformResponse;

    try {
      await FlutterMailer.send(mailOptions);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var model  = Provider.of<AttachmentScreenCOntroller>(context);
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl, 
        child: new Scaffold(
          appBar: AppBar(
            title: new Center(
                child: new Text('المرفقات', textAlign: TextAlign.center)),
      
            backgroundColor: AppTheme.primaryColor, // status bar color
            brightness: Brightness.dark, 
            actions: [
              IconButton(onPressed: ()async{
  await model.fetchContacts(widget.pt_id);


              }, icon: Icon(Icons.refresh ))
            ],// status bar brightness
          ),
          drawer: NavDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
           
              Container(
                margin: EdgeInsets.only(left:10 , right: 10),
                child: TextField(
                onChanged: (val)=> model.filter(val),
                  decoration: InputDecoration(
                      labelText: 'بحث', suffixIcon: Icon(Icons.search)),
                ),
              ),








Consumer<AttachmentScreenCOntroller>(
                builder: (context, model, child) {
                  if(model.state==AttachmentScreenState.Lading){
                   return  SizedBox(
                     height: MediaQuery.of(context).size.height/2,
                     
                     child: LoadingWidget());

                  } else if (model.state==AttachmentScreenState.Loaded){



                    return   
 Expanded(
                          child: ListView.builder(
                              itemCount:model.filterRecodes.length,
                              itemBuilder: (context, index) {
                                final record =
                                   model.filterRecodes[index] as Map<String, dynamic>;
      
      print(record);
                                return buildListItem(record);
                              }));

                  }  else {
                    if(model.exception is OdooServerException){

 return error(context, model.exception.toString(),
                          "assets/server.png");

                    } 
                    else if(model.exception is ConnectionException){
 return error(context, model.exception.toString(),
                          "assets/server.png");

                    }
                      else if (model.exception is MyTimeOutException) {
                         return error(context, model.exception.toString(),
                          "assets/server.png");

                      }
                      else if (model.exception is NoData404Exception) {
                      return noResult(context, model.exception.toString(),
                     );
                    }
    return error(context, model.exception.toString(),
                        "assets/unknown.png");

                  }
             


                },
              ),
  





              // FutureBuilder(
              //     future: fetchContacts(),
              //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              //       if (snapshot.hasData) {
              //         return Expanded(
              //             child: ListView.builder(
              //                 itemCount: snapshot.data.length,
              //                 itemBuilder: (context, index) {
              //                   final record =
              //                       snapshot.data[index] as Map<String, dynamic>;
      
              //                   return buildListItem(record);
              //                 }));
              //       } else {
              //         if (snapshot.hasError) return Text('Unable to fetch data');
              //         return CircularProgressIndicator();
              //       }
              //     }),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
  //  print(model.recorders.toString());
  //      print(model.recorders[0]["res_id"].toString());
    





    if (sharedPrefs.getUserType() == "GUEST") {
      ///TODO: addSnackBar
                print("not allowed");
                  scaffoldMessangerKey.currentState.showSnackBar(
                    SnackBar(
                       action: SnackBarAction(
                      label: 'حسنا',
                      onPressed: () {
                         sharedPrefs.setLogin(false);
                        sharedPrefs.saveUserType(null);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                        preferences.clear();

                      },
                      textColor: Colors.white,
                      disabledTextColor: Colors.grey,
                    ),
                         duration: const Duration(seconds: 8),
 
                      
                      content: Text("غير مصرح لك بإضافة ملفات قم بالتسجيل")));
              } else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilePickerDemo(
                      pt_id: widget.pt_id.toString(),
                      name: widget.name,
                      res_id:widget.pt_id,
                      // model.recorders[0]["res_id"].toString(),
                      res_model:"property.base"
                      //model.recorders[0]["res_model"].toString(),
                    ),
                  ));
              }
            },
            backgroundColor: AppTheme.primaryColor,
            icon: Icon(Icons.add_a_photo),
            label: Text('اضافة ملف'),
          ),
        ),
      ),
    );
  }
 Widget error(BuildContext context, String message, String img) {
    var model = Provider.of<AttachmentScreenCOntroller>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img),

          Text(message),

          // Spacer(),

          Container(
            // margin: EdgeInsets.all(10),

            width: double.infinity,

            child: FlatButton.icon(
                onPressed: () async {
                  await model.fetchContacts(widget.pt_id
                    );
                },
                icon: Icon(Icons.refresh),
                label: Text("حاول مرة أخرى")),
          )
        ],
      ),
    );
  }
Widget noResult(BuildContext context, String message) {
    var model = Provider.of<AttachmentScreenCOntroller>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         SvgPicture.asset("assets/ResultsMagnifyingGlass.svg",
              color: Colors.red, semanticsLabel: 'A red up arrow'),

          Text(message),

          // Spacer(),

          Container(
            // margin: EdgeInsets.all(10),

            width: double.infinity,

            child: FlatButton.icon(
                onPressed: () async {
                  await model.fetchContacts(widget.pt_id);
                },
                icon: Icon(Icons.refresh),
                label: Text("حاول مرة أخرى")),
          )
        ],
      ),
    );
  }

}
