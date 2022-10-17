import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/background_image.dart';
import 'package:skyways_group/components/text_input.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/screens/forget_password_screen.dart';
import 'package:skyways_group/screens/home_sceen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Size _size;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;

  ProgressDialog pr;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      progress: 80.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(color: kPrimaryColor)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w100),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Stack(
          children: [
            SafeArea(
              child: SvgPicture.asset('assets/svg/mask_group.svg',
                  fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(height: 40.0),
                    Container(
                      height: 180.0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/new_logo.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    const Text(
                      "Sign In to Continue",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 15.0,
                        width: double.infinity,
                        child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Username",
                                style: TextStyle(color: Colors.grey))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 2.0, right: 10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey[300].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: "Username",
                            hintStyle: TextStyle(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 15.0,
                        width: double.infinity,
                        child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Password",
                                style: TextStyle(color: Colors.grey))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 2.0, right: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey[300].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: "*********",
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                              child: Icon(
                                _isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                                size: 18,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Padding(
                    //   padding: EdgeInsets.only(top:5.0,right: 8.0),
                    //   child: Align(
                    //     alignment: Alignment.topRight,
                    //     child: GestureDetector(
                    //       onTap: (){
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                    //         );
                    //       },
                    //       child: const Text(
                    //         'Forgot Password?',
                    //         style: TextStyle(color: kPrimaryColor, fontSize: 16.0, fontWeight: FontWeight.w400),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            if (usernameController.text.toString().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter your username",
                                  gravity: ToastGravity.CENTER);
                            } else if (passwordController.text
                                .toString()
                                .isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter your pawword",
                                  gravity: ToastGravity.CENTER);
                            } else {
                              _loginUser(usernameController.text.toString(),
                                  passwordController.text.toString());
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //const SizedBox(height: 80),
                    /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container (
                            decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white, width: 1),
                                )),
                            child: const Text(
                              "Don't have an account?" ,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 3.0),
                          Container (
                            decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white, width: 1),
                                )),
                            child: const Text(
                              'Register Now',
                              style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),*/
                    //SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loginUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var responsedata;
    pr.show();
    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      final body = {
        "username": username,
        "password": password,
        "api_access_token": "ywrtaw46veltitizqhbs"
      };
      var response = await http.post(
        Uri.parse(BASE_URL + loginUrl),
        body: body,
      );
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide().whenComplete(() {
              responsedata = json.decode(response.body);
              var msg = responsedata['message'];
              showToast(msg);

              prefs.setBool('logged_in', true);
              prefs.setString('employee_id',
                  responsedata['data']['employee_id'].toString());
              prefs.setString(
                  'branch_id', responsedata['data']['branch_id'].toString());
              prefs.setString(
                  'company_id', responsedata['data']['company_id'].toString());
              prefs.setString(
                  'emp_id', responsedata['data']['emp_id'].toString());
              prefs.setString("is_supervisor",
                  responsedata['data']['is_supervisor'].toString());
              prefs.setString('isAcceptPolicy',
                  responsedata['data']['isAcceptPolicy'].toString());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            });
          });
        });
      } else {
        setState(() {
          responsedata = json.decode(response.body);
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide().whenComplete(() {
              showToast(responsedata['error']['loginerror']);
              //Fluttertoast.showToast(msg:responsedata['error']['loginerror'], toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
            });
          });
        });
      }
    } else {
      setState(() {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pr.hide().whenComplete(() {
            showToast("Please check your internet connection");
            //Fluttertoast.showToast(msg:"Please check your internet connection", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
          });
        });
      });
    }
  }
}
