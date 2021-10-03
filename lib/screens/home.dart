import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:flutter_animated_splash_screen/screens/details.dart';
import 'package:flutter_animated_splash_screen/screens/signin.dart';
import 'package:flutter_animated_splash_screen/screens/details.dart';

final orpc = OdooClient('http://161.35.211.239:8069');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool isLoading = false;

  @override
  List data;

  // Function to get the JSON data
  Future<dynamic> fetchContacts() async {
    await orpc.authenticate('Jumaiah', 'admin', '123456');

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
    print(result);
    return result;
  }

  Widget buildListItem(Map<String, dynamic> record) {
    var name = record['property_name'];
    var image = base64Decode(record['pt_image']);

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
                  Image.memory(image),
                  new Container(
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
                    child: Text(name[1],
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
            MaterialPageRoute(
              builder: (context) => Details(
                  image: record['pt_image'],
                  pt_id: record['id'],
                  name: record['property_name'][1],
                  location: record['pt_location'],
                  certificate_no: record['pt_certificte_no'],
                  certificate_date: record['pt_certificte_date'],
                  owner: record['owner'][1],
                  property_status: record['property_status']),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Center(
            child: new Text('الجميعة العقارية', textAlign: TextAlign.center)),

        backgroundColor: Colors.amber, // status bar color
        brightness: Brightness.dark, // status bar brightness
      ),
      drawer: NavDrawer(),
      body: Center(
        child: FutureBuilder(
            future: fetchContacts(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final record =
                          snapshot.data[index] as Map<String, dynamic>;
                      return buildListItem(record);
                    });
              } else {
                if (snapshot.hasError) return Text('Unable to fetch data');
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
