import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/screens/forget_password_screen.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loggedIn = false;
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
    _loadWidget();
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    if (_isLoggedIn == true) {
      setState(() {
        _loggedIn = _isLoggedIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if (this._loggedIn) {
      var obj = 0;
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
         children: [
           Positioned(
               top: 0.0,
               left: 0.0,
               right: 0.0,
               bottom: 0.0,
               child: Image.asset('assets/images/login_bg.png', fit: BoxFit.cover),
           ),
           Container(
             height: MediaQuery.of(context).size.height,
             child: Center(
               child: Image.asset(
                 'assets/images/new_logo.png',
                 width: 250,
                 height: 250,
                 fit: BoxFit.cover,
               ),
             ),
           ),
         ],
      )
    );
  }
}

