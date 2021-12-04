import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jumaiah/components/nav-drawer.dart';
import 'package:jumaiah/screens/signin.dart';
import 'package:jumaiah/screens/home.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jumaiah/components/hole_painter.dart';
import 'package:jumaiah/components/nav-drawer.dart';

class ExampleStartScreen extends StatefulWidget {
  @override
  _ExampleStartScreenState createState() => _ExampleStartScreenState();
}

class _ExampleStartScreenState extends State<ExampleStartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/11.png",
              fit: BoxFit.fill,
            ),
          ),
          (_loginStatus == 1) ? Home() : SignIn()
        ],
      ),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new SignIn(),
        '/home': (BuildContext context) => new Home(),
      },
    );
  }

  var _loginStatus = 0;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("id");
    });
  }
}
