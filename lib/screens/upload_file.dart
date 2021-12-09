import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumaiah/components/nav-drawer.dart';
import 'package:jumaiah/components/text_fields.dart';
import 'package:jumaiah/controllers/upload_file_controller.dart';
import 'package:jumaiah/enums/upload_file_state.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/theme.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';

final orpc = OdooClient('http://142.93.55.190:8069');
const GMAIL_SCHEMA = 'com.google.android.gm';

class FilePickerDemo extends StatefulWidget {
  final name, res_model, res_id, pt_id;

  FilePickerDemo({
    Key key,
    this.pt_id,
    this.res_id,
    this.name,
    this.res_model,
  }) : super(key: key);

  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  TextEditingController emailController = TextEditingController();
  Uint8List fileBytes2;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _textController = TextEditingController();
  // Function to get the JSON data

  AnimationController _controller;
  Animation<Offset> _animation;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(widget.res_id);
    print(widget.res_model);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -0.2),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _textController.addListener(() => _extension = _textController.text);

    Future.microtask(() {
      context.read<UploadFileControler>().initState();
    });
    super.initState();
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        withData: true,
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      setState(() => _loadingPath = false);
    } catch (ex) {
      setState(() => _loadingPath = false);

      print(ex);
    }
    if (!mounted) return;

    setState(() {
      String fileName = _paths.first.name;
      final file = File(_paths.first.path);
      fileBytes2 = file.readAsBytesSync();
      final hh = base64Encode(fileBytes2);
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
      print('hany' + base64Encode(fileBytes2));
    });
  }

  Future<dynamic> fetchContacts() async {
    await orpc.authenticate('Jumaiah', 'admin', 'bcool1984');

    var result = await orpc.callKw({
      'model': 'ir.attachment',
      'method': 'create',
      'args': [
        {
          'name': ' emailController.text',
          'res_id': widget.res_id,
          'res_model': widget.res_model,
          'type': 'binary',
          'datas': base64Encode(fileBytes2),
          'datas_fname': _fileName,
          'mimetype': 'application/pdf',
        },
      ],
      'kwargs': {},
    });
    if (result > 0) {
      setState(() {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'تهانينا',
            desc: 'تم رفع الملف بنجاح',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
        print(fileBytes2.toString());
      });
    } else {
      setState(() {
        SnackBar(content: Text("يرجي تعبئة جميع الحلول"));
      });
      print(result);
      return result;
    }
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: new Center(
              child: new Text('الجميعة ', textAlign: TextAlign.center)),

          backgroundColor: AppTheme.primaryColor, // status bar color
          brightness: Brightness.dark, // status bar brightness
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white)),
        ),

        // drawer: NavDrawer(),
        body: SingleChildScrollView(
          child:
              Consumer<UploadFileControler>(builder: (context, model, child) {
            if (model.state == UploadFileState.Initial) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Builder(
                            builder: (context) => Center(
                                  child: SlideTransition(
                                      position: _animation,
                                      transformHitTests: true,
                                      textDirection: TextDirection.ltr,
                                      child: Image.asset("assets/doc.png")),
                                )),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "إسم الملف....",
                            suffixIcon: Icon(Icons.file_copy_rounded),

                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
// focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                     BorderSide(color:    AppTheme.primaryColor, width: 3.0),
//                               ),

// enabledBorder: OutlineInputBorder(
//                                 borderSide:
//                                     BorderSide(color:                AppTheme.primaryColor, width: 5.0),
//                               ),
//     border: OutlineInputBorder(

// borderSide: BorderSide(
//                       color: AppTheme.primaryColor, width: 5.0)
//                   ,

//       borderRadius:BorderRadius.circular(10.0)
//     )
                          ),
                          validator: (val) {
                            if (val.isEmpty || val.length < 0) {
                              return "يجب لإدخال اسم الملف";
                            }

                            return null;
                          },
                        ),
                      ),

                      // Container(
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25) ,

                      //   )),
                      // ),

                      Spacer(),

                      Container(
                        height: 50,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.primaryColor),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              model.openFileExplorer();
                            }
                          },
                          child: Center(
                              child: Text(
                            "اختيار ملف",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (model.state == UploadFileState.Deployded) {
              return deployed(context);
            } else if (model.state == UploadFileState.Uploading) {
              return uploading(context);
            } else if (model.state == UploadFileState.Uploaded) {
              return done(context);
            } else {
              if (model.exception is OdooServerException) {
                return error(
                    context, model.exception.toString(), "assets/server.png");
              } else if (model.exception is ConnectionException) {
                return error(
                    context, model.exception.toString(), "assets/server.png");
              } else if (model.exception is FileException) {
                return error(context, model.exception.toString(),
                    "assets/file_exception.png");
              } else if (model.exception is ConnectionException) {
                return error(
                    context, model.exception.toString(), "assets/server.png");
              } else if (model.exception is MyTimeOutException) {
                return error(
                    context, model.exception.toString(), "assets/server.png");
              }
              return error(
                  context, model.exception.toString(), "assets/unknown.png");
            }
          }),
        ),
      ),
    );
  }

  Widget initial(BuildContext context) {
    var model = Provider.of<UploadFileControler>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 2 / 3,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children: [
                Builder(
                    builder: (context) => Center(
                          child: SlideTransition(
                              position: _animation,
                              transformHitTests: true,
                              textDirection: TextDirection.ltr,
                              child: Image.asset("assets/doc.png")),
                        )),
                Spacer(),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.primaryColor),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _openFileExplorer();
                      }
                    },
                    child: const Text("اختيار ملف"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploading(BuildContext context) {
    var model = Provider.of<UploadFileControler>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/gif-upload.gif"),
          Text("جاري رفع الملف....")
        ],
      ),
    );
  }

  Widget deployed(BuildContext context) {
    var model = Provider.of<UploadFileControler>(context);

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
              ),
              Image.asset("assets/pdf.png"),
              SizedBox(
                height: 15,
              ),
              Text(model.fileName ?? ""),
              Text(_textController.text),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 1.5, color: Colors.black),
                        color: AppTheme.primaryColor),
                    child: TextButton(
                        onPressed: () async {
                          model.fetchContacts(
                              _textController.text,
                              widget.res_model,
                              widget.res_id,
                              model.fileBytes2,
                              _textController.text);
                        },
                        child: Text(
                          "رفع الملف",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Container(
                      width: 120,
                      height: 60,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                            width: 1.5, color: AppTheme.primaryColor),
                      ),
                      child: TextButton(
                          onPressed: () {
                            model.initState();
                          },
                          child: Text(
                            "تغيير الملف",
                            style: TextStyle(color: Colors.black),
                          ))),
                ],
              )
            ],
          ),
        ));
  }

  Widget FileUploadedWidget(String name) {
    return Center(
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(width: 1.5, color: Colors.green[200])),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.file_upload,
                  // size: 40,
                  color: Colors.green[500],
                ))
          ],
        ),
      ),
    );
  }

  Widget done(BuildContext context) {
    return Center(
      child: Column(
        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/done.gif"),
          Text("تم رفع الملف بنجاح"),
          // Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: AppTheme.primaryColor,
            ),
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("تم")),
          )
        ],
      ),
    );
  }

  Widget error(BuildContext context, String message, String img) {
    var model = Provider.of<UploadFileControler>(context);

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
                  await model.fetchContacts(
                      _textController.text,
                      widget.res_model,
                      widget.res_id,
                      model.fileBytes2,
                      _textController.text);
                },
                icon: Icon(Icons.refresh),
                label: Text("حاول مرة أخرى")),
          )
        ],
      ),
    );
  }
}
