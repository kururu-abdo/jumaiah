import 'package:flutter_animated_splash_screen/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  static SharedPreferences get instance => _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  void saveName(String name) {
    _sharedPrefs.setString(USER_NAME, name);
  }

  String getName() {
  return  _sharedPrefs.getString(USER_NAME);
  }


  void saveID(dynamic id) {
    _sharedPrefs.setString(USER_ID, id.toString());
  }

  String getID() {
 return   _sharedPrefs.getString(USER_ID);
  }


  void saveLang(dynamic lang) {
    _sharedPrefs.setString(USER_LANG, lang.toString());
  }

  String getLang() {
    return _sharedPrefs.getString(USER_LANG);
  }





  void saveTZ(dynamic tz) {
    _sharedPrefs.setString(USER_TZ, tz.toString());
  }

  String getTZ() {
    return _sharedPrefs.getString(USER_TZ);
  }


  void saveLogin(dynamic login) {
    _sharedPrefs.setString(USER_LOGIN, login.toString());
  }

  String getLogin() {
    return _sharedPrefs.getString(USER_LOGIN);
  }


  void saveImage(dynamic image) {
    _sharedPrefs.setString(IMAGE, image.toString());
  }

  String getImage() {
    return _sharedPrefs.getString(IMAGE);
  }


  void setLogin(bool logged) {
    _sharedPrefs.setBool(ISLOGGEDIN, logged);
  }

  bool checkLoggedIn() {
    return _sharedPrefs.getBool(ISLOGGEDIN);
  }




  String getUserType() {
    return _sharedPrefs.getString(USER_TYPE);
  }
  
  void saveUserType(dynamic type) {
    _sharedPrefs.setString(USER_TYPE, type.toString());
  }
}

var sharedPrefs = SharedPrefs();
