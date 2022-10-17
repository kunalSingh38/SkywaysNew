import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/constants/dialog_helper.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/employeelistdata.dart';
import 'package:skyways_group/screens/announcement_screen.dart';
import 'package:skyways_group/screens/apply_reimbursement_screen.dart';
import 'package:skyways_group/screens/birthday_and_anniversary_screen.dart';
import 'package:skyways_group/screens/employee_directory_screen.dart';
import 'package:skyways_group/screens/employee_induction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/screens/leave_request_screen.dart';
import 'package:skyways_group/screens/visitors_invite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  String name;
  String photo = "";
  bool checksupervisor = false;

  String title = "";

  List<dynamic> _announcenoticelist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileDetails();
    _noticelist();
  }

  _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('is_supervisor') == "0") {
        checksupervisor = false;
      } else {
        checksupervisor = true;
      }
    });
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "employee_id": prefs.getString('employee_id')
    };
    var response = await http.post(
      Uri.parse(BASE_URL + employeelistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      var _employeeslist = list.map((m) => Data.fromJson(m)).toList();
      setState(() {
        photo = _employeeslist[0].empImage;
        name = _employeeslist[0].empName;
      });
      prefs.setString('emp_image', _employeeslist[0].empImage);
      prefs.setString('name', _employeeslist[0].empName);
      prefs.setString('mobile', _employeeslist[0].empMobile);
      prefs.setString('mail', _employeeslist[0].empMail);
      prefs.setString('branchname', _employeeslist[0].branchName);
      prefs.setString('departmentname', _employeeslist[0].deptName);
      prefs.setString('designation', _employeeslist[0].desigName);
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await DialogHelper.exit(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  child:
                  Image.asset('assets/images/new_bg_home.jpg', fit: BoxFit.fill)),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/new_logo.png',
                      width: 160,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Welcome back",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0)),
                                name == "" || name == null
                                    ? const Text("Guest",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))
                                    : Text(name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/profilescreen');
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.16,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1, //8
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: photo == "" || photo == null
                                        ? const AssetImage('assets/images/ic_profile.png')
                                        : NetworkImage(photo),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _announcenoticelist.isEmpty || _announcenoticelist.length == 0 ? const SizedBox() : InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 800),
                            reverseTransitionDuration: const Duration(milliseconds: 800),
                            opaque: false,
                            pageBuilder: (context, animation, _) {return AnnouncementScreen();
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          child: Card(
                            elevation: 4.0,
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0, right: 8.0),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: _announcenoticelist.length,
                                separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.grey),
                                itemBuilder: (BuildContext context, int index) {
                                   return Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const SizedBox(height: 4.0),
                                       Text(_announcenoticelist[index]['title'].toString(), style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                       Text(_announcenoticelist[index]['desc'].toString(), style: const TextStyle(color: Colors.black, fontSize: 12)),
                                       const SizedBox(height: 4.0)
                                     ],
                                   );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //height: MediaQuery.of(context).size.height * 0.72,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                              child: ItemInfo(checksupervisor: checksupervisor, title : title)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
      ),
    );
  }

  Future _noticelist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_id": prefs.getString('employee_id')
    };
    var response = await http.post(
      Uri.parse(BASE_URL + annoucenoticelisturl),
      body: body,
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
          _announcenoticelist.addAll(jsonDecode(response.body)['data']);
          title = jsonDecode(response.body)['data'][0]['title'].toString();
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}

class ItemInfo extends StatelessWidget {
  var checksupervisor;
  var title;

  ItemInfo({Key key, this.checksupervisor, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        title.toString() == "" || title.toString() == null ? SizedBox(height: 30) : SizedBox(height: 0),
        const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Executive Summary",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold))),
        ),
        SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15, //85
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _listItem(context, 'Browse', 'Employee', 'Directory',
                  'assets/svg/browse_employee_directory.svg'),
              _listItem(context, 'New', 'Employee', 'Induction',
                  'assets/svg/new_employee_induction.svg'),
              Visibility(
                visible: checksupervisor,
                child: _listItem(context, 'Leave', 'Approval', 'Request',
                    'assets/svg/group.svg'),
              ),
              /*_listItem(context, 'Create','Invite', 'Visitors', 'assets/svg/group.svg'),*/
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.19, //130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _actionlistItem(context, "Leave", "Application",
                  "assets/svg/leave_application.svg"),
              _actionlistItem(
                  context, "Salary", "Slips", "assets/svg/salary_slip.svg"),
              _actionlistItem(
                  context, "Notice", "Board", "assets/svg/notice_board.svg"),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.28, //210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _actionlist(context, "Today's Birthday", "& Work Anniversaries",
                  'assets/svg/birthday.svg'),
              _actionlist(context, "Apply for", "Reimbursements",
                  'assets/svg/applyc_for.svg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listItem(BuildContext context, String title, String subtitle,
      String subsubtitle, String image) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0, top: 5.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {
              if (title.startsWith("Browse")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeDirectoryScreen()));
              } else if (title.startsWith("New")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmployeeInductionScreen()));
              } else if (title.startsWith("Create")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VisitorInviteScreen()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaveRequestScreen()));
              }
            },
            child: Card(
              elevation: 1.0,
              child: Container(
                height: 85,
                width: 130,
                decoration: const BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: SvgPicture.asset(image),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(subtitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(subsubtitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _actionlistItem(
      BuildContext context, String title, String subtitle, String image) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0, top: 10.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {
              if (title.startsWith("Leave")) {
                Navigator.pushNamed(context, '/leaveapplyscreen');
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveApplicationScreen()));
              } else if (title.startsWith("Salary")) {
                Navigator.pushNamed(context, '/salaryslipscreen');
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const SalarySlipScreen()));
              } else {
                Navigator.pushNamed(context, '/noticeboardscreen');
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeBoardScreen()));
              }
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30, //130,
                width: MediaQuery.of(context).size.width * 0.28, //100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SvgPicture.asset(image),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Divider(
                        height: 4.0,
                        color: kCardColor,
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(title + "\n" + subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                    /*Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(subtitle, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    ),*/
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _actionlist(
      BuildContext context, String title, String subtitle, String image) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Card(
            elevation: 4.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40, //210,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        if (title.startsWith("Today's Birthday")) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BirthdayAnniversaryScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ApplyReimbursementScreen()));
                        }
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.16,
                          width: double.infinity,
                          child: SvgPicture.asset(image, fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 2.0, right: 5.0),
                    child: Text(subtitle,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          )),
    );
  }

}
