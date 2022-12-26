import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/constants/dialog_helper.dart';
import 'package:skyways_group/model/leavestatuslistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/leave_application_screen.dart';

class LeaveStatusScreen extends StatefulWidget {
  const LeaveStatusScreen({Key key}) : super(key: key);

  @override
  _LeaveStatusScreenState createState() => _LeaveStatusScreenState();
}

class _LeaveStatusScreenState extends State<LeaveStatusScreen> {
  String empname;
  String empid;
  String photo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileDetails();
    _getleavestatuslist();
  }

  _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empname = prefs.getString('name');
      empid = prefs.getString('employee_id');
      photo = prefs.getString('emp_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: SvgPicture.asset('assets/svg/mask_group_other.svg',
                      fit: BoxFit.fill)),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
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
                    ),
                    const SizedBox(height: 15),
                    Container(
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
                                left: 20.0, top: 10.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/leaveapplyscreen');
                                  },
                                  child: Container(
                                    //height: MediaQuery.of(context).size.height * 0.06,
                                    //width: MediaQuery.of(context).size.width * 0.35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25.0))),
                                    child: const Text("Create Leaves",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0)),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  child: const Text("Leave Status",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Recent Leave Application",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 10.0, right: 8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.70,
                              width: double.infinity,
                              child: FutureBuilder(
                                  future: _getleavestatuslist(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    List<LeaveStatusData> list = snapshot.data;
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: Container(
                                              height: 24.0,
                                              width: 24.0,
                                              child:
                                                  const CircularProgressIndicator(
                                                      color: kPrimaryColor)));
                                    } else {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        padding: EdgeInsets.zero,
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                              color: Colors.transparent,
                                              height: 6.0);
                                        },
                                        itemCount: list.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.16,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: kPrimaryColor,
                                                        width: 2, //8
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: photo == "" ||
                                                                photo == null
                                                            ? AssetImage(
                                                                'assets/images/person.jpg')
                                                            : NetworkImage(
                                                                photo),
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 5.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                            empname +
                                                                "( " +
                                                                empid +
                                                                " )",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            height: 5.0),
                                                        list[index].empFullDay ==
                                                                    "2" ||
                                                                list[index]
                                                                        .empFullDay ==
                                                                    null
                                                            ? Text(
                                                                list[index]
                                                                        .empFulldayFromdate +
                                                                    " to " +
                                                                    list[index]
                                                                        .empFulldayTodate,
                                                                style: const TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        12.0))
                                                            : Text(
                                                                list[index]
                                                                    .empHalfDayDate,
                                                                style: const TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        12.0)),
                                                        const SizedBox(
                                                            height: 5.0),
                                                        Text(
                                                            list[index]
                                                                .empReasonforleave,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10.0)),
                                                      ]),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 5.0),
                                                  list[index].empFullDay == "2"
                                                      ? const Text("FULL DAY",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12.0))
                                                      : const Text("HALF DAY",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12.0)),
                                                  const SizedBox(height: 8.0),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.0,
                                                          top: 5.0,
                                                          right: 8.0),
                                                      child: getStaus(
                                                          list[index]
                                                              .leaveStatus,
                                                          list[index].id))
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: _willPopCallback);
  }

  Future<List<LeaveStatusData>> _getleavestatuslist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "branch_id": prefs.getString('empbranchid'),
      "emp_id": prefs.getString('employee_id'),
    };
    var response = await http.post(
      Uri.parse(BASE_URL + leavelistUrl),
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      List<LeaveStatusData> leavestatuslist =
          list.map((m) => LeaveStatusData.fromJson(m)).toList();
      return leavestatuslist;
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget getStaus(String statusValue, String id) {
    if (statusValue == "0") {
      return GestureDetector(
        onTap: () {
          DialogHelper.selfCancelLeave(id, context);
        },
        child: Container(
            height: 25.0,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: const Text("Pending",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      );
    }
    if (statusValue == "1") {
      return GestureDetector(
        onTap: () {
          showToast("Leave Approved!");
        },
        child: Container(
            height: 25.0,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: const Text("Approved",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      );
    }
    if (statusValue == "2") {
      return GestureDetector(
        onTap: () {
          showToast("Leave Disapproved!");
        },
        child: Container(
            height: 25.0,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: const Text("Disapproved",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      );
    }
    if (statusValue == "3") {
      return GestureDetector(
        onTap: () {
          showToast("Already Canceled!");
        },
        child: Container(
            height: 25.0,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: const Text("Cancel",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      );
    }
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
