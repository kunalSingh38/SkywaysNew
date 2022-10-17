// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/animations/animations.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/branchlistdata.dart';
import 'package:skyways_group/model/employeelistdata.dart';
import 'package:skyways_group/screens/profile_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDirectoryScreen extends StatefulWidget {
  const EmployeeDirectoryScreen({Key key}) : super(key: key);

  @override
  _EmployeeDirectoryScreenState createState() =>
      _EmployeeDirectoryScreenState();
}

class _EmployeeDirectoryScreenState extends State<EmployeeDirectoryScreen> {
  ProgressDialog pr;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _gKey = new GlobalKey<ScaffoldState>();

  String branch_id = "";
  String company_id = "";

  int counter = 0;
  bool isLoading = false;
  bool isListing = true;
  bool listCheck = false;

  TextEditingController searchText = TextEditingController();

  String emp_image, emp_name, emp_dest, emp_dob, emp_mail;

  List<dynamic> branchlistData = [];
  List<dynamic> companylistData = [];

  // Initial Selected Value
  String initialcompanyname;
  String initialbranchname;
  List<String> _companydata = [];
  List<String> _branchdata = [];

  List<Data> _emplist = List<Data>();
  List<Data> _searchResult = List<Data>();

  final controller = ScrollController();

  @override
  void initState() {
    getemplist();
    super.initState();
    _branchlist();
    _companylist();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          isListing) {
        employeelist(branch_id, company_id);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void getemplist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('branch_id').toString()+" "+prefs.getString('company_id').toString());
    setState(() {
      counter = 0;
      branch_id = prefs.getString('branch_id');
      company_id = prefs.getString('company_id');
    });
    // Future<dynamic> temp =
    employeelist(prefs.getString('branch_id').toString(),
        prefs.getString('company_id').toString());
    /*temp.then((value) {
      setState(() {
       */ /* _emplist.addAll(value);*/ /*
        print(_emplist.toString()+" helloo");
        _searchResult = _emplist;
      });
    });*/
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _gKey,
      appBar: buildAppBar(),
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
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  height: 45.0,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/search.svg'),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextField(
                        controller: searchText,
                        decoration: InputDecoration(
                          hintText: 'Search Here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 5.0),
                        ),
                        // onChanged: (text) {
                        //   setState(() {
                        //     counter = 0;
                        //   });
                        //   if (text.toString().trim().isEmpty ||
                        //       text.toString().toString().length == 0) {
                        //     FocusScope.of(context).unfocus();
                        //     setState(() {
                        //       _searchResult.clear();
                        //       _searchResult.addAll(_emplist);
                        //       isListing = true;
                        //     });
                        //   } else {
                        //     setState(() {
                        //       isListing = false;
                        //     });
                        //     if (text.contains(RegExp(r'[0-9]'))) {
                        //       employeelistbynameormobile("", text.toString());
                        //     } else {
                        //       employeelistbynameormobile(text.toString(), "");
                        //     }
                        //   }

