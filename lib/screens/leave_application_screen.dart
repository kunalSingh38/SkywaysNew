import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'dart:convert';
import 'package:skyways_group/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/model/balanceleavedata.dart';
import 'package:skyways_group/model/branchlistdata.dart';
import 'package:skyways_group/model/departmentlistdata.dart';
import 'package:skyways_group/screens/leave_status_screen.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({Key key}) : super(key: key);

  @override
  _LeaveApplicationScreenState createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  ProgressDialog pr;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String empname;
  String empbranch;
  String empbranchid;
  String empdepartment;
  String empdesignation;
  String leavereqtypeValue;
  String departmentValue;
  String branchValue;
  String empid;
  String leaverq = "";
  String leavetypeValue = "2";

  String reportingmanager;
  String cl;
  String el;

  bool fulldaytypevalue = true;
  bool halfdaytypevalue = false;

  bool _fboxvisibility = true;
  bool _hboxvisibility = false;
  bool _requesttypevisibility = false;
  bool _fullleavedateVisibility = true;
  bool _halfdaydateVisibilty = false;

  //TextEditingController nameController = TextEditingController();
  //TextEditingController designationController = TextEditingController();
  //TextEditingController reportingheadController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  List<String> branchlist = [];
  List<String> departmentlist = [];
  List<String> leavetypeItems = ['First Half', 'Second Half'];

  String startDate = "From Date";
  String endDate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileDetails();
    //_branchlist();
    //_departmentlist();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("emp id" + prefs.getString('employee_id')); //id 1305
      print("branch name" + prefs.getString('branchname')); //branch chennai
      empid = prefs.getString('employee_id');
      empname = prefs.getString('name');
      empdesignation = prefs.getString('designation');
      empbranch = prefs.getString('branchname');
      empdepartment = prefs.getString('departmentname');
      _branchlist();
      _getbalanceLeave();
    });
  }

  DateTime selectedDate = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      //firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Color(0xFFfca404),
              accentColor: Color(0xFFfca404),
              primarySwatch: MaterialColor(
                0xFFfca404,
                <int, Color>{
                  50: Color(0xFFfca404),
                  100: Color(0xFFfca404),
                  200: Color(0xFFfca404),
                  300: Color(0xFFfca404),
                  400: Color(0xFFfca404),
                  500: Color(0xFFfca404),
                  600: Color(0xFFfca404),
                  700: Color(0xFFfca404),
                  800: Color(0xFFfca404),
                  900: Color(0xFFfca404),
                },
              )),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      //firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Color(0xFFfca404),
              accentColor: Color(0xFFfca404),
              primarySwatch: MaterialColor(
                0xFFfca404,
                <int, Color>{
                  50: Color(0xFFfca404),
                  100: Color(0xFFfca404),
                  200: Color(0xFFfca404),
                  300: Color(0xFFfca404),
                  400: Color(0xFFfca404),
                  500: Color(0xFFfca404),
                  600: Color(0xFFfca404),
                  700: Color(0xFFfca404),
                  800: Color(0xFFfca404),
                  900: Color(0xFFfca404),
                },
              )),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked;
        startDate = selectedStartDate.year.toString() +
            "-" +
            selectedStartDate.month.toString() +
            "-" +
            selectedStartDate.day.toString();
      });
  }

  Future<void> _selectedEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        //firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
                primaryColor: Color(0xFFfca404),
                accentColor: Color(0xFFfca404),
                primarySwatch: MaterialColor(
                  0xFFfca404,
                  <int, Color>{
                    50: Color(0xFFfca404),
                    100: Color(0xFFfca404),
                    200: Color(0xFFfca404),
                    300: Color(0xFFfca404),
                    400: Color(0xFFfca404),
                    500: Color(0xFFfca404),
                    600: Color(0xFFfca404),
                    700: Color(0xFFfca404),
                    800: Color(0xFFfca404),
                    900: Color(0xFFfca404),
                  },
                )),
            child: child,
          );
        });

    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
        endDate = selectedEndDate.year.toString() +
            "-" +
            selectedEndDate.month.toString() +
            "-" +
            selectedEndDate.day.toString();
      });
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/svg/mask_group_other.svg',
                fit: BoxFit.fill,
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.black, size: 20)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.20),
                              child: const Text("Leave Application",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 20.0, right: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))),
                                      child: const Text("Create Leaves",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/leavestatusscreen');
                                      },
                                      child: Container(
                                          //height: MediaQuery.of(context).size.height * 0.06,
                                          //width: MediaQuery.of(context).size.width * 0.35,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                          child: const Text("Leave Status",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0))),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.76,
                                  //width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        _textField(empname),
                                        const SizedBox(height: 2.0),
                                        _textField(empdesignation),
                                        const SizedBox(height: 2.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     0.07,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Card(
                                              color: Colors.grey.shade300,
                                              elevation: 4.0,
                                              child: Container(
                                                  // height: MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.07,

                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        empdepartment == "" ||
                                                                empdepartment ==
                                                                    null
                                                            ? const SizedBox()
                                                            : Expanded(
                                                                child: Text(
                                                                    empdepartment,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        _textField(reportingmanager),
                                        const SizedBox(height: 2.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Card(
                                                elevation: 4.0,
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    color: Colors.grey.shade300,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.42,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0, top: 7.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Remaining CL",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      14.0)),
                                                          SizedBox(height: 4.0),
                                                          cl == null || cl == ""
                                                              ? const Text("",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              : Text(cl,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Card(
                                                elevation: 4.0,
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    color: Colors.grey.shade300,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.42,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              top: 7.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Remaining EL",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      14.0)),
                                                          const SizedBox(
                                                              height: 4.0),
                                                          el == null || el == ""
                                                              ? const Text("",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              : Text(el,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 20.0),
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: const Text(
                                                        "Apply Leave",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              kPrimaryColor,
                                                          value:
                                                              fulldaytypevalue,
                                                          onChanged:
                                                              (newValue) {
                                                            if (newValue ==
                                                                true) {
                                                              setState(() {
                                                                leavetypeValue =
                                                                    "2";
                                                                fulldaytypevalue =
                                                                    newValue;
                                                                halfdaytypevalue =
                                                                    false;

                                                                _fboxvisibility =
                                                                    true;
                                                                _fullleavedateVisibility =
                                                                    true;
                                                                _hboxvisibility =
                                                                    false;
                                                                _requesttypevisibility =
                                                                    false;
                                                                _halfdaydateVisibilty =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        const Text("FULL DAY",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            width: 5.0),
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              kPrimaryColor,
                                                          value:
                                                              halfdaytypevalue,
                                                          onChanged:
                                                              (newValue) {
                                                            if (newValue ==
                                                                true) {
                                                              setState(() {
                                                                leavetypeValue =
                                                                    "1";
                                                                fulldaytypevalue =
                                                                    false;
                                                                halfdaytypevalue =
                                                                    newValue;

                                                                _fboxvisibility =
                                                                    false;
                                                                _fullleavedateVisibility =
                                                                    false;
                                                                _hboxvisibility =
                                                                    true;
                                                                _requesttypevisibility =
                                                                    true;
                                                                _halfdaydateVisibilty =
                                                                    true;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        const Text("HALF DAY",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Visibility(
                                          visible: _fullleavedateVisibility,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _selectStartDate(context);
                                                    },
                                                    child: Card(
                                                      elevation: 4.0,
                                                      child: Container(
                                                          height:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.06,
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.42,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(
                                                                  startDate,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      _selectStartDate(
                                                                          context);
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/icons/calendar.png'),
                                                                  )),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _selectedEndDate(context);
                                                    },
                                                    child: Card(
                                                      color:
                                                          Colors.grey.shade300,
                                                      elevation: 4.0,
                                                      child: Container(
                                                          height:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.09,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.42,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(
                                                                  endDate,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      _selectedEndDate(
                                                                          context);
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/icons/calendar.png'),
                                                                  )),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: _fboxvisibility,
                                            child: const SizedBox(height: 2.0)),
                                        Visibility(
                                          visible: _requesttypevisibility,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Card(
                                              color: Colors.grey.shade300,
                                              elevation: 4.0,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButton<String>(
                                                      hint: const Text(
                                                          "Request Type",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      value: leavereqtypeValue,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 16),
                                                      onChanged: (String data) {
                                                        setState(() {
                                                          leavereqtypeValue =
                                                              data;
                                                          if (leavereqtypeValue ==
                                                              "Seconf Half") {
                                                            leaverq = "2";
                                                          } else {
                                                            leaverq = "1";
                                                          }
                                                        });
                                                      },
                                                      items: leavetypeItems.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Visibility(
                                          visible: _halfdaydateVisibilty,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              child: Card(
                                                color: Colors.grey.shade300,
                                                elevation: 4.0,
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Text(
                                                            selectedDate.day
                                                                    .toString() +
                                                                "-" +
                                                                selectedDate
                                                                    .month
                                                                    .toString() +
                                                                "-" +
                                                                selectedDate
                                                                    .year
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _selectDate(
                                                                    context);
                                                              },
                                                              child: Image.asset(
                                                                  'assets/icons/calendar.png'),
                                                            )),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: _hboxvisibility,
                                            child: SizedBox(height: 2.0)),
                                        _textInputField("Additional Note",
                                            reasonController),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 45.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: FlatButton(
                                              onPressed: () {
                                                if (reasonController.text
                                                    .toString()
                                                    .isEmpty) {
                                                  showToast(
                                                      'Please enter your reason to leave');
                                                } else {
                                                  _submitleaveForm();
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 30),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    color: Colors.grey.shade300,
                                    elevation: 4.0,
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              empbranch == "" ||
                                                      empbranch == null
                                                  ? const SizedBox()
                                                  : Expanded(
                                                      child: Text(
                                                        empbranch,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _textInputField(String text, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        elevation: 4.0,
        color: Colors.grey.shade300,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: text,
            ),
            controller: _controller,
            cursorColor: kPrimaryColor,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }

  Widget _textField(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        color: Colors.grey.shade300,
        elevation: 4.0,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Text(
                    text == null || text == "" ? "" : text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _branchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"api_access_token": "ywrtaw46veltitizqhbs"};
    var response = await http.post(
      Uri.parse(BASE_URL + branchlistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      var _branchlist = list.map((m) => BranchData.fromJson(m)).toList();
      for (var i = 0; i < _branchlist.length; i++) {
        if (empbranch == _branchlist[i].branchName) {
          setState(() {
            empbranchid = _branchlist[i].id;
            prefs.setString('empbranchid', empbranchid);
          });
        }
      }
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  _getbalanceLeave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_id": prefs.getString('employee_id'),
    };
    var response = await http.post(
      Uri.parse(BASE_URL + balanceleaveUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      List<BalancelvData> lvdata =
          list.map((m) => BalancelvData.fromJson(m)).toList();
      setState(() {
        cl = lvdata[0].cl;
        el = lvdata[0].el;
        reportingmanager = lvdata[0].supervisorName;
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  _departmentlist() async {
    List<String> dummydepartmentlist = [];
    final body = {
      "company_id": "1",
      "api_access_token": "ywrtaw46veltitizqhbs"
    };
    var response = await http.post(
      Uri.parse(BASE_URL + departmentlistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      var _departmentlist =
          list.map((m) => DepartmentData.fromJson(m)).toList();
      for (var i = 0; i < _departmentlist.length; i++) {
        dummydepartmentlist.add(_departmentlist[i].deptName);
      }
      setState(() {
        departmentlist.addAll(dummydepartmentlist);
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  _submitleaveForm() async {
    var responsedata;
    pr.show();
    try {
      if (_connectionStatus == "ConnectivityResult.mobile" ||
          _connectionStatus == "ConnectivityResult.wifi") {
        /* print("emp id "+empid);
        print("emp branch "+empbranchid);
        print("manager "+reportingmanager);
        print("leave type "+leavetypeValue);
        print("reason "+reasonController.text.toString());
        print("start date "+startDate);
        print("endDate date "+endDate);
        print("half day date "+selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString());*/
        final body = {
          "emp_id": empid.toString(),
          "branch_id": empbranchid.toString(),
          "reporting_manager": reportingmanager.toString(),
          "leave_type": leavetypeValue.toString(),
          "reason": reasonController.text.toString(),
          "half_day_type": leaverq,
          "date_from": startDate.toString(),
          "date_to": endDate.toString(),
          "half_day_date": selectedDate.year.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.day.toString(),
          "api_access_token": "ywrtaw46veltitizqhbs"
        };
        var response = await http.post(
          Uri.parse(BASE_URL + leaveformUrl),
          body: body,
        );

        print(BASE_URL + leaveformUrl);
        print(jsonEncode(body));
        if (response.statusCode == 200) {
          setState(() {
            Future.delayed(Duration(seconds: 1)).then((value) {
              pr.hide().whenComplete(() {
                responsedata = json.decode(response.body);
                var msg = responsedata['message'];
                showToast(msg);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaveStatusScreen()));
              });
            });
          });
        } else {
          setState(() {
            responsedata = json.decode(response.body);
            Future.delayed(Duration(seconds: 1)).then((value) {
              pr.hide().whenComplete(() {
                print("response me " + responsedata.toString());
                Fluttertoast.showToast(
                    msg: responsedata['error']['loginerror'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              });
            });
          });
        }
      } else {
        setState(() {
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: "Please check your internet connection",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
            });
          });
        });
      }
    } on Exception catch (exc) {
      print("exception here " + exc.toString());
    }
  }
}
