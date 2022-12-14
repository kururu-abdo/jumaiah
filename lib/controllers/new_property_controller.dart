import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:jumaiah/enums/upload_file_state.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/models/owner.dart';
import 'package:jumaiah/models/property_type.dart';
import 'package:jumaiah/utils/apiResponse.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:stacked/stacked.dart';

class NewPropertyController extends BaseViewModel {
  final orpc = OdooClient(BASE_URL);
  static String baseUrl =BASE_URL;
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  HijriCalendar _hijriDate;

  _setHijriDate(HijriCalendar date) {
    _hijriDate = date;
    print("FOMATTED........" + getFormatedHijri(_hijriDate).toString());
    notifyListeners();
  }

  HijriCalendar get hijriDate {
    if (_hijriDate != null) {
      print("SETTER");
      return _hijriDate;
    } else {
      return HijriCalendar.now();
    }
  }

  String fileName;
  bool isShow = true;
  setShow(bool value) {
    isShow = value;
    notifyListeners();
  }

  List<PlatformFile> paths;

  Uint8List fileBytes2;

  String directoryPath;

  String extension;

  bool loadingPath = false;

  bool multiPick = false;

  FileType pickingType = FileType.any;
  File _file;
  File get file => _file;
  List<Owner> _owners = [];
  List<Owner> get owners => _owners;
  int _owner;
  int get owner => _owner;
  List<ProprtyType> _types = [];
  List<ProprtyType> get types => _types;

  int _proprtyType;
  int get proprtyType => _proprtyType;

  _setPropertType(int proprtyType) {
    _proprtyType = proprtyType;
    notifyListeners();
  }

  _updateFile(File file) {
    _file = file;
    notifyListeners();
  }

  _setOwner(int owner) {
    _owner = owner;
    notifyListeners();
  }

  Map _status = {"draft": "??????????", "ok": "?????? ??????????", "cancel": "??????????"};
  Map get status => _status;

  String _selectedStatus;
  String get selectedStatus => _selectedStatus;

  _updateStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
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

  _updateOwners(List<Owner> owners) {
    _owners = owners;
    notifyListeners();
  }

  updateFile(File file) {
    _file = file;
    notifyListeners();
  }

  _updatePropertyTypes(List<ProprtyType> types) {
    _types = types;
    notifyListeners();
  }

