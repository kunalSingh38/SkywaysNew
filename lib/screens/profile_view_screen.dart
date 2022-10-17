import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/components/info.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/screens/employee_directory_screen.dart';
import 'package:skyways_group/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewScreen extends StatefulWidget {
  String name;
  String id;
  String photo;
  String designation;
  String department;
  String company;
  String joiningdate;
  String location;
  String dob;
  String mobile;
  String email;
  String dobmonth;
  String bloodgroup;

  ProfileViewScreen(
      {this.name,
      this.id,
      this.photo,
      this.designation,
      this.department,
      this.company,
      this.dob,
      this.mobile,
      this.email,
      this.joiningdate,
      this.location,
      this.bloodgroup,
      this.dobmonth});

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState(
      name,
      id,
      photo,
      designation,
      department,
      company,
      dob,
      mobile,
      email,
      joiningdate,
      location,
      bloodgroup,
      dobmonth);
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  String name;
  String id;
  String photo;
  String designation;
  String department;
  String company;
  String dob;
  String mobile;
  String email;
  String joiningdate;
  String location;
  String bloodgroup;
  String dobmonth;

  _ProfileViewScreenState(
      this.name,
      this.id,
      this.photo,
      this.designation,
      this.department,
      this.company,
      this.dob,
      this.mobile,
      this.email,
      this.joiningdate,
      this.location,
      this.bloodgroup,
      this.dobmonth);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/svg/mask_group_other.svg',
                  fit: BoxFit.fill)),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    children: <Widget>[
                      /*Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    color: kCornerShapeColor,
                    child: Row(
                       children: [
                         Padding(
                           padding: EdgeInsets.only(left: 10.0, top: MediaQuery.of(context).size.width * 0.10),
                           child: GestureDetector(
                             onTap: (){
                               Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(builder: (context) => const EmployeeDirectoryScreen()),
                               );
                             },
                             child: const Icon(
                               Icons.arrow_back_ios,
                               size: 18.0,
                               color: Colors.white,
                             ),
                           ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.35, top: MediaQuery.of(context).size.width * 0.10),
                           child: Text("Profile", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                         )
                       ],
                    ),
                  ),*/
                      Info(
                        image: photo,
                        name: name,
                        id: id,
                        bloodgroup: bloodgroup,
                        designation: designation,
                      ),
                      //SizedBox(height: SizeConfig.defaultSize * 2), //20
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  launch('tel:+91' + mobile);
                                },
                                child: SvgPicture.asset('assets/svg/call.svg',
                                    fit: BoxFit.cover),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchEmail(email);
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/message.svg',
                                    fit: BoxFit.cover),
                              ),
                              GestureDetector(
                                onTap: () {
                                  openwhatsapp(mobile);
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/whatsapp.svg',
                                    fit: BoxFit.cover),
                              ),
                              Container(
                                height: 40.0,
                                width: MediaQuery.of(context).size.width * 0.32,
                                decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Joining Date",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14.0)),
                                    const SizedBox(height: 2.0),
                                    joiningdate == null
                                        ? SizedBox()
                                        : Text(joiningdate,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Company",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0)),
                                  Text(company,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                      /*Padding(
                        padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 Text("Address", style: TextStyle(color: Colors.black, fontSize: 14.0)),
                                 Text(location, maxLines: 2, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),*/
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Date of Birth",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0)),
                                dob == null
                                    ? SizedBox()
                                    : Text(dob,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Department",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0)),
                                Text(department,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.0,
            color: Colors.white,
          )) /*GestureDetector(
        onTap: (){
          Navigator.pop(context);
          */ /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeDirectoryScreen()),
          );*/ /*
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 24.0,
          color: Colors.white,
        ),
      )*/
      ,
      centerTitle: true,
      title: Text("Profile", style: TextStyle(color: Colors.white)),
    );
  }

  openwhatsapp(String mobile) async {
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
