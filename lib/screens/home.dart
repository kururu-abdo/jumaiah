import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/controllers/home_controller.dart';
import 'package:flutter_animated_splash_screen/enums/widget_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/models/property.dart';
import 'package:flutter_animated_splash_screen/screens/add_property.dart';
import 'package:flutter_animated_splash_screen/utils/custom_transition.dart';
import 'package:flutter_animated_splash_screen/utils/loader.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:flutter_animated_splash_screen/utils/theme.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_animated_splash_screen/components/nav-drawer.dart';
import 'package:flutter_animated_splash_screen/screens/details.dart';
import 'package:flutter_animated_splash_screen/screens/signin.dart';
import 'package:flutter_animated_splash_screen/screens/details.dart';
import 'package:provider/provider.dart';

final orpc = OdooClient('http://161.35.211.239:8069');

class Home extends StatefulWidget {
  static const String pageName= "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool isLoading = false;






@override
void initState() {
  super.initState();
  Future.microtask(()async{


await context.read<HomeViewmode>().fetchContacts();


  });
}










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

  Widget buildListItem(Property record) {
    // var name = record['property_name'];
    // var image = base64Decode(record['pt_image']);

    return 
    ListTile(
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
                  Hero(tag:record.id.toString(),
                  
                  
                  child: Image.memory(base64Decode(record.ptImage))),
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
                    child: Text(record.propertyName[1].toString(),
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

              Details(
                record.id,
                  image: record.ptImage,
                  pt_id: record.id,
                  name: record.propertyName[1].toString().trim(),
                  location: record.ptLocation,
                  certificate_no: record.ptCertificteNo,
                  certificate_date: record.ptCertificteDate,
                  owner: record.owner[1],
                  property_status: record.propertyStatus),
          )
            
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<HomeViewmode>(context);
    return Directionality(
      textDirection: TextDirection.rtl ,
      child: SafeArea(
        child: new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: new Center(
                child: new Text('الجميعة القابضة', textAlign: TextAlign.center)),
          
            backgroundColor: Colors.amber, // status bar color
            brightness: Brightness.dark,
            actions: [
              IconButton(onPressed: ()async{
      await model.fetchContacts();
      
              }, icon: Icon(Icons.refresh))
            ], // status bar brightness
          ),
          drawer: NavDrawer(),
          body: Column(
            children: [
          Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  onChanged: (val) => model.filter(val),
                  decoration: InputDecoration(
                      labelText: 'بحث', suffixIcon: Icon(Icons.search)),
                ),
              ),
      
      
      
              Container(
               height: 
               
               //double.infinity,
               
              MediaQuery.of(context).size.height*2/3,
                child:   Consumer<HomeViewmode>(builder: (context , model  ,  _){
      
         if (model.state==WidgetState.Loading) {
      return    LoadingWidget();    
         }
      else if(model.state==WidgetState.Error){
        return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      IconButton(onPressed: ()async{
      await model.fetchContacts();
      }, icon: Icon(Icons.refresh ,  color: AppTheme.primaryColor,)) ,
      Text("حاول مجددا")
      ],
        ),);
      }
      
      
      return   ListView.builder(
        itemCount: model.filteredproperties.length,
        itemBuilder: (BuildContext context, int index) {
          return    buildListItem(model.filteredproperties[index]) ;
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
            onPressed: () {
             if(sharedPrefs.getUserType()=="GUEST"){
 scaffoldMessangerKey.currentState.showSnackBar(
                    SnackBar(
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
 
                      
                      content: Text("غير مصرح لك بإضافة عقار قم بالتسجيل "  ) )   ) ;
                      
                      
                              }else{
               ///TODO:  show snackbar
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProperyScreen()));
             }
            
            },
            backgroundColor: AppTheme.primaryColor,
            icon: Icon(Icons.add_a_photo),
            label: Text('اضافة عقار'),
          ),
        ),
      ),
    );
  }
}
