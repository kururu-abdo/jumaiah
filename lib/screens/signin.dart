import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/controllers/login_controller.dart';
import 'package:flutter_animated_splash_screen/enums/login_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/screens/home.dart';
import 'package:flutter_animated_splash_screen/utils/validations.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_splash_screen/screens/details.dart';

final orpc = OdooClient('http://142.93.55.190:8069');

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    var controller = Provider.of<LoginController>(context);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/12.png'), fit: BoxFit.cover),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: Image.asset(
                            "assets/logo.png",
                            height: 130,
                            width: 200,
                            alignment: Alignment.center,
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 45),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: bottom),
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          onFieldSubmitted: (val) {
                                            passwordFocus.requestFocus();
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          controller: _emailController,
                                          focusNode: emailFocus,
                                          decoration: InputDecoration(
                                            hintText: "البريد الالكتروني",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintStyle: TextStyle(
                                                color: Colors.amber.shade800,
                                                fontSize: 15),
                                          ),
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return "الرجاء  إدخال البريد الالكتروني";
                                            }
                                            if (!Validations.isValidEmail(
                                                val)) {
                                              return "البريد الإلكتروني غير صالح";
                                            }

                                            return null;
                                          },
                                          onSaved: (val) {
                                            email = val;
                                          },
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          obscureText: !isShow,
                                          controller: _passwordController,
                                          focusNode: passwordFocus,
                                          decoration: InputDecoration(
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isShow = !isShow;
                                                });
                                              },
                                              child: Icon(
                                                  isShow
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            hintText: "كلمة المرور",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintStyle: TextStyle(
                                                color: Colors.amber.shade800,
                                                fontSize: 15),
                                          ),
                                          onSaved: (val) {
                                            password = val;
                                          },
                                          validator: (val) {
                                            if (val == null || val == "") {
                                              return "هذا الحقل مطلوب";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  var response =
                                                      await controller.login(
                                                          context,
                                                          _emailController.text
                                                              .trim(),
                                                          _passwordController
                                                              .text
                                                              .trim());

                                                  if (!response.error) {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, "/home");
                                                  } else {
                                                    scaffoldMessangerKey
                                                        .currentState
                                                        .showSnackBar(SnackBar(
                                                            content: Text(response
                                                                .errorMessage)));
                                                  }

                                                  // if (isLoading) {
                                                  //   return;
                                                  // }
                                                  // if (_emailController
                                                  //         .text.isEmpty ||
                                                  //     _passwordController
                                                  //         .text.isEmpty) {
                                                  //   _scaffoldKey.currentState
                                                  //       .showSnackBar(SnackBar(
                                                  //           content: Text(
                                                  //               "يرجي تعبئة جميع الحقول")));
                                                  //   return;
                                                  // }
                                                  // login(
                                                  //     context,
                                                  //     _emailController.text,
                                                  //     _passwordController.text);
                                                  // setState(() {
                                                  //   isLoading = true;
                                                  // });
                                                }
                                                //Navigator.pushReplacementNamed(context, "/home");
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 0),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors
                                                          .amber.shade800),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  "دخول",
                                                  textAlign: TextAlign.center,
                                                  style: (TextStyle(
                                                      fontFamily: 'RobotoMono',
                                                      color:
                                                          Colors.amber.shade800,
                                                      fontSize: 16,
                                                      letterSpacing: 1)),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: (controller.state ==
                                                      LoginState.Loading)
                                                  ? Center(
                                                      child: Container(
                                                          height: 26,
                                                          width: 26,
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.green,
                                                          )))
                                                  : Container(),
                                              right: 30,
                                              bottom: 0,
                                              top: 0,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .loginAsGuest(context)
                                                .then((value) {
                                              Navigator.pushReplacementNamed(
                                                  context, "/home");
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 0),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.amber.shade800),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              "الدخول كزائر",
                                              textAlign: TextAlign.center,
                                              style: (TextStyle(
                                                  fontFamily: 'RobotoMono',
                                                  color: Colors.amber.shade800,
                                                  fontSize: 16,
                                                  letterSpacing: 1)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushReplacementNamed(context, "/home");
                          //   },
                          //   child: Text("الجميعة",
                          //       style: TextStyle(
                          //           fontFamily: 'RobotoMono',
                          //           color: Colors.black,
                          //           fontSize: 13,
                          //           decoration: TextDecoration.underline,
                          //           letterSpacing: 0.5)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  login(BuildContext context, email, password) async {
    try {
      final response = await orpc.authenticate('Jumaiah', email, password);
      if (response.userId > 0) {
        final uid = response.userId;
        var res = await orpc.callKw({
          'model': 'res.users',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'context': {'bin_size': false},
            'domain': [
              ['id', '=', uid]
            ],
            'fields': [
              'id',
              'name',
              '__last_update',
              'login',
              'password',
              'tz'
            ],
          },
        });
        print('\nUser info: \n' + res.toString());
        // compute avatar url if we got reply
        if (res.length == 1) {
          setState(() {
            isLoading = false;
          });
          print('\Login is \n' + response.userLogin.toString());
          final id = response.userId;
          final login = response.userLogin;
          final username = response.userName;
          SharedPreferences preferences = await SharedPreferences.getInstance();

          preferences.setInt("id", id);
          preferences.setString("login", login);
          preferences.setString("username", username);
          preferences.commit();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      }
    } on OdooException {
      setState(() {
        isLoading = false;
      });
      SnackBar(content: Text("بيانات الدخول غير صحيحة"));
    }

    savePref(id) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setInt("id", id);
      preferences.commit();
    }
  }
}
