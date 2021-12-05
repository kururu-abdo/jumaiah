import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumaiah/enums/upload_file_state.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class UploadFileControler extends ChangeNotifier {

final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);


void initState() {
  _state = UploadFileState.Initial;
  notifyListeners();
}
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }


  String fileName;

  List<PlatformFile> paths;

  Uint8List fileBytes2;

  String directoryPath;

  String extension;

  bool loadingPath = false;

  bool multiPick = false;

  FileType pickingType = FileType.any;















  UploadFileState _state=  UploadFileState.Initial;
  UploadFileState  get state =>_state;
  

File _file;
File get file =>_file;

  _setState(UploadFileState state){
    print('/////////////////////////////////////////////////');
    print(_state);
    _state=state;
    notifyListeners();

  }
updateFile(File file){
  _file=file;
  notifyListeners();
}

  openFileExplorer()async{

    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
        allowedExtensions: [ 'pdf'],
     onFileLoading: (FilePickerStatus status) {
       if(status==FilePickerStatus.done){
         _setState(UploadFileState.Deployded);

       }else {
             _setState(UploadFileState.Uploading);

       }
     },
    
    );

if(result != null) {
   File file = File(result.files.single.path);
     _file = file;
           fileBytes2 = file.readAsBytesSync();

     notifyListeners();
fileName =  result.files.first.name;
notifyListeners();
directoryPath =   result.files.first.path;

notifyListeners();
_setState(UploadFileState.Deployded);
       

} else {
  _setState(UploadFileState.Error);
  _setException(UnknownException("خطأ غير متوقع"));
   // User canceled the picker
}
    } on  PlatformException {
       ; _setState(UploadFileState.Error);
        _setException(FileException("حدثت مشكلة اثناء رفع الملف"));

    } on Exception{
  _setState(UploadFileState.Error);

_setException(UnknownException("خطأ غير متوقع"));


    } catch(e){
       _setState(UploadFileState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
    }
  }



  Future<OdooSession> getClient() async {
    var session;
    //jumaiah!@##@!
    if (sharedPrefs.getUserType() == GUEST) {
      session = await client.authenticate(
          DEFAULT_DB, DEFAULT_USER2, DEFAULT_PASSWORD);
    } else {
      session = await client.authenticate(DEFAULT_DB,
          sharedPrefs.getEmail().trim(), sharedPrefs.getUserPassword().trim());
    }

    // session = await client.authenticate('Jumaiah', 'admin', 'bcool1984');

    return session;
  }


 Future<dynamic> fetchContacts(
   
   String name ,
   String model ,  dynamic res_id , Uint8List bytes ,   String fileName ) async {
 
 _setState(UploadFileState.Uploading);
 OdooSession session;
   try {
     // await getClient();

   
        session = await getClient();
     

//   var res=    await client.callKw({
//         'model': 'ir.attachment',
//         'method': 'search_read',
//         'args': [],
//         'kwargs': {
//           'domain': [
//             // ['res_id', '=', pt_id]
//           ],
//           'fields': [],
//           'limit': 80,
//         },
//       });
// print(res.toString());
  


      var result = await client.callKw({
        'model': 'ir.attachment',
        'method': 'create',
        'args': [
          {
            'name': name,
            'res_id': res_id,
            'res_model':model,
            'type': 'binary',
            'datas': base64Encode(fileBytes2),
            // 'datas_fname': fileName,
            'mimetype': 'application/pdf',
          },
        ],
        'kwargs': {},
      });
      if (result > 0) {
        _setState(UploadFileState.Uploaded);
        print("uploaded");
        // setState(() {
        //   AwesomeDialog(
        //       context: context,
        //       animType: AnimType.LEFTSLIDE,
        //       headerAnimationLoop: false,
        //       dialogType: DialogType.SUCCES,
        //       showCloseIcon: true,
        //       title: 'تهانينا',
        //       desc: 'تم رفع الملف بنجاح',
        //       btnOkOnPress: () {
        //         debugPrint('OnClcik');
        //       },
        //       btnOkIcon: Icons.check_circle,
        //       onDissmissCallback: (type) {
        //         debugPrint('Dialog Dissmiss from callback $type');
        //       })
        //     ..show();
        //   print(fileBytes2.toString());
        // });
      } else {
        _setState(UploadFileState.Error);
               _setException(FileException("حدثت مشكلة اثناء رفع الملف"));

      }

   } on SocketException {
     _setState(UploadFileState.Error);
     _setException(ConnectionException("مشكلة في الاتصال بالانترنت"));

   }  on TimeoutException{
_setState(UploadFileState.Error);

_setException(MyTimeOutException("استغرق الخادم وقتا طويلا"));

   }on OdooException{
_setState(UploadFileState.Error);
_setException(OdooServerException("مشكلة في الخادم"));
   } on PlatformException{
     _setState(UploadFileState.Error);
        _setException(FileException("حدثت مشكلة اثناء رفع الملف"));

   } on Exception{
_setState(UploadFileState.Error);
        _setException(FileException("حدثت مشكلة اثناء رفع الملف"));


   } catch (e) {
      _setState(UploadFileState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
    }
     }
















// void _openFileExplorer() async {
//   //  setState(() => _loadingPath = true);
//     try {
//    //   _directoryPath = null;
//    //   _paths = (await FilePicker.platform.pickFiles(
//         withData: true,
//         type: pickingType,
//         allowMultiple: _multiPick,
//         onFileLoading: (FilePickerStatus status) => print(status),
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//       setState(() => _loadingPath = false);
//     } catch (ex) {
//       setState(() => _loadingPath = false);

//       print(ex);
//     }
//     if (!mounted) return;

//     setState(() {
//       String fileName = _paths.first.name;
//       final file = File(_paths.first.path);
//       fileBytes2 = file.readAsBytesSync();
//       final hh = base64Encode(fileBytes2);
//       _loadingPath = false;
//       _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
//       print('hany' + base64Encode(fileBytes2));
//     });
//   }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}