import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/screens/home.dart';

import 'package:flutter_animated_splash_screen/screens/details.dart';
import 'package:flutter_animated_splash_screen/screens/signin.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 8);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/11.png'), fit: BoxFit.cover),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        "assets/logo.png",
                        height: 150,
                        width: 200,
                        alignment: Alignment.center,
                      )),
                      SizedBox(
                        height: 200,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedTextKit(animatedTexts: [
                          WavyAnimatedText(
                            'AL JUMAIAH',
                            textStyle: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.black,
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.w700),
                          )
                        ]),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      CircularProgressIndicator(
                        backgroundColor: Colors.orange,
                        strokeWidth: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
