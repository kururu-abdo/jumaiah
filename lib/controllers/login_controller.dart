import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_splash_screen/enums/login_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/models/user.dart';
import 'package:flutter_animated_splash_screen/utils/apiResponse.dart';
import 'package:flutter_animated_splash_screen/utils/constants.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LoginController extends ChangeNotifier {
  final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  // var loginSubscription = client.loginStream.listen(loginStateChanged);
  // var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  LoginState _state;
  LoginState get state => _state;
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }

  Future<OdooSession> getClient() async {
    final session =
        await client.authenticate('Jumaiah', 'admin', 'jumaiah!@##@!');

    return session;
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
        'Jumaiah',
        DEFAULT_DB

        // "${email.trim()}"
        ,
        DEFAULT_PASSWORD

        //"${password.toString().trim()}"

        );

    return session;
  }

  void _setState(LoginState state) {
    _state = state;
    notifyListeners();
  }

  loginAsGuest(BuildContext context) async {
    sharedPrefs.saveName("Guest");
    sharedPrefs.saveLogin("company");
    sharedPrefs.saveID("1");
    sharedPrefs.saveTZ("Africa");
    sharedPrefs.saveLang("En");
    sharedPrefs.saveUserType("GUEST");

    sharedPrefs.setLogin(true);
  }

  Future<APIrespnse<dynamic>> login(
      BuildContext context, String email, String password) async {
    _setState(LoginState.Loading);
    try {
      OdooSession session = await

          // getClient();
          Auth(email, password);
      print(session);
      if (session != null) {
        print(session.userName);

        print(session.userTz);

        sharedPrefs.saveName(session.userName);
        sharedPrefs.saveLogin(session.userLogin);
        sharedPrefs.saveID(session.userId);
        sharedPrefs.saveTZ(session.userTz);
        sharedPrefs.saveLang(session.userLang);

        var uid = session.userId;
        print(uid);
        var res = await client.callKw({
          'model': 'res.users',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'context': {'bin_size': false},
            'domain': [
              ["id", "=", uid]
              // ['password', '=', password.trim() ,
              // "email" ,"=",email.trim()],
            ],
            'fields': [
              // 'id',
              // 'name',
              // // '__last_update',
              // 'login',
              // // 'password',

              // 'tz',
              // "image"
            ],
          },
        }) as List;
        print(res.toString());

        if (res.length <= 0) {
          _setState(LoginState.Initial);
          print("INIDE ERROR BLOCK");
          _setState(LoginState.Error);
          return APIrespnse<dynamic>(
              error: true,
              errorMessage: "تأكد من البريد الإلكتروني أو كلمة السر");
        }

        _setState(LoginState.Initial);

        Iterable I = res;
        print("|||||||||||||||||||||||||||||||||||||||||||||||||||");
        print(I.first['image']);
        OdooUser odooUser = OdooUser.fromJson(I.first);
        sharedPrefs.saveImage(odooUser.image);
        sharedPrefs.setLogin(true);
        sharedPrefs.saveEmail(email);
        sharedPrefs.saveUserPassword(password);
        return APIrespnse<dynamic>(error: false, data: odooUser);
      } else {
        return APIrespnse<dynamic>(
            error: true,
            errorMessage: "تأكد من البريد الإلكتروني أو كلمة السر");
      }
    } on OdooException {
      print("----------------ODOO EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(OdooServerException("خطأ في الخادم"));
      return APIrespnse<dynamic>(error: true, errorMessage: """خطأ في الخادم
تأكد من كلمة السر و البريد الالكتروني \n
""");
    } on TimeoutException {
      print("----------------TimeOut EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(MyTimeOutException(
          "إستغرق الخادم زمنا طويلا في الرد ,حاول مرة أخرى"));
      return APIrespnse<dynamic>(
          error: true,
          errorMessage: "إستغرق الخادم زمنا طويلا في الرد ,حاول مرة أخرى");
    } on SocketException {
      print("----------------SOCKET  EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(ConnectionException("مشكلة في الاتصال بالإنترنت"));
      return APIrespnse<dynamic>(
          error: true, errorMessage: "مشكلة في الاتصال بالإنترنت");
    } on Exception {
      print("----------------Unknown EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(OdooServerException("خطأ في الخادم"));
      return APIrespnse<dynamic>(error: true, errorMessage: "خطأ في الخادم");
    } catch (e) {
      print("DATA...." + e.toString());
      _setState(LoginState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
      return APIrespnse<dynamic>(
          error: true, errorMessage: "تأكد من البريد الإلكتروني أو كلمة السر");
    }
  }
}
