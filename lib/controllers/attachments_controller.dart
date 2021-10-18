
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/enums/attachment_state.dart';
import 'package:flutter_animated_splash_screen/utils/constants.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class AttachmentScreenCOntroller extends ChangeNotifier{


List<dynamic>  filterRecodes = [];
List<dynamic> get recorders =>   filterRecodes;
List<dynamic> mainRecorders = [];

AttachmentScreenState _state;

AttachmentScreenState get state => _state;
AppException   _exception;
AppException  get  exception =>_exception;
void _setState(AttachmentScreenState state) {
  _state=state;
  notifyListeners();
}
void _setException(AppException   exception) {
_exception =exception;
notifyListeners();
}

void _updateRecords(List recordes){
  filterRecodes =recordes;
  notifyListeners();
}



final orpc = OdooClient('http://142.93.55.190:8069/');

static const  GMAIL_SCHEMA = 'com.google.android.gm';
  final Future<bool> gmailinstalled =
      FlutterMailer.isAppInstalled(GMAIL_SCHEMA);


 fetchContacts(dynamic pt_id) async {
   _setState(AttachmentScreenState.Lading);
   OdooSession session;
try {
  
   
 if (sharedPrefs.getUserType() == "GUEST") {
        session = await Auth(DEFAULT_DB, DEFAULT_PASSWORD);
      } else {
        session = await Auth(sharedPrefs.getEmail().trim(),
            sharedPrefs.getUserPassword().trim());
      }



      var result = await orpc.callKw({
        'model': 'ir.attachment',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['res_id', '=', pt_id]
          ],
          'fields': [],
          'limit': 80,
        },
      });
   if(result ==null || result.length<1){
   _setState(AttachmentScreenState.Error);
_setException(NoData404Exception(
            "لم يتم العثور على مرفقات"));
   }
      
      _setState(AttachmentScreenState.Loaded);
      mainRecorders = result;
      notifyListeners();
      _updateRecords(result);
}  on OdooException{
   _setState(AttachmentScreenState.Error);
   _setException(OdooServerException("خطأ في الخادم"));
}on TimeoutException{
   _setState(AttachmentScreenState.Error);
  _setException(MyTimeOutException("إستغرق الخادم وقتا طويلا في الاستجابة , حاول مجددا"));
} on SocketException{
   _setState(AttachmentScreenState.Error);
   _setException(ConnectionException("مشكلة في الاتصال بالانترنت"));

} on Exception{
   _setState(AttachmentScreenState.Error);

   _setException(UnknownException("خطأ  غير متوقع  "));


} catch (e) {
      _setState(AttachmentScreenState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
    }
    
  }



 Future<OdooSession> Auth(String email, String password) async {
    print(password);
    final session = await orpc.authenticate(
        'Jumaiah',
        DEFAULT_DB
       // "${email.trim()}" ?? DEFAULT_USER
        ,
        DEFAULT_PASSWORD
        //password.toString().trim() ?? DEFAULT_PASSWORD
        );

    return session;
  }






filter(String str){
  var list=[];
  
    List result = [];
   if(str.isEmpty){
     result= mainRecorders;
     _updateRecords(result);
   }else {
  list = mainRecorders
          .where((file) =>
              file['name'].toString().toLowerCase().contains(str.toLowerCase()))
          .toList();
      _updateRecords(list);
   }






}





}