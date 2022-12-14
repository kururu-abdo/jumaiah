import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:jumaiah/enums/login_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/models/user.dart';
import 'package:jumaiah/utils/apiResponse.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LoginController extends ChangeNotifier {
  final orpc = OdooClient(BASE_URL);
  static String baseUrl = BASE_URL;
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
        await client.authenticate(DEFAULT_DB2, 'admin', 'jumaiah!@##@!');

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

  Future<OdooSession> auth(String email, String password) async {
    final session = await client.authenticate(
        DEFAULT_DB,
        // DEFAULT_DB3,
        "${email.trim()}",
      //  DEFAULT_DB2,
        //DEFAULT_DB,

        // "${email.trim()}"
        
        //DEFAULT_PASSWORD

        //"${password.toString().trim()}"

        //);

        //  DEFAULT_PASSWORD

        "${password.toString().trim()}"
        
        
        );
    print(session);
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
    sharedPrefs.saveUserType(GUEST);

    sharedPrefs.setLogin(true);
  }

  Future<APIrespnse<dynamic>> login(
      BuildContext context, String email, String password) async {
    _setState(LoginState.Loading);
    try {
      print("INSIDE LOGIN");
      OdooSession session = await
          //get client
          //getClient();
          auth(email, password);
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
            'context': {'bin_size': true},
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
              errorMessage: "???????? ???? ???????????? ???????????????????? ???? ???????? ????????");
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
            errorMessage: "???????? ???? ???????????? ???????????????????? ???? ???????? ????????");
      }
    } on OdooException {
      print("----------------ODOO EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(OdooServerException("?????? ???? ????????????"));
      return APIrespnse<dynamic>(error: true, errorMessage: """?????? ???? ????????????
???????? ???? ???????? ???????? ?? ???????????? ???????????????????? \n
""");
    } on TimeoutException {
      print("----------------TimeOut EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(MyTimeOutException(
          "???????????? ???????????? ???????? ?????????? ???? ???????? ,???????? ?????? ????????"));
      return APIrespnse<dynamic>(
          error: true,
          errorMessage: "???????????? ???????????? ???????? ?????????? ???? ???????? ,???????? ?????? ????????");
    } on SocketException {
      print("----------------SOCKET  EXCEPTION-----------------");
      _setState(LoginState.Error);
      _setException(ConnectionException("?????????? ???? ?????????????? ??????????????????"));
      return APIrespnse<dynamic>(
          error: true, errorMessage: "?????????? ???? ?????????????? ??????????????????");
    } on Exception {
      print("----------------Unknown EXCEPTION-----------------");
      _setState(LoginState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
      return APIrespnse<dynamic>(error: true, errorMessage: "?????? ?????? ??????????");
      //    return APIrespnse<dynamic>(error: true, errorMessage: "?????? ???? ????????????");
    } catch (e) {
      print("DATA...." + e.toString());
      _setState(LoginState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
      return APIrespnse<dynamic>(error: true, errorMessage: "?????? ?????? ??????????");

      return APIrespnse<dynamic>(
          error: true, errorMessage: "???????? ???? ???????????? ???????????????????? ???? ???????? ????????");
    }
  }
}
