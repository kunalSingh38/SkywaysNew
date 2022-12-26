import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/model/pendingleavelistdata.dart';
import 'package:skyways_group/model/supervisorreqlistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({Key key}) : super(key: key);

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressDialog pr;

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
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/svg/mask_group_other.svg',
                  fit: BoxFit.fill)),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 20)),
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.22),
                          child: const Text("Leave Request",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: FutureBuilder(
                        future: _getleaverqtlist(),
                        builder: (context, AsyncSnapshot snapshot) {
                          List<PendingData> list = [];
                          list.clear();
                          list = snapshot.data;
                          if (!snapshot.hasData) {
                            return Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: kPrimaryColor),
                              ),
                            );
                          } else if (list.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Align(
                                child: Text(
                                  "No Data Available",
                                  style: TextStyle(
                                      color: Colors.red[900], fontSize: 20),
                                ),
                              ),
                            );
                          } else {
                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                    color: Colors.transparent, height: 6.0);
                              },
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _listItem(
                                    list[index].id,
                                    list[index].empId,
                                    list[index].leaveStatus,
                                    list[index].empFullDay,
                                    list[index].empFulldayTodate,
                                    list[index].empFulldayFromdate,
                                    list[index].empHalfDayDate,
                                    list[index].empReasonforleave,
                                    list[index].empHalfDayType,
                                    list[index].empName,
                                    list[index].leaveBalance.toString());
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
    );
  }

  Widget _listItem(
      String id,
      String empid,
      String leavestatus,
      String fulldayvalue,
      String fulldaytodate,
      String fulldayfromdate,
      String halfdaydate,
      String leavereason,
      String halfdatetype,
      String empName,
      String leaveBal) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 12.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Employee Name : ",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(empName,
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black))
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const Text("Leave bal : ",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(leaveBal,
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black))
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Employee ID : ",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      Text(empid,
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black))
                    ],
                  ),
                  fulldayvalue == "1"
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Leave Type : ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500)),
                            Text("HALF DAY",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black))
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Leave Type : ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500)),
                            Text("FULL DAY",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black))
                          ],
                        )
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: fulldayvalue == "1"
                        ? Row(
                            children: [
                              const Text("Leave Date : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500)),
                              halfdaydate.toString() == "null" ||
                                      halfdaydate.toString() == ""
                                  ? const SizedBox()
                                  : Text(halfdaydate,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14.0))
                            ],
                          )
                        : Row(
                            children: [
                              const Text("Leave Date : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500)),
                              Expanded(
                                  child: Text(
                                      fulldayfromdate + " to " + fulldaytodate,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14.0)))
                            ],
                          ),
                  ),
                  getStaus(leavestatus)
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Leave Reason : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500)),
                  leavereason == null
                      ? const SizedBox()
                      : Expanded(
                          child: Text(leavereason,
                              // maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14.0)))
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _changeleavestaus(id, "2");
                    },
                    child: Container(
                      height: 30.0,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child:
                          Text("Reject", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _changeleavestaus(id, "1");
                    },
                    child: Container(
                      height: 30.0,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Text("Approve",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0)
            ],
          ),
        ),
      ),
    );
  }

  Future<List<PendingData>> _getleaverqtlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({
      "api_access_token": "ywrtaw46veltitizqhbs",
      //"reporting_manager" : "962",
      "branch_id": prefs.getString('branch_id'),
      "reporting_manager": prefs.getString('employee_id'),
    }));
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      //"reporting_manager" : "962",
      "branch_id": prefs.getString('branch_id'),
      "reporting_manager": prefs.getString('employee_id'),
    };
    var response = await http.post(
      Uri.parse(BASE_URL + pendingleavelistUrl),
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      List<PendingData> leavestatuslist =
          list.map((m) => PendingData.fromJson(m)).toList();
      return leavestatuslist;
    } else {
      // print(response.body);
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text(json.decode(response.body)['error']['error'].toString(),
      //       style: TextStyle(color: Colors.white)),
      //   backgroundColor: Colors.red,
      // ));
      Iterable list = [];
      List<PendingData> leavestatuslist =
          list.map((m) => PendingData.fromJson(m)).toList();
      return leavestatuslist;
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _changeleavestaus(String id, String status) async {
    pr.show();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "id": id,
      "leave_status": status, //(1=>Approved,2=>Dis-Approve )
      "status_remarks": "ok" //not mandatory field
    };
    print(jsonEncode(body));
    print(BASE_URL + leaveStatuschangeUrl);
    var response =
        await http.post(Uri.parse(BASE_URL + leaveStatuschangeUrl), body: body);
    Navigator.of(context).pop();
    _getleaverqtlist();
    if (response.statusCode == 200) {
      showToast(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget getStaus(String statusValue) {
    if (statusValue == "0") {
      return Container(
          height: 25.0,
          width: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: const Text("Pending",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400)));
    }
    if (statusValue == "1") {
      return Container(
          height: 25.0,
          width: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: const Text("Approved",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400)));
    }
    if (statusValue == "2") {
      return Container(
          height: 25.0,
          width: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: const Text("Disapproved",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400)));
    }
    if (statusValue == "3") {
      return Container(
          height: 25.0,
          width: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: const Text("Cancel",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400)));
    }
  }
}
