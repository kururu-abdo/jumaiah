import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_splash_screen/screens/animation_screen.dart';
import 'package:flutter_animated_splash_screen/screens/home.dart';
import 'package:flutter_animated_splash_screen/screens/splash.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'example_start_screen.dart';

void main() {
  runApp(MaterialApp(
    home: Splashscreen(),
  ));
}
