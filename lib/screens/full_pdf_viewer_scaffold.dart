import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ViewPDF extends StatefulWidget {
  final String blob;
  ViewPDF({Key key, @required this.blob}) : super(key: key);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //view PDF
        appBar: AppBar(
          title: new Center(
              child: new Text('الجميعة العقارية', textAlign: TextAlign.center)),

          backgroundColor: Colors.amber, // status bar color
          brightness: Brightness.dark, // status bar brightness
        ),
        drawer: NavDrawer(),
        body: Stack(
          children: <Widget>[
            PDFView(
              pdfData: base64Decode(widget.blob),
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              fitPolicy: FitPolicy.BOTH,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: send,
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text("مشاركة"),
              ),
            ),
          ],
        ));
  }

  Future<void> send() async {
    final encodedStr = widget.blob;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);

    final MailOptions mailOptions = MailOptions(
      body: 'يرجي التكرم بمشاهدة المرفقات',
      subject: 'مشاركة ملف',
      attachments: [file.path],
      recipients: ['info@jumaiah.com'],
    );

    String platformResponse;

    try {
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was success';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      print(error);
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Message',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(error.message ?? 'unknown error'),
            ],
          ),
          contentPadding: const EdgeInsets.all(26),
          title: Text(error.code),
        ),
      );
    } catch (error) {
      platformResponse = error.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }
}
