import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_splash_screen/controllers/attachments_controller.dart';
import 'package:flutter_animated_splash_screen/controllers/home_controller.dart';
import 'package:flutter_animated_splash_screen/controllers/login_controller.dart';
import 'package:flutter_animated_splash_screen/controllers/new_property_controller.dart';
import 'package:flutter_animated_splash_screen/controllers/upload_file_controller.dart';
import 'package:flutter_animated_splash_screen/screens/animation_screen.dart';
import 'package:flutter_animated_splash_screen/screens/home.dart';
import 'package:flutter_animated_splash_screen/screens/splash.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:flutter_animated_splash_screen/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'example_start_screen.dart';

void sessionChanged(OdooSession sessionId) async {
  print('We got new session ID: ' + sessionId.id);
  // write to persistent storage
}

void loginStateChanged(OdooLoginEvent event) async {
  if (event == OdooLoginEvent.loggedIn) {
    print('Logged in');
  }
  if (event == OdooLoginEvent.loggedOut) {
    print('Logged out');
  }
}

void inRequestChanged(bool event) async {
  if (event) print('Request is executing'); // draw progress indicator
  if (!event) print('Request is finished'); // hide progress indicator
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(
    MultiProvider(
      providers:[
ChangeNotifierProvider.value(value: LoginController()) ,
ChangeNotifierProvider.value(value: AttachmentScreenCOntroller()),
ChangeNotifierProvider.value(value: UploadFileControler()),
ChangeNotifierProvider.value(value: HomeViewmode()),
ChangeNotifierProvider.value(value: NewPropertyController())






      ],
      child: HomePage()),
);
}
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return    MaterialApp(
      
      navigatorKey: navigatorKey,
       localizationsDelegates: [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       
      ],
      supportedLocales: [
        const Locale('ar', 'SA'),
        const   Locale('en', '')
      ],
      scaffoldMessengerKey: scaffoldMessangerKey,
      title: "Al Jumaiah",
      theme: ThemeData(fontFamily: 'Cairo' ,
      primaryColor: AppTheme.primaryColor
      
    
      ),
     debugShowCheckedModeBanner: false,
     routes: {
       Home.pageName:(context)=>Home()
     },
      home: Splashscreen(),
    );
  }
}
var navigatorKey  = GlobalKey<NavigatorState>();
var scaffoldMessangerKey =  GlobalKey<ScaffoldMessengerState>();