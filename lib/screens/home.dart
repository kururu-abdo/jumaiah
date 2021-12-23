import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jumaiah/controllers/home_controller.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/main.dart';
import 'package:jumaiah/models/property.dart';
import 'package:jumaiah/screens/add_property.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/custom_transition.dart';
import 'package:jumaiah/utils/error_widget.dart';
import 'package:jumaiah/utils/loader.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:jumaiah/utils/theme.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jumaiah/widgets/propertyItem.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:jumaiah/components/nav-drawer.dart';

import 'package:jumaiah/screens/details.dart';
import 'package:jumaiah/screens/signin.dart';
import 'package:jumaiah/screens/details.dart';
import 'package:provider/provider.dart';

final orpc = OdooClient('http://142.93.55.190:8069');

class Home extends StatefulWidget {
  static const String pageName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("EMAIL:-----" + "   " + sharedPrefs.getEmail() ?? "");
    print("PASSWORD:-----" + "   " + sharedPrefs.getUserPassword() ?? "");
    Future.microtask(() async {
      await context.read<HomeViewmode>().fetchContacts();
    });
  }

  List data;

  // Function to get the JSON data
  Future<dynamic> fetchContacts() async {
    await orpc.authenticate('Jumaiah', 'admin', 'bcool1984');

    var result = await orpc.callKw({
      'model': 'property.base',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': false},
        'domain': [],
        'fields': [
          'property_name',
          'id',
          'pt_location',
          'pt_image',
          'owner',
          'property_status',
          'pt_certificte_no',
          'pt_certificte_date'
        ],
        'limit': 1000000,
      },
    });
    print("this is the result " + result);
    print("this is the status code");
    return result;
  }

  Widget buildListItem(Property record) {
    // var name = record['property_name'];
    // var image = base64Decode(record['pt_image']);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      title: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: new Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
          padding: EdgeInsets.all(1.0),
          margin: EdgeInsets.all(1.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Hero(
                      tag: record.id.toString(),
                      child: Image.memory(base64Decode(
                          record.ptImage.toString().trim() == "false"
                              ? DEFAULT_IMG
                              : record.ptImage.toString()))),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10.0, // soften the shadow
                          spreadRadius: 10.0, //extend the shadow
                          offset: Offset(
                            3.0, // Move to right 10  horizontally
                            3.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Text(
                        // "",
                        //  record.propertyName.toString(),

                        record.propertyName.toString(),

                        // "",
                        //  record.propertyName.toString(),
                        // "",
                        //  record.propertyName.toString(),

// record.propertyName,

                        //       record.propertyName.last.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
              Details(record.id,
                  image: record.ptImage.toString(),
                  website: record.website,
                  prop_lat: record.propLat.toString ?? "",
                  pt_id: record.id,
                  name: record.propertyName,
                  location: record.ptLocation,
                  certificate_no: record.ptCertificteNo,
                  certificate_date: record.ptCertificteDate.toString(),
                  owner: record.owner,
                  property_status: record.propertyStatus),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<HomeViewmode>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        // ignore: unnecessary_new
        child: new Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Center(
                child: Text('الجميعة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black))),
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0, // status bar color
            // ignore: deprecated_member_use
            brightness: Brightness.dark,
            actions: [
              IconButton(
                  onPressed: () async {
                    await model.fetchContacts();
                  },
                  icon: Icon(Icons.refresh, color: Colors.black))
            ], // status bar brightness
          ),
          drawer: NavDrawer(),
          body: ListView(
            children: [
              Card(
                margin: EdgeInsets.only(left: 10, right: 10),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                //padding: EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (val) => model.filter(val),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: AppTheme.primaryColor,
                      labelText: 'بحث',
                      suffixIcon:
                          Icon(Icons.search, color: AppTheme.primaryColor),
                      prefixIcon:
                          Icon(Icons.tune, color: AppTheme.primaryColor)),
                ),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "العقارات",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.5),
                    ),
                  )),
              Container(
                  height:

                      //double.infinity,

                      MediaQuery.of(context).size.height * 2 / 3,
                  child: Consumer<HomeViewmode>(builder: (context, model, _) {
                    if (model.state == WidgetState.Loading) {
                      return LoadingWidget();
                    } else if (model.state == WidgetState.Error) {
                      return Center(
                          child: CustomErrorWidget(
                        error: model.exception,
                        onPressBtn: () async {
                          await model.fetchContacts();
                        },
                      ));
                    }
                    return GridView.count(
                      crossAxisCount: 2,
                      children: model.filteredproperties
                          .map((e) => PropertyWidget(
                                record: e,
                              ))
                          .toList(),
                    );
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: model.filteredproperties.length,
                      // primary: false,
                      // padding: const EdgeInsets.all(4),
                      // crossAxisSpacing: 4,
                      // mainAxisSpacing: 4,
                      // crossAxisCount: 2,
                      // children: model.filteredproperties
                      //     .map((record) => PropertyWidget(
                      //           record: record,
                      //         ))
                      //     .toList(),
                      itemBuilder: (BuildContext context, int index) {
                        return PropertyWidget(
                          record: model.filteredproperties[index],
                        );
                      },
                    );
                  })

                  // FutureBuilder(
                  //     future: fetchContacts(),
                  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //       if (snapshot.hasData) {
                  //         return ListView.builder(
                  //             itemCount: snapshot.data.length,
                  //             itemBuilder: (context, index) {
                  //               final record =
                  //                   snapshot.data[index] as Map<String, dynamic>;
                  //               return buildListItem(record);
                  //             });
                  //       } else {
                  //         if (snapshot.hasError) return Text('Unable to fetch data');
                  //         return CircularProgressIndicator();
                  //       }
                  //     }),

                  ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "floating",
            onPressed: () {
              if (sharedPrefs.getUserType() == "GUEST") {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                    action: SnackBarAction(
                      label: 'حسنا',
                      onPressed: () {
                        sharedPrefs.setLogin(false);
                        sharedPrefs.saveUserType(null);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                        preferences.clear();
                      },
                      textColor: Colors.white,
                      disabledTextColor: Colors.grey,
                    ),
                    duration: const Duration(seconds: 8),
                    content: Text("غير مصرح لك بإضافة عقار قم بالتسجيل ")));
              } else {
                ///TODO:  show snackbar
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProperyScreen()));
              }
            },
            backgroundColor: AppTheme.primaryColor,
            icon: Icon(Icons.add_business_rounded),
            label: Text('اضافة عقار'),
          ),
        ),
      ),
    );
  }
}