                        //   /*setState(() {
                        //       _searchResult = _emplist.where((post) {
                        //       var empName = post.empName.toLowerCase();
                        //       var empMobile = post.empMobile;
                        //       if (empName.toLowerCase().trim().contains(text.toLowerCase().trim())) {
                        //         return empName.contains(text);
                        //       } else {
                        //         return empMobile.contains(text);
                        //       }
                        //     }).toList();
                        //   });*/
                        // },
                        onChanged: (val) {
                          if (val.length == 0) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _searchResult.clear();
                              _searchResult.addAll(_emplist);
                              isListing = true;
                            });
                          }
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            counter = 0;
                          });
                          if (searchText.text.toString().trim().isEmpty ||
                              searchText.text.toString().toString().length ==
                                  0) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _searchResult.clear();
                              _searchResult.addAll(_emplist);
                              isListing = true;
                            });
                          } else {
                            setState(() {
                              isListing = false;
                            });
                            if (searchText.text.contains(RegExp(r'[0-9]'))) {
                              employeelistbynameormobile(
                                  "", searchText.text.toString());
                            } else {
                              employeelistbynameormobile(
                                  searchText.text.toString(), "");
                            }
                          }
                        },
                        cursorColor: kPrimaryColor,
                      )),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            counter = 0;
                          });
                          if (searchText.text.toString().trim().isEmpty ||
                              searchText.text.toString().toString().length ==
                                  0) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _searchResult.clear();
                              _searchResult.addAll(_emplist);
                              isListing = true;
                            });
                          } else {
                            setState(() {
                              isListing = false;
                            });
                            if (searchText.text.contains(RegExp(r'[0-9]'))) {
                              employeelistbynameormobile(
                                  "", searchText.text.toString());
                            } else {
                              employeelistbynameormobile(
                                  searchText.text.toString(), "");
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Search",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                        title: Text("Select"),
                                        content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Column(children: [
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                hint: Text("Select Company",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                value: initialcompanyname,
                                                elevation: 16,
                                                isExpanded: true,
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 16),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    companylistData
                                                        .forEach((element) {
                                                      if (element['company_name']
                                                              .toString() ==
                                                          data.toString()) {
                                                        initialcompanyname =
                                                            data.toString();
                                                        company_id =
                                                            element['id']
                                                                .toString();
                                                      }
                                                    });
                                                  });
                                                },
                                                items: _companydata.map<
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
                                            SizedBox(height: 5),
                                            Divider(
                                                height: 1,
                                                color: Colors.grey,
                                                thickness: 1),
                                            SizedBox(height: 5),
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                hint: Text("Select Branch",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                value: initialbranchname,
                                                elevation: 16,
                                                isExpanded: true,
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 16),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    branchlistData
                                                        .forEach((element) {
                                                      if (element['branch_name']
                                                              .toString() ==
                                                          data.toString()) {
                                                        initialbranchname =
                                                            data.toString();
                                                        branch_id =
                                                            element['id']
                                                                .toString();
                                                      }
                                                    });
                                                  });
                                                },
                                                items: _branchdata.map<
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
                                            SizedBox(height: 25),
                                            InkWell(
                                              onTap: () {
                                                if (initialcompanyname ==
                                                        null ||
                                                    initialcompanyname == "") {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    company_id = "";
                                                    _searchResult.clear();
                                                    counter = 0;
                                                  });
                                                  employeelist(
                                                      branch_id, company_id);
                                                } else if (initialbranchname ==
                                                        null ||
                                                    initialbranchname == "") {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    branch_id = "";
                                                    _searchResult.clear();
                                                    counter = 0;
                                                  });
                                                  employeelist(
                                                      branch_id, company_id);
                                                } else {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _searchResult.clear();
                                                    counter = 0;
                                                  });
                                                  employeelist(
                                                      branch_id, company_id);
                                                }
                                              },
                                              child: Container(
                                                height: 45,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                child: Text("Submit",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )
                                            /* TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    _companyDialogBox();
                                  }, child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Company", style: TextStyle(color: Colors.black))
                                  )),*/
                                            /*Divider(height: 1, color: Colors.black),*/
                                            /*TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    _branchDialogBox();
                                  }, child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Branch", style: TextStyle(color: Colors.black))))*/
                                          ]),
                                        ));
                                  }));
                          //
                        },
                        child: Container(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset('assets/svg/filter.svg'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Employee List",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              listCheck == false
                  ? Expanded(
                      child: Center(
                      child: Text("Data not found"),
                    ))
                  : Expanded(
                      //height: MediaQuery.of(context).size.height * 0.69,
                      //width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.83),
                            itemCount: _searchResult.length + 1,
                            controller: controller,
                            itemBuilder: (context, index) {
                              if (index == _searchResult.length) {
                                return _buildProgressIndicator();
                              } else {
                                return Card(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 8, //8
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: _searchResult[index]
                                                                    .empImage ==
                                                                null ||
                                                            _searchResult[index]
                                                                    .empImage ==
                                                                ""
                                                        ? const AssetImage(
                                                            'assets/images/no_image.jpg')
                                                        : NetworkImage(
                                                            _searchResult[index]
                                                                .empImage),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0,
                                                  top: 4.0,
                                                  right: 2.0),
                                              child: Text(
                                                  _searchResult[index].empName,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(_searchResult[index].desigName,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 12.0)),
                                            SizedBox(height: 5.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0,
                                                  top: 4.0,
                                                  right: 0.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        launch('tel:+91' +
                                                            _searchResult[index]
                                                                .empMobile);
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/svg/call.svg',
                                                          fit: BoxFit.cover),
                                                    ),
                                                    SizedBox(width: 7.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _launchEmail(
                                                            _searchResult[index]
                                                                .empMail);
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/svg/message.svg',
                                                          fit: BoxFit.cover),
                                                    ),
                                                    SizedBox(width: 7.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        openwhatsapp(
                                                            _searchResult[index]
                                                                .empMobile);
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/svg/whatsapp.svg',
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                            left: 20,
                                            bottom: 10,
                                            right: 20,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ProfileViewScreen(
                                                            name: _searchResult[index]
                                                                .empName,
                                                            id: _searchResult[index]
                                                                .empId,
                                                            photo: _searchResult[index]
                                                                .empImage,
                                                            designation:
                                                                _searchResult[index]
                                                                    .desigName,
                                                            department:
                                                                _searchResult[index]
                                                                    .deptName,
                                                            company:
                                                                _searchResult[index]
                                                                    .compName,
                                                            dob: _searchResult[index]
                                                                .empDob,
                                                            mobile: _searchResult[index]
                                                                .empMobile,
                                                            email: _searchResult[index]
                                                                .empMail,
                                                            joiningdate:
                                                                _searchResult[index]
                                                                    .empJoinDateDdmmyy,
                                                            location: _searchResult[index].empAdd1,
                                                            bloodgroup: _searchResult[index].bloodGroup,
                                                            dobmonth: _searchResult[index].empDobMonthyear)));
                                              },
                                              child: Container(
                                                height: 25.0,
                                                width: 85.0,
                                                decoration: const BoxDecoration(
                                                    color: Colors.black87,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0))),
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5.0),
                                                  child: Text("View Profile",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0)),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ));
                              }
                            },
                          )),
                    )
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.action),
    );
  }

  Future employeelistbynameormobile(String name, String mobile) async {
    print("name " + name);
    print("mobile " + mobile);
    //_emplist.clear();
    _searchResult.clear();
    setState(() {
      isLoading = true;
    });
    List list = [];
    print(jsonEncode({
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_name": name,
      "emp_mobile": mobile,
      "limit": "8",
      "offset": counter.toString(),
    }));
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_name": name,
      "emp_mobile": mobile,
      "limit": "8",
      "offset": counter.toString(),
    };
    var response = await http.post(Uri.parse(BASE_URL + employeelistUrl),
        body: body, headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      list.clear();
      list = json.decode(response.body)['data'];
      var _employeeslist = list.map((m) => Data.fromJson(m)).toList();
      print(_employeeslist);
      setState(() {
        isLoading = false;
        //_emplist.addAll(_employeeslist);
        _searchResult.addAll(_employeeslist);
        counter = counter + 8;
      });
      return _employeeslist;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future employeelist(String branchid, String companyid) async {
    print("branch id " + branchid);
    print("Company id " + companyid);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      List list = [];
      print(jsonEncode({
        "company_id": companyid,
        "branch_id": branchid,
        "api_access_token": "ywrtaw46veltitizqhbs",
        "limit": "8",
        "offset": counter.toString(),
      }));
      final body = {
        "company_id": companyid,
        "branch_id": branchid,
        "api_access_token": "ywrtaw46veltitizqhbs",
        "limit": "8",
        "offset": counter.toString(),
      };
      var response = await http.post(Uri.parse(BASE_URL + employeelistUrl),
          body: body, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        list.clear();
        list = json.decode(response.body)['data'];
        var _employeeslist = list.map((m) => Data.fromJson(m)).toList();
        print(_employeeslist);
        setState(() {
          isLoading = false;
          listCheck = true;
          _emplist.addAll(_employeeslist);
          _searchResult.addAll(_employeeslist);
          counter = counter + 8;
        });
        return _employeeslist;
      } else {
        setState(() {
          isLoading = false;
        });
        if (_searchResult.length == 0) {
          setState(() {
            isLoading = false;
            listCheck = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 1, milliseconds: 500),
              backgroundColor: Colors.red,
              content: Text(
                  json.decode(response.body)['error']['error'].toString(),
                  style: TextStyle(color: Colors.white))));
        }
        throw Exception('Failed to get data due to ${response.body}');
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.40),
            child: Container(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: kPrimaryColor)),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black)),
      centerTitle: true,
      title: const Text("Employee Directory",
          style: TextStyle(color: Colors.black, fontSize: 16.0)),
    );
  }

  Future _companylist() async {
    final body = {"api_access_token": "ywrtaw46veltitizqhbs"};
    var response = await http.post(
      Uri.parse(BASE_URL + companylistUrl),
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      setState(() {
        companylistData.addAll(list);
        companylistData.forEach((element) {
          _companydata.add(element['company_name'].toString());
          //_dataid.add(element['id'].toString());
        });
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _branchlist() async {
    final body = {"api_access_token": "ywrtaw46veltitizqhbs"};
    var response = await http.post(
      Uri.parse(BASE_URL + branchlistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      setState(() {
        branchlistData.addAll(list);
        branchlistData.forEach((element) {
          _branchdata.add(element['branch_name'].toString());
          //_dataid.add(element['id'].toString());
        });
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
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

  _companyDialogBox() {
    // return showGeneralDialog(
    //   context: context,
    //   barrierLabel: '',
    //   barrierDismissible: true,
    //   transitionDuration: Duration(milliseconds: 200),
    //   transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
    //     return Animations.fromLeft(_animation, _secondaryAnimation, _child);
    //   },
    //   pageBuilder: (_animation, _secondaryAnimation, _child) {
    //     // return _companylistDialog(context);
    //
    //   },
    // );
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select2"),
              content: Container(
                child: Row(
                  children: [
                    FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: "SKYWAYS AIR SERVICES PVT. LTD.",
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  //sectionCodeValue = newValue.toString();
                                });
                              },
                              items: companylistData.map((value) {
                                return DropdownMenuItem(
                                  value: value['company_name'].toString(),
                                  child: Text(
                                    value['company_name'].toString(),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget _companylistDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildCompanyChild(context),
    );
  }

  _buildCompanyChild(BuildContext context) => Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.10, bottom: 0.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: Scrollbar(
                    thickness: 2,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: companylistData.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(companylistData);
                        return companylist(context, index,
                            companylistData[index]['company_name'].toString());
                      },
                    ),
                  ))
            ],
          ),
        ),
      );

  Widget companylist(context, int index, String companyname) {
    return InkWell(
      onTap: () {
        setState(() {
          counter = 0;
          _searchResult.clear();
          _emplist.clear();
        });
        Navigator.pop(context);
        String companyid = companylistData[index]['id']; // filter now
        company_id = companyid;
        employeelist("", company_id).then((value) {
          setState(() {
            counter = 0;
            _searchResult.clear();
            _emplist.clear();
            _emplist.addAll(value);
            _searchResult = _emplist;
          });
        });
      },
      child: Container(
        height: 40.0,
        width: double.infinity,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
              child:
                  Icon(Icons.account_balance, size: 12.0, color: Colors.grey),
            ),
            const SizedBox(width: 0.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                child: Text(companyname,
                    style:
                        const TextStyle(color: Colors.black, fontSize: 14.0)),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                child: Icon(Icons.arrow_forward_ios,
                    size: 18.0, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  _branchDialogBox() {
    return showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
        return Animations.fromLeft(_animation, _secondaryAnimation, _child);
      },
      pageBuilder: (_animation, _secondaryAnimation, _child) {
        return _branchlistDialog(context);
      },
    );
  }

  Widget _branchlistDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildBranchChild(context),
    );
  }

  _buildBranchChild(BuildContext context) => Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.10, bottom: 0.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: Scrollbar(
                    thickness: 2,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: branchlistData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return branchlist(
                            context, index, branchlistData[index].branchName);
                      },
                    ),
                  ))
            ],
          ),
        ),
      );

  Widget branchlist(context, int index, String branchname) {
    return InkWell(
      onTap: () {
        setState(() {
          counter = 0;
          _searchResult.clear();
          _emplist.clear();
        });
        Navigator.pop(context);
        String branchid = branchlistData[index].id; // filter now
        branch_id = branchid;
        employeelist(branch_id, "").then((value) {
          setState(() {
            _emplist.addAll(value);
            _searchResult = _emplist;
          });
        });
      },
      child: Container(
        height: 40.0,
        width: double.infinity,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Icon(Icons.account_balance, size: 12.0, color: Colors.grey),
            ),
            const SizedBox(width: 0.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(branchname,
                    style:
                        const TextStyle(color: Colors.black, fontSize: 14.0)),
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios,
                    size: 18.0, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
