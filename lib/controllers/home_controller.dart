import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/models/owner.dart';
import 'package:jumaiah/models/property.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class HomeViewmode extends ChangeNotifier {
  final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  // var subscription = client.sessionStream.listen(sessionChanged);
  // var loginSubscription = client..loginStream.listen(loginStateChanged);
  // var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  List<Property> _filteredProperties = [];

  List<Property> get filteredproperties => _filteredProperties;

  List<Property> _properties = [];

  List<Property> get properties => _properties;

  _setProperties(List<Property> probs) {
    _filteredProperties = probs;
    notifyListeners();
  }

  filter(String str) {
    var list = [];

    List<Property> result = [];
    if (str.isEmpty) {
      result = _properties;
      _setProperties(result);
    } else {
      list = _properties
          .where((file) => file.propertyName
              .toString()
              .toLowerCase()
              .contains(str.toLowerCase()))
          .toList();
      _setProperties(list);
    }
  }

  WidgetState _state;
  WidgetState get state => _state;
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }

  void _setState(WidgetState state) {
    _state = state;
    notifyListeners();
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

  fetchOwners() async {
//http://142.93.55.190:8069/api/pt.owner/?query={id,owner_name}
    OdooSession session;
    try {
      if (sharedPrefs.getUserType() == "GUEST") {
        session = await Auth(DEFAULT_USER, DEFAULT_PASSWORD);
      } else {
        session = await Auth(sharedPrefs.getEmail().trim(),
            sharedPrefs.getUserPassword().trim());
      }
    } on Exception {}
  }

//     init() async  {

// try {
//       // Authenticate to server with db name and credentials
//       final session =
//           await client.authenticate('Bensaad_demo', 'admin', 'bcool1984');
//       print(session);
//       print('Authenticated');

//       final uid = session.userId;
//       var res = await client.callKw({
//         'model': 'res.country',
//         'method': 'search_read',
//         'args': [],
//         'kwargs': {
//           'context': {'bin_size': true},
//           'domain': [
//             ['id', '=', 3]
//           ],
//           'fields': ['id', 'name'],
//         },
//       });
//       print('\nUser info: \n' + res.toString());
//     } catch (e) {}

//     }

  Future<OdooSession> Auth(String email, String password) async {
    print(password);
    final session = await client.authenticate(
        DEFAULT_DB,
        email != null ? email.trim() : DEFAULT_USER,
        password != null ? password.toString().trim() : DEFAULT_PASSWORD);

    return session;
  }

  fetchContacts() async {
    _setState(WidgetState.Loading);
    OdooSession session;
    try {
      // print("BEFORE");
      // if (sharedPrefs.getUserType() == "GUEST") {
      session = await getClient();
      session = await Auth(DEFAULT_DB, DEFAULT_PASSWORD);
      // } else {
      //   session = await Auth(sharedPrefs.getEmail().trim(),
      //       sharedPrefs.getUserPassword().trim());
      // }
      // getClient();
      print(session.dbName);
      print("AFTER");

      var res1 = await client.callKw({
        'model': 'property.base',
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
      List<Property> properties =
          res1.map((p) => Property.fromJson(p)).toList();
      _setProperties(properties);
      _properties = properties;
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

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
