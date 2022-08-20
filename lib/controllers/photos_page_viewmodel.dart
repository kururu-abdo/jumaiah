import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class PhotosPageViewModel extends ChangeNotifier {
  final orpc = OdooClient(BASE_URL);
  static String baseUrl = BASE_URL;
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  // var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  WidgetState _state;
  WidgetState get state => _state;

  List<String> _photos = [];
  List<String> get photos => _photos;
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }

  _setPhotos(List<String> photos) {
    _photos = photos;
    notifyListeners();
  }

  _setState(WidgetState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<OdooSession> getClient() async {
    var session;
    //jumaiah!@##@!
    if (sharedPrefs.getUserType() == GUEST) {
      session =
          await client.authenticate(DEFAULT_DB, DEFAULT_USER2, 'bcool1984');
    } else {
      session = await client.authenticate(DEFAULT_DB,
          sharedPrefs.getEmail().trim(), sharedPrefs.getUserPassword().trim());
    }

    return session;
  }

  // Future<OdooSession> Auth(String email, String password) async {
  //   print(password);
  //   final session = await client.authenticate(
  //       DEFAULT_DB2,
  //       email != null ? email.trim() : DEFAULT_USER,
  //       password != null ? password.toString().trim() : DEFAULT_PASSWORD);

  //   return session;
  // }

  fetchPhotos(int id) async {
    _setState(WidgetState.Loading);
    OdooSession session;
    try {
      // print("BEFORE");
      // if (sharedPrefs.getUserType() == "GUEST") {
      session = await getClient();
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
          'domain': [
            ["product_template_id", "=", id]
          ],
          'fields': [],
        },
      }) as List;
      log(res1.runtimeType.toString());
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
      List<String> photos = [];

      for (var i = 0; i < res1.length; i++) {
        print("ooooooooooooooooooooooooooooooooooooooooooo");
        print(res1[i]);

        print("ooooooooooooooooooooooooooooooooooooooooooo");

        photos.add(res1[i]['image']);
      }
      _setPhotos(photos);
      _setState(WidgetState.Done);
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

  Uint8List convertImageFromBase64(String base64Image) {
    print("IMGE");
    print(base64Image);
    return base64Decode(
        (base64Image == "" || base64Image == null) ? DEFAULT_IMG : base64Image);
  }
}
