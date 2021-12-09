import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/models/photoItem.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:stacked/stacked.dart';

class AddPhotoController extends BaseViewModel {
  final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  // var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);
  double _percent = 0.0;
  double get percent => _percent;
  List<PhotoItem> _photos = [];
  List<XFile> _filesToShow = [];
  List<XFile> get filesToShow => _filesToShow;
  List<PhotoItem> get photos => _photos;

  _addPhoto(PhotoItem photo) {
    _photos.add(photo);
    notifyListeners();
  }

  _addFilesToPreview(XFile file) {
    _filesToShow.add(file);
    notifyListeners();
  }

  WidgetState _state;
  WidgetState get state => _state;
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    var snackbar = SnackBar(
      content: Text(exception.message),
    );
    ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(snackbar);
    notifyListeners();
  }

  void _setState(WidgetState state) {
    _state = state;
    notifyListeners();
  }

  Future<OdooSession> getClient() async {
    var session;
    if (sharedPrefs.getUserType() == GUEST) {
      session = await client.authenticate(DEFAULT_DB, 'admin', 'bcool1984');
    } else {
      session = await client.authenticate(DEFAULT_DB,
          sharedPrefs.getEmail().trim(), sharedPrefs.getUserPassword().trim());
    }
    // session = await client.authenticate('test', 'admin', '123456');
    return session;
  }

  removeAction(int index) {
    _photos.removeAt(index);
    _filesToShow.removeAt(index);
    notifyListeners();
  }

  deletImage(context, int index) {
    var alert = AlertDialog(
        title: Text("تنبيه"),
        content: Text("هل تريد حذف الصورة ؟"),
        // shape: CircleBorder(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        actions: <Widget>[
          FlatButton(
            child: Text("إلغاء"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: FlatButton(
                  child: Text(
                    "نعم",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    removeAction(index);
                    Navigator.of(context).pop();
                  })),
        ]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  picImage(int id) async {
    if (_photos.length < 3) {
      final ImagePicker _picker = ImagePicker();

      final XFile image = await _picker.pickImage(source: ImageSource.gallery);

      var photo = PhotoItem(
          product_template_id: id,
          title: image.name,
          description: image.name,
          image: await convertToBase64(image));
      _addPhoto(photo);
      _addFilesToPreview(image);
    }
  }

  _updatePercentage(double percent) {
    print("PROGRESS...." + percent.toString());
    _percent = percent;
    notifyListeners();
  }

  Future<String> convertToBase64(XFile file) async {
    var bytes = await file.readAsBytes();
    var strFile = base64Encode(bytes);
    return strFile;
  }

  uploadPhotos(BuildContext context) async {
    _setState(WidgetState.Loading);
    OdooSession session;

    try {
      session = await getClient();

      for (var i = 0; i < _photos.length; i++) {
        var res1 = await client.callKw({
          'model': 'multi.images',
          'method': 'create',
          'args': [_photos[i]],
          'kwargs': {},
        });
        _updatePercentage((i + 1) * 33.3333333);
      }
      _setState(WidgetState.Done);

      // print(res1);
      // int res = int.parse(res1.toString());
      // if (res.runtimeType == int) {
      //   _setState(WidgetState.Done);
      _updatePercentage(0.0);
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              child: SizedBox.expand(
                  child: Material(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/done.gif"),
                      Text("تم رفع الصور بنجاح"),
                    ],
                  ),
                ),
              )),
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    } on OdooSession {
      print("-------------SERVER EXCEPTION-----------");
      _setState(WidgetState.Error);
      _setException(OdooServerException("خطأ في الخادم"));
    } on TimeoutException {
      print("----------------TimeOut EXCEPTION-----------------");
      _setState(WidgetState.Error);
      _setException(MyTimeOutException(
          "إستغرق الخادم زمنا طويلا في الرد ,حاول مرة أخرى"));
    } on SocketException {
      print("----------------SOCKET  EXCEPTION-----------------");
      _setState(WidgetState.Error);
      _setException(ConnectionException("مشكلة في الاتصال بالإنترنت"));
    } on Exception catch (e) {
      debugPrint("unexpected||||||||||||||||||" + e.toString());

      print("exception");
      print(e);
      _setState(WidgetState.Error);
      _setException(UnknownException("خطأ غير متوقع"));
    } catch (e) {
      debugPrint("unexpected" + e.toString());
      _setState(WidgetState.Error);

      _setException(UnknownException("خطأ غير متوقع"));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _filesToShow = [];
    _photos = [];
    _state = WidgetState.Done;
    notifyListeners();
  }
}
