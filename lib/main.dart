import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumaiah/controllers/add_photo_controller.dart';
import 'package:jumaiah/controllers/attachments_controller.dart';
import 'package:jumaiah/controllers/home_controller.dart';
import 'package:jumaiah/controllers/login_controller.dart';
import 'package:jumaiah/controllers/new_property_controller.dart';
import 'package:jumaiah/controllers/photos_page_viewmodel.dart';
import 'package:jumaiah/controllers/upload_file_controller.dart';
import 'package:jumaiah/screens/animation_screen.dart';
import 'package:jumaiah/screens/home.dart';
import 'package:jumaiah/screens/splash.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:jumaiah/utils/theme.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider.value(value: LoginController()),
      ChangeNotifierProvider.value(value: AttachmentScreenCOntroller()),
      ChangeNotifierProvider.value(value: UploadFileControler()),
      ChangeNotifierProvider.value(value: HomeViewmode()),
      // InheritedProvider<NewPropertyController>(
      //   create: (_) => NewPropertyController(),
      //   dispose: (_, NewPropertyController provider) => provider.dispose(),
      // ),
      // ChangeNotifierProvider.value(value: NewPropertyController()),
      // InheritedProvider<AddPhotoController>(
      //   create: (_) => AddPhotoController(),
      //   dispose: (_, AddPhotoController provider) => provider.dispose(),
      // ),
      // ChangeNotifierProvider.value(value: AddPhotoController()),
      ChangeNotifierProvider.value(value: PhotosPageViewModel())
    ], child: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> implements WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        const Locale('ar', 'SA'),
        const Locale('en', 'US')
      ],
      scaffoldMessengerKey: scaffoldMessangerKey,
      title: "Al Jumaiah",
      theme:
          ThemeData(fontFamily: 'Cairo', primaryColor: AppTheme.primaryColor),
        
      debugShowCheckedModeBanner: false,
      routes: {Home.pageName: (context) => Home()},
      home: Splashscreen(),
    );
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
    } else {}
  }

  @override
  void didChangeLocales(List<Locale> locales) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute

    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }
}

var navigatorKey = GlobalKey<NavigatorState>();
var scaffoldMessangerKey = GlobalKey<ScaffoldMessengerState>();
