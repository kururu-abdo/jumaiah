import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/screens/upload_file.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_animated_splash_screen/screens/attachmentscreen.dart';
import 'package:flutter_animated_splash_screen/screens/shareemail.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_animated_splash_screen/screens/full_pdf_viewer_scaffold.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:universal_html/html.dart' as html;

final orpc = OdooClient('http://161.35.211.239:8069');
const GMAIL_SCHEMA = 'com.google.android.gm';
final Future<bool> gmailinstalled = FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

class AttachScreen extends StatefulWidget {
  final String file, name, res_model, res_id, pt_id, blob, blobimage, main_id;

  AttachScreen({
    Key key,
    @required this.file,
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

class _AttachScreenState extends State<AttachScreen> {
  String email, password;
  bool isLoading = false;
  @override

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
      trailing: Text(name),
      title: Icon(Icons.picture_as_pdf),
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
    return new Scaffold(
      appBar: AppBar(
        title: new Center(
            child: new Text('المرفقات', textAlign: TextAlign.center)),

        backgroundColor: Colors.amber, // status bar color
        brightness: Brightness.dark, // status bar brightness
      ),
      drawer: NavDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
              future: fetchContacts(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final record =
                                snapshot.data[index] as Map<String, dynamic>;

                            return buildListItem(record);
                          }));
                } else {
                  if (snapshot.hasError) return Text('Unable to fetch data');
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilePickerDemo(
                  pt_id: widget.main_id.toString(),
                  name: widget.name,
                  res_id: widget.res_id.toString(),
                  res_model: widget.res_model,
                ),
              ));
        },
        icon: Icon(Icons.add_a_photo),
        label: Text('اضافة ملف'),
      ),
    );
  }
}
