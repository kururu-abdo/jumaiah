
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/enums/widget_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/utils/constants.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class PhotosPageViewModel extends ChangeNotifier {

    final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  WidgetState  _state;
  WidgetState get state => _state;

   List<String> _photos;
       List<String>  get photos =>_photos;
 AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }
_setPhotos(   List<String> photos){
  _photos = photos;
  notifyListeners();
}

_setState(WidgetState newState){
  _state = newState;
  notifyListeners();

}
 Future<OdooSession> Auth(String email, String password) async {
    print(password);
    final session = await client.authenticate(
        DEFAULT_DB2,
        email != null ? email.trim() : DEFAULT_USER,
        password != null ? password.toString().trim() : DEFAULT_PASSWORD);

    return session;
  }
fetchPhotos() async{
 _setState(WidgetState.Loading);
    OdooSession session;
    try {
      // print("BEFORE");
      // if (sharedPrefs.getUserType() == "GUEST") {
      session = await Auth(DEFAULT_DB, DEFAULT_PASSWORD);
      // } else {
      //   session = await Auth(sharedPrefs.getEmail().trim(),
      //       sharedPrefs.getUserPassword().trim());
      // }
      // getClient();
      print(session.dbName);
      print("AFTER");

      var res1 = await client.callKw({
         'model': 'multi.images',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': false},
          'domain': [],
          'fields': [],
        },
      }) as List;
      log(res1.toString());
      //  print(res1);
      //  printWrapped(res1.toString());
      // print("this is the result" + res1.toString());
      // var result = await orpc.callKw({
      //    'model': 'property.base',
      //   'method': 'search_read',
      //   'args': [],
      //   'kwargs': {
      //     'context': {'bin_size': true},
      //     'domain': [],
      //     'fields': [],
      //   },
      // })  as List ;
      //   print(result);
      //   print("//////////////////////////////////////////////");
      //  print(result.length);
      List<String> photos =[];
      //     res1.map((p) => Property.fromJson(p)).toList();
      // _setProperties(properties);
      // _properties = properties;
      notifyListeners();
      _setState(WidgetState.Loaded);
    } on Exception catch (e) {
      debugPrint("unexpected||||||||||||||||||" + e.toString());

      print("exception");
      print(e);
      _setState(WidgetState.Error);
    } catch (e) {
      debugPrint("unexpected" + e.toString());
      _setState(WidgetState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
    }
}


}