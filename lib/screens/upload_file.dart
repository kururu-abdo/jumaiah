import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:flutter_animated_splash_screen/components/text_fields.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

final orpc = OdooClient('http://161.35.211.239:8069');
const GMAIL_SCHEMA = 'com.google.android.gm';

class FilePickerDemo extends StatefulWidget {
  final String file, name, res_model, res_id, pt_id;

  FilePickerDemo({
    Key key,
    @required this.file,
    this.pt_id,
    this.res_id,
    this.name,
    this.res_model,
  }) : super(key: key);

  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
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
  TextEditingController _controller = TextEditingController();
  // Function to get the JSON data

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
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
    } catch (ex) {
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
    await orpc.authenticate('Jumaiah', 'admin', '123456');

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
      ScaffoldMessenger.of(context).showSnackBar(
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: new Center(
              child: new Text('الجميعة العقارية', textAlign: TextAlign.center)),

          backgroundColor: Colors.amber, // status bar color
          brightness: Brightness.dark, // status bar brightness
        ),
        drawer: NavDrawer(),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFields(
                  controller: emailController,
                  name: "اسم الملف",
                  validator: (String) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _openFileExplorer(),
                        child: const Text("اختيار ملف"),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('مسار المجلد'),
                              subtitle: Text(_directoryPath),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                    itemCount:
                                        _paths != null && _paths.isNotEmpty
                                            ? _paths.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths.isNotEmpty;
                                      final String name = 'File $index: ' +
                                          (isMultiPath
                                              ? _paths
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...');
                                      final path = _paths
                                          .map((e) => e.path)
                                          .toList()[index]
                                          .toString();

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                        subtitle: Text(path),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  )),
                                )
                              : const SizedBox(),
                ),
                RaisedButton(
                  onPressed: fetchContacts,
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("حفظ"),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
