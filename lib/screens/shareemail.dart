import 'dart:convert';

import 'package:flutter_animated_splash_screen/components/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedBackPage extends StatefulWidget {
  FeedBackPage({Key key, this.image}) : super(key: key);

  final String image;

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final _formKey = GlobalKey<FormState>();
  bool enableBtn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة ملف'),
      ),
      body: Form(
        key: _formKey,
        onChanged: (() {
          setState(() {
            enableBtn = _formKey.currentState.validate();
          });
        }),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFields(
                  controller: subjectController,
                  name: "اسم الملف",
                  validator: ((value) {
                    if (value.isEmpty) {
                      return 'الاسم مطلوب';
                    }
                    return null;
                  })),
              TextFields(
                controller: emailController,
                name: "Email",
                validator: (String) {},
              ),
              TextFields(
                  controller: messageController,
                  name: "Message",
                  validator: ((value) {
                    if (value.isEmpty) {
                      setState(() {
                        enableBtn = true;
                      });
                      return 'Message is required';
                    }
                    return null;
                  }),
                  maxLines: null,
                  type: TextInputType.multiline),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
                            else if (states.contains(MaterialState.disabled))
                              return Colors.grey;
                            return Colors.blue; // Use the component's default.
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ))),
                    onPressed: enableBtn
                        ? (() async {
                            final Email email = Email(
                              body: 'share file',
                              subject: 'share file with email',
                              recipients: [emailController.text],
                              isHTML: false,
                              attachmentPaths: [
                                base64Decode(widget.image).toString()
                              ],
                            );

                            await FlutterEmailSender.send(email);
                          })
                        : null,
                    child: Text('Submit'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
