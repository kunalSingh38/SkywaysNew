import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/components/info.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/constants/dialog_helper.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/employeelistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name;
  String designation;
  String department;
  String photo;
  String id;
  String mobile;
  String email;
  String joindate;
  String salary;
  String bloodgroup;
  String address;
  String currentaddress;
  String emergencycontact;
  String reportingmanager;

  bool salaryVisibility = false;

  @override
  void initState() {
    super.initState();
    _getProfileDetails();
  }

  _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photo = prefs.getString('emp_image');
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
        id = _employeeslist[0].empId;
        designation = _employeeslist[0].desigName;
        joindate = _employeeslist[0].empJoinDate;
        salary = _employeeslist[0].basicSalary.toString();
        bloodgroup = _employeeslist[0].bloodGroup;
        address = _employeeslist[0].permanentAddress;
        currentaddress = _employeeslist[0].empAdd1;
        emergencycontact = _employeeslist[0].emergencyNo;
        reportingmanager = _employeeslist[0].reportingManager;
        department = _employeeslist[0].deptName;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
                right: 0,
                child: SvgPicture.asset('assets/svg/mask_group_other.svg',
                    fit: BoxFit.fill)),
            Column(
              children: <Widget>[
                Info(
                  image: photo,
                  name: name,
                  id: id,
                  designation: designation,
                ),
                Text(
                  bloodgroup == "" || bloodgroup == null
                      ? ""
                      : "Blood Group: " + bloodgroup,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                /* Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            launch('tel:+91'+mobile);
                          },
                          child: SvgPicture.asset('assets/svg/call.svg', fit: BoxFit.cover),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: (){
                            _launchEmail(email);
                          },
                          child: SvgPicture.asset('assets/svg/message.svg', fit: BoxFit.cover),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: (){
                            openwhatsapp(mobile);
                          },
                          child: SvgPicture.asset('assets/svg/whatsapp.svg', fit: BoxFit.cover),
                        )

                      ]
                  ),
                ),*/
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Joining Date",
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 14.0)),
                              const SizedBox(height: 2.0),
                              Text(
                                  joindate == "" || joindate == null
                                      ? ""
                                      : joindate,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                            ],
                          ),
                          const VerticalDivider(
                            thickness: 10,
                            color: Colors.white,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                salaryVisibility = !salaryVisibility;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Net Salary",
                                    style: TextStyle(
                                        color: kPrimaryColor, fontSize: 14.0)),
                                const SizedBox(height: 2.0),
                                salaryVisibility == false
                                    ? const Text("******",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0))
                                    : Text(
                                        salary == "" || salary == null
                                            ? ""
                                            : salary,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade50),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Reporting Manager",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 14.0)),
                          const SizedBox(height: 2.0),
                          Text(
                              reportingmanager == "" || reportingmanager == null
                                  ? ""
                                  : reportingmanager,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0)),
                          const SizedBox(height: 5.0),
                          Divider(height: 1, color: Colors.grey.shade50),
                          const SizedBox(height: 2.0),
                          const Text("Department",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 14.0)),
                          const SizedBox(height: 2.0),
                          Text(
                              department == "" || department == null
                                  ? ""
                                  : department,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0)),
                          const SizedBox(height: 5.0),
                          Divider(height: 1, color: Colors.grey.shade50),
                          const SizedBox(height: 2.0),
                          const Text("Permanent Address",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 14.0)),
                          const SizedBox(height: 2.0),
                          Text(address == "" || address == null ? "" : address,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0)),
                          const SizedBox(height: 5.0),
                          Divider(height: 1, color: Colors.grey.shade50),
                          const SizedBox(height: 2.0),
                          const Text("Current Address",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 14.0)),
                          const SizedBox(height: 2.0),
                          Text(
                              currentaddress == "" || currentaddress == null
                                  ? ""
                                  : currentaddress,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0)),
                          const SizedBox(height: 5.0),
                          Divider(height: 1, color: Colors.grey.shade50),
                          const SizedBox(height: 5.0),
                          const Text("Emergency Contact",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 14.0)),
                          const SizedBox(height: 2.0),
                          Text(
                              emergencycontact == "" || emergencycontact == null
                                  ? ""
                                  : emergencycontact,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Ver: 1.0.4+5",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: kCornerShapeColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      title: const Text("Profile", style: TextStyle(color: Colors.white)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              DialogHelper.logout(context);
            },
            child: const Icon(Icons.logout, size: 24.0, color: Colors.white),
          ),
        )
      ],
    );
  }

  openwhatsapp(String mobile) async {
    print("Open whatsapp");
    var whatsapp = "+91" + mobile;
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=Hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  _launchEmail(String email) {
    launch('mailto:$email?subject=&body=');
  }
}
