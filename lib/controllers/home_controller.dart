import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/enums/widget_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/models/owner.dart';
import 'package:flutter_animated_splash_screen/models/property.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class HomeViewmode extends ChangeNotifier{
final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);


List<Property> _filteredProperties = [];

  List<Property> get filteredproperties => _filteredProperties;




List<Property>   _properties=[];

List<Property>  get properties =>_properties;


_setProperties( List<Property>
probs   ){

  _filteredProperties=probs;
  notifyListeners();
}


filter(String str) {
    var list = [];

    List <Property>  result   = [];
    if (str.isEmpty) {
      result = _properties;
   _setProperties(result);
    } else {
      list = _properties
          .where((file) =>
              file.propertyName.toString().toLowerCase().contains(str.toLowerCase()))
          .toList();
          _setProperties(list);
    }
  }


WidgetState  _state;
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
      //jumaiah!@##@!
    final session =
        await client.authenticate('Jumaiah', 'admin', 'jumaiah!@##@!');

    return session;
  }


fetchOwners()async{
//http://161.35.211.239:8069/api/pt.owner/?query={id,owner_name}

try {
  
  OdooSession session = await  getClient();







} on Exception  {




}


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


 fetchContacts() async {
_setState(WidgetState.Loading);
  try {
    print("BEFORE");
    OdooSession session=    await getClient();
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
      }) as List ;
      print(res1);
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
_properties=properties;
notifyListeners();
      _setState(WidgetState.Loaded);
  } on Exception {
    print("exception");
       _setState(WidgetState.Error);
  }
  
  }




}