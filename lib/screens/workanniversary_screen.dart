import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/todayanniversarylistdata.dart';
import 'package:skyways_group/model/upcominganniversarylistdata.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkAnniversaryScreen extends StatefulWidget {
  const WorkAnniversaryScreen({Key key}) : super(key: key);

  @override
  _WorkAnniversaryScreenState createState() => _WorkAnniversaryScreenState();
}

class _WorkAnniversaryScreenState extends State<WorkAnniversaryScreen> {

  String currentDate;

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
  }

  _getCurrentDate(){
    DateTime selectedDate = DateTime.now();
    setState(() {
      currentDate = selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/svg/mask_group_other.svg', fit: BoxFit.fill)),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                        Padding(
                           padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
                            child: Text(
                            "Work Anniversaries",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){} ,
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery.of(context).size.width * 0.37,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))

                                  ),
                                  child: const Text("Work Anniversary",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 14.0)
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, '/birthdayscreen');
                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkAnniversaryScreen()),);
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                  child: const Text("Birthday",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0)),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Today's Work Anniversaries",
                              style: TextStyle(color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.22,   //150,
                            width: double.infinity,
                            child: FutureBuilder(
                                future: _getTodayWorkAnniversarylist(),
                                builder: (context, snapshot){
                                  List<TodayAnniversaryData> list = snapshot.data;
                                  if(!snapshot.hasData){
                                    return Center(
                                      child: Container(
                                        height: 24.0,
                                        width: 24.0,
                                        child: CircularProgressIndicator(color: kPrimaryColor),
                                      ),
                                    );
                                  }
                                  else if(list == null || list.isEmpty){
                                    return Center(
                                      child: Container(
                                        height: 24.0,
                                        width: double.infinity,
                                        child: Text("No one's work anniversary today", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.0),),
                                      ),
                                    );
                                  }
                                  else{
                                    return ListView.builder(
                                        itemCount: list.length,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          return _celebrationlist(list[index].empName, list[index].empImage, list[index].empJoinDate,
                                              list[index].desigName, list[index].empMobile, list[index].empMail, list[index].branchname, context);
                                        }
                                    );
                                  }
                                }

                            )
                        ),
                        SizedBox(height: 10.0),
                        const Padding(
                          padding: EdgeInsets.only(left:5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Upcoming Work Anniversaries", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                            child: Container(
                                height: MediaQuery.of(context).size.height * 0.44,
                                padding: EdgeInsets.only(bottom: 35),
                                width: double.infinity,
                                child: FutureBuilder(
                                    future: _getUpcomingAnniversarylist(),
                                    builder: (context, snapshot){
                                      List<Upcoming> list = snapshot.data;
                                      if(!snapshot.hasData){
                                        return Center(
                                          child: Container(
                                            height: 24.0,
                                            width: 24.0,
                                            child: CircularProgressIndicator(color: kPrimaryColor),
                                          ),
                                        );
                                      }
                                      else if(list == null || list.isEmpty){
                                        return Center(
                                          child: Container(
                                            height: 24.0,
                                            width: double.infinity,
                                            child: Text("No upcoming anniversaries in this month!", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.0)),
                                          ),
                                        );
                                      }
                                      else{
                                        return ListView.separated(
                                            padding: EdgeInsets.zero,
                                            separatorBuilder: (context, index) {
                                              return Divider(color: Colors.transparent, height: 4.0);
                                            },
                                            itemCount: list.length,
                                            scrollDirection: Axis.vertical,
                                            physics: AlwaysScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,int index){
                                              return _upcomingCelelist(list[index].empName, list[index].empImage, list[index].empJoinDate, list[index].desigName, list[index].empMobile, list[index].branchName, context);
                                            }

                                        );
                                      }
                                    }
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  Widget _celebrationlist(String name, String image, String joindate, String designation,
      String mobile, String email, String branchname, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 0, right: 8.0, bottom: 0),
      child: Container(
        width: 180,
        child: Card(
            elevation: 5.0,
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 1, //8
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image == null || image == "" ? AssetImage('assets/images/person.jpg') : NetworkImage(image),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.0, top: 2.0, right: 3.0),
                        child: Text(name, maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(designation, style: TextStyle(color: kPrimaryColor, fontSize: 12.0)),
                    SizedBox(height: 2.0),
                    Text(branchname, style: TextStyle(color: Colors.grey, fontSize: 10.0))
                  ],
                ),
                Positioned(
                  left: 20,
                  bottom: 5,
                  right: 20,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0, top: 25.0, right: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              launch('tel:+91'+mobile);
                            },
                            child: Image.asset('assets/icons/call.png', fit: BoxFit.cover),
                          ),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: (){
                              _launchEmail(email);
                            },
                            child: Image.asset('assets/icons/message.png', fit: BoxFit.cover),
                          ),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: (){
                              openwhatsapp(mobile);
                            },
                            child: Image.asset('assets/icons/whatsapp.png', fit: BoxFit.cover),
                          ),
                        ]
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  Widget _upcomingCelelist(String name, String image, String dob, String designation, String mobile, String branchname, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: kPrimaryColor,
                width: 1, //8
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: image == null || image == "" ? AssetImage('assets/images/person.jpg') : NetworkImage(image),
              ),
            ),
          ),
        ),
        Expanded(child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2.0),
                Text(designation, style: TextStyle(color: kPrimaryColor, fontSize: 12.0)),
                const SizedBox(height: 2.0),
                Text(branchname, style: TextStyle(color: Colors.grey, fontSize: 10.0)),
              ]
          ),
        ),
        ),
        Text(dob, style: TextStyle(color: Colors.grey, fontSize: 12.0))
      ],
    );
  }


  _getTodayWorkAnniversarylist() async{
    final body = {
      "api_access_token" : "ywrtaw46veltitizqhbs",
      "custom_date" : currentDate
    };
    var response = await http.post(
      Uri.parse(BASE_URL+anniversarylistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data']['custom_date'];
      List<TodayAnniversaryData> workanniversarylist = list.map((m) => TodayAnniversaryData.fromJson(m)).toList();
      return workanniversarylist;
    } else {
      List<TodayAnniversaryData> list = [];
      return list;
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  _getUpcomingAnniversarylist() async{
    final body = {
      "api_access_token" : "ywrtaw46veltitizqhbs",
    };
    var response = await http.post(
      Uri.parse(BASE_URL+anniversarylistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data']['upcoming'];
      List<Upcoming> upcominglist = list.map((m) => Upcoming.fromJson(m)).toList();
      return upcominglist;
    } else {
      List<Upcoming> list = [];
      return list;
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  openwhatsapp(String mobile) async{
    var whatsapp ="+91"+mobile;
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=Hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("Hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  _launchEmail(String email){
    launch('mailto:$email?subject=&body=');
  }
}