  openFileExplorer() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', "jpeg"],
        onFileLoading: (FilePickerStatus status) {
          if (status == FilePickerStatus.done) {
            _setState(WidgetState.Loaded);
          } else {
            _setState(WidgetState.Loading);
          }
        },
      );

      if (result != null) {
        File file = File(result.files.single.path);
        _file = file;
        fileBytes2 = file.readAsBytesSync();

        notifyListeners();
        fileName = result.files.first.name;
        notifyListeners();
        directoryPath = result.files.first.path;

        notifyListeners();
        _setState(WidgetState.Loaded);
      } else {
        _setState(WidgetState.Error);
        _setException(UnknownException("?????? ?????? ??????????"));
        // User canceled the picker
      }
    } on PlatformException {
      ;
      _setState(WidgetState.Error);
      _setException(FileException("???????? ?????????? ?????????? ?????? ??????????"));
    } on Exception {
      _setState(WidgetState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
    } catch (e) {
      _setState(WidgetState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
    }
  }

  // Future<OdooSession> getClient() async {
  //   //jumaiah!@##@!
  //   final session =
  //       await client.authenticate('Jumaiah', 'admin', 'jumaiah!@##@!');

  //   return session;
  // }

  Future<APIrespnse<int>> savePropertyName(String name) async {
    OdooSession session;
    try {
      session = await getClient();

      var result = await client.callKw({
        'model': 'property.names',
        'method': 'create',
        'args': [
          {
            "property_name": name,
// "user_name":1,
// "owner": 1,
// "company_id":1
          },
        ],
        'kwargs': {},
      });

      print(result);
      setShow(true);
      return APIrespnse<int>(data: int.parse(result.toString()), error: false);
    } on OdooException {
      print("odoo server error");
      return APIrespnse<int>(error: true, errorMessage: "?????? ???? ????????????");
    } on SocketException {
      print("socket");
      _setState(WidgetState.Error);
      _setException(ConnectionException(" ?????????? ???? ?????????????? ??????????????????"));
      return APIrespnse<int>(
          error: true, errorMessage: " ?????????? ???? ?????????????? ??????????????????");
    } on TimeoutException {
      _setState(WidgetState.Error);
      _setException(MyTimeOutException(" ?????????? ???????? ?????????????? ??????????????"));
      return APIrespnse<int>(
          error: true, errorMessage: " ?????????? ???????? ?????????????? ?????????????? ");
    } on Exception {
      print("exception");
      _setState(WidgetState.Error);
      _setException(UnknownException(" ?????? ?????? ??????????"));
      return APIrespnse<int>(error: true, errorMessage: "?????? ?????? ??????????");
    } catch (e) {
      _setState(WidgetState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
    }
  }

  fetchPropertyTyps() async {
    OdooSession session;
//http://142.93.55.190:8069/api/pt.owner/?query={id,owner_name}
    _updatePropertyTypes([]);
    _setState(WidgetState.Loading);
    try {
      session = await getClient();

      print("company" + session.companyId.toString());
      print("user" + session.userName.toString());
      print("company" + session.companyId.toString());

      var res = await client.callKw({
        'model': 'property.types',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': false},
          'domain': [
            // ['id', '=', uid],
          ],
          'fields': [
            'id',
            'property_type',
          ],
        },
      }) as List;
      _updatePropertyTypes([]);

      List<ProprtyType> list = res.map((e) => ProprtyType.fromJson(e)).toList();

      _updatePropertyTypes(list);
      setShow(true);
      _setState(WidgetState.Loaded);
    } on OdooException {
      print("odoo server error");
      setShow(false);
      _setState(WidgetState.Error);
      _setException(OdooServerException(" ?????? ???? ????????????"));
    } on SocketException {
      print("socket");
      _setState(WidgetState.Error);
      _setException(ConnectionException(" ?????????? ???? ?????????????? ??????????????????"));
      setShow(false);
    } on TimeoutException {
      _setState(WidgetState.Error);
      _setException(MyTimeOutException(" ?????????? ???????? ?????????????? ??????????????"));
      setShow(false);
    } on Exception {
      _setState(WidgetState.Error);
      _setException(UnknownException());
      setShow(false);
    } catch (e) {
      _setState(WidgetState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
    }
  }

  fetchOnwers() async {
    _setState(WidgetState.Loading);
    _updateOwners([]);

    //(http://142.93.55.190:8069/api/property.types/?query={id,property_type})
    OdooSession session;
    try {
      session = await getClient();

      print("///////////////////////////////////////////");

      var res = await client.callKw({
        'model': 'pt.owner',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': false},
          'domain': [
            // ['id', '=', uid],
          ],
          'fields': [
            'id',
            'owner_name',
          ],
        },
      }) as List;
      _updateOwners([]);

      print(res.toString());
      List<Owner> list = res.map((e) => Owner.fromJson(e)).toList();

      _updateOwners(list);
      _setState(WidgetState.Loaded);
      setShow(true);
    } on OdooException {
      print("odoo server error");
      setShow(false);
      _setState(WidgetState.Error);
      _setException(OdooServerException(" ?????? ???? ????????????"));
    } on SocketException {
      print("socket");
      _setState(WidgetState.Error);
      _setException(ConnectionException(" ?????????? ???? ?????????????? ??????????????????"));
      setShow(false);
    } on TimeoutException {
      _setState(WidgetState.Error);
      _setException(MyTimeOutException(" ?????????? ???????? ?????????????? ??????????????"));
      setShow(false);
    } on Exception {
      _setState(WidgetState.Error);
      _setException(UnknownException());
      setShow(false);
    } catch (e) {
      _setState(WidgetState.Error);

      _setException(UnknownException("?????? ?????? ??????????"));
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

  updateOwner(int owner) {
    _owner = owner;
    notifyListeners();
  }

  updateStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  updateProperty(int proprtyType) {
    _proprtyType = proprtyType;
    notifyListeners();
  }

  uploadImage(
      String name, String model, dynamic res_id, Uint8List bytes) async {
    _setState(WidgetState.Loading);
    try {
      var result = await client.callKw({
        'model': 'ir.attachment',
        'method': 'create',
        'args': [
          {
            'name': name,
            'res_id': res_id,
            'res_model': model,
            'type': 'binary',
            'datas': base64Encode(fileBytes2),
            'datas_fname': DateTime.now().microsecondsSinceEpoch.toString(),
            'mimetype': 'application/pdf',
          },
        ],
        'kwargs': {},
      });
      if (result > 0) {
        _setState(WidgetState.Loaded);
        print("uploaded");
        // setState(() {
        //   AwesomeDialog(
        //       context: context,
        //       animType: AnimType.LEFTSLIDE,
        //       headerAnimationLoop: false,
        //       dialogType: DialogType.SUCCES,
        //       showCloseIcon: true,
        //       title: '??????????????',
        //       desc: '???? ?????? ?????????? ??????????',
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
        _setState(WidgetState.Error);
        _setException(FileException("???????? ?????????? ?????????? ?????? ??????????"));
      }
    } on Exception {
      _setState(WidgetState.Error);
    }
  }

  refresh() {
    _setState(WidgetState.Loaded);
  }

  addPropery(
      String property_name,
      String ownerName,
      String pt_location,
      String property_status,
      String pt_certificte_no,
      String property_type,
      Uint8List fileBytes2,
      String ceriticateDate,
      String address,
      String website) async {
    setShow(false);
    _setState(WidgetState.Loading);
    OdooSession session;
    try {
      session = await getClient();

      var res = await client.callKw({
        'model': 'property.base',
        'method': 'create',
        'args': [
          {
            "company_id": 1,
            "name": "New",
            "user_name": 1,
            // 'date': getFormattedDateOfToday(),
            'pt_certificte_date': ceriticateDate != null && ceriticateDate != ""
                ? ceriticateDate
                : getFormattedDateOfToday2(HijriCalendar.now()),
            'pt_location': pt_location.trim(),
            'property_type': property_type, //?????? ??????????????
            'pt_certificte_no': pt_certificte_no.trim(),
            'property_status': property_status.trim(),
            'property_name': property_name,
            'owner': ownerName,
            'pt_image': fileBytes2 != null ? base64Encode(fileBytes2) : "",
            'prop_lat': address,
            "website": website
          },
        ],
        'kwargs': {},
      });
      print("/////////////////////////////////////////");
      print(res.toString());

      _setState(WidgetState.Done);
    } on OdooException catch (e) {
      print("odoo server error");
      print(e.message);
      setShow(false);
      _setState(WidgetState.Error);
      _setException(OdooServerException(" ?????? ???? ????????????"));
    } on SocketException {
      print("socket");
      _setState(WidgetState.Error);
      _setException(ConnectionException(" ?????????? ???? ?????????????? ??????????????????"));
      setShow(false);
    } on TimeoutException {
      _setState(WidgetState.Error);
      _setException(MyTimeOutException(" ?????????? ???????? ?????????????? ??????????????"));
      setShow(false);
    } on Exception catch (e) {
      print(e);
      _setState(WidgetState.Error);
      _setException(UnknownException());
      setShow(false);
    } catch (e) {
      _setState(WidgetState.Error);
      print(e);

      _setException(UnknownException("?????? ?????? ??????????"));
    }
  }

  Future shaowHijriPicker(BuildContext context) async {
    final HijriCalendar picked = await showHijriDatePicker(
        context: context,
        initialDate: _hijriDate ?? HijriCalendar.now(),
        lastDate: HijriCalendar()
          ..hYear = 1450
          ..hMonth = 9
          ..hDay = 25,
        firstDate: HijriCalendar()
          ..hYear = 1438
          ..hMonth = 12
          ..hDay = 25,
        initialDatePickerMode: DatePickerMode.day,
        locale: new Locale("en", ""));
    print("DATE......." + picked.toString());
    _setHijriDate(picked);
    return picked;
  }

  String fromHijriToGoergian() {
    var g_date = HijriCalendar();
    g_date.hijriToGregorian(1415, 7, 27);
  }

  String getFormattedDateOfToday() {
    DateTime now = DateTime.now();
    return DateFormat("yyyy-MM-dd").format(now);
  }

  String getFormattedHijriDateOfToday() {
    // DateTime now = DateTime.now();
    // return DateFormat("yyyy-MM-dd").format(now);
    var today = HijriCalendar.now();

    HijriCalendar.setLocal("en_US").toFormat("yyyy/MM/dd");
    print("JIJRI DATE");
    print(today.toString());
    return "today";
  }

  String getFormatedHijri(HijriCalendar date) {
    // DateTime now = DateTime.now();
    // return DateFormat("yyyy-MM-dd").format(now);
    // DateFormat('yyyy-MM-dd').format(HijriCalendar.t);
    //                   print(formattedDate); //formatted date output using intl package =
    return date.toFormat("yyyy/mm/dd");
    return HijriCalendar.now().toFormat("yyyy/MM/dd");
  }

  String getFormattedDateOfToday2(HijriCalendar selectedHijri) {
    DateTime now = DateTime.now();
    var g_date = HijriCalendar();

    var mydate = g_date.hijriToGregorian(
        selectedHijri.hYear, selectedHijri.hMonth, selectedHijri.hDay);

    return intl.DateFormat("yyyy/MM/dd").format(mydate);
  }
}
