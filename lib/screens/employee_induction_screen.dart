import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/constants/constant.dart';
import 'dart:convert';

import 'package:skyways_group/model/policylistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/view_policy_screen.dart';

class EmployeeInductionScreen extends StatefulWidget {
  const EmployeeInductionScreen({Key key}) : super(key: key);

  @override
  _EmployeeInductionScreenState createState() =>
      _EmployeeInductionScreenState();
}

class _EmployeeInductionScreenState extends State<EmployeeInductionScreen> {
  String title;
  String desc;
  String pdfpath;

  bool _btnVisible = true;

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPolicylist();
    _getPolicyacceptance();
  }

  _getPolicyacceptance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Policy "+prefs.getString('isAcceptPolicy'));
    var checkvalue = prefs.getString('isAcceptPolicy');
    if (checkvalue == "1") {
      setState(() {
        _btnVisible = false;
      });
    } else {
      setState(() {
        _btnVisible = true;
      });
    }
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
      extendBody: true,
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
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                          child: Text("Employee Induction",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.81,
                          width: double.infinity,
                          child: FutureBuilder(
                              future: _getPolicylist(),
                              builder: (context, snapshot) {
                                List<PolicyData> list = snapshot.data;
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                      height: 24.0,
                                      width: 24.0,
                                      child: const CircularProgressIndicator(
                                          color: kPrimaryColor),
                                    ),
                                  );
                                } else {
                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: list.length,
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                          color: Colors.grey,
                                          thickness: 2.0,
                                          height: 4.0);
                                    },
                                    scrollDirection: Axis.vertical,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _policylistData(
                                          list[index].title,
                                          list[index].desc,
                                          list[index].policyDoc,
                                          index);
                                    },
                                  );
                                }
                              }))),
                  SizedBox(height: 5.0),
                  GestureDetector(
                      onTap: () {
                        _acceptPolicy();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible: _btnVisible,
                          child: Container(
                            height: 45.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: const Text("I ACCEPT ALL POLICIES",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0)),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _policylistData(
      String title, String desc, String filepath, int indexvalue) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))),
              SizedBox(height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 2, child: Text(desc)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPolicyScreen(
                                  filepath: filepath,
                                  policynumber:
                                      (indexvalue + 1).toString())));
                    },
                    child: Container(
                      height: 30,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.0))),
                      child: Text("VIEW",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPolicylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"api_access_token": "ywrtaw46veltitizqhbs"};
    var response = await http.post(
      Uri.parse(BASE_URL + policylistingUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      var _list = list.map((m) => PolicyData.fromJson(m)).toList();
      return _list;
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  _acceptPolicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pr.show();
    });
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_id": prefs.getString('employee_id')
    };
    var response = await http.post(
      Uri.parse(BASE_URL + policyacceptanceUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      setState(() {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pr.hide().whenComplete(() {
            var responsedata = json.decode(response.body);
            var msg = responsedata['message'];
            showToast(msg);
            prefs.setString('isAcceptPolicy', "1");
            setState(() {
              _btnVisible = false;
            });
            var _duration = Duration(seconds: 2);
            return Timer(_duration, navigationPage);
          });
        });
      });
    } else {
      print(response.body);
      pr.hide();
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }
}
