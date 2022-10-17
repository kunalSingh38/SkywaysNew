// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/model/branchlistdata.dart';
import 'package:skyways_group/model/expenselistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/reimbursement_screen.dart';

class ApplyReimbursementScreen extends StatefulWidget {
  @override
  _ApplyReimbursementScreenState createState() =>
      _ApplyReimbursementScreenState();
}

class _ApplyReimbursementScreenState extends State<ApplyReimbursementScreen> {
  String empid;
  String empbranch;
  String empbranchid;

  String expensetypevalue;

  ProgressDialog pr;

  String expensetype;

  XFile _imageCheque;
  String docPic = "Select Document Proof";

  List<String> _data = [];
  List<String> _dataid = [];
  List demoList = [];

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  TextEditingController remarksController = TextEditingController();
  TextEditingController expenseamtController = TextEditingController();
  TextEditingController othersConroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _getProfileDetails();
    _getexpenselist();
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

  _getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("emp id" + prefs.getString('employee_id')); //id 1305
      print("branch name" + prefs.getString('branchname')); //branch chennai
      empid = prefs.getString('employee_id');
      empbranch = prefs.getString('branchname');

      _branchlist();
    });
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

  @override
  Widget build(BuildContext context) {
    /* pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      progress: 80.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(10.0), child: CircularProgressIndicator(color: kPrimaryColor)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w100),
    );*/

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: SingleChildScrollView(
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
                            icon: Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 20)),
                        Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.22),
                            child: Text("Reimbursement",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.83,
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
                          padding: EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    child: const Text("Apply",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReimbursementScreen()));
                                },
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    child: const Text("List",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0))),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.72,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Card(
                                    color: Colors.grey.shade300,
                                    elevation: 4.0,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: const Text("Expense Type",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            value: expensetype,
                                            elevation: 16,
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 16),
                                            onChanged: (String data) {
                                              setState(() {
                                                demoList.forEach((element) {
                                                  if (element['name']
                                                          .toString() ==
                                                      data.toString()) {
                                                    expensetype =
                                                        data.toString();
                                                    expensetypevalue =
                                                        element['id']
                                                            .toString();
                                                  }
                                                });
                                              });
                                            },
                                            items: _data
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
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
                                const SizedBox(height: 15.0),
                                _textInputField("Expense Remarks",
                                    remarksController, TextInputType.text),
                                const SizedBox(height: 15.0),
                                _textInputField("Expense Amount",
                                    expenseamtController, TextInputType.number),
                                const SizedBox(height: 15.0),
                                _textInputField("Others", othersConroller,
                                    TextInputType.text),
                                const SizedBox(height: 15.0),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Card(
                                      elevation: 4.0,
                                      color: Colors.grey.shade300,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            docPic == "Select Document Proof" ||
                                                    docPic == null ||
                                                    docPic.toString() == ""
                                                ? const SizedBox()
                                                : CircleAvatar(
                                                    radius: 18,
                                                    backgroundImage: FileImage(
                                                        File(
                                                            _imageCheque.path)),
                                                  ),
                                            const SizedBox(width: 5.0),
                                            Expanded(
                                                child: Text('$docPic',
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14.0))),
                                            RaisedButton(
                                                color: Colors.grey,
                                                elevation: 0,
                                                child: Text("Browse",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[700])),
                                                onPressed: () {
                                                  _showDocPicker(context);
                                                  // showDialog(
                                                  //     context: context,
                                                  //     builder:
                                                  //         (context) =>
                                                  //             AlertDialog(
                                                  //               title: Text(
                                                  //                   "Select"),
                                                  //               content: Row(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .spaceEvenly,
                                                  //                 children: [
                                                  //                   ElevatedButton(
                                                  //                       onPressed:
                                                  //                           () async {
                                                  //                         Navigator.of(context)
                                                  //                             .pop();
                                                  //                         FilePickerResult
                                                  //                             result =
                                                  //                             await FilePicker.platform.pickFiles();

                                                  //                         if (result !=
                                                  //                             null) {
                                                  //                           docPic =
                                                  //                               result.files.single.path.toString();
                                                  //                         }
                                                  //                       },
                                                  //                       child: Text(
                                                  //                           "Document")),
                                                  //                   ElevatedButton(
                                                  //                       onPressed:
                                                  //                           () {
                                                  //                         Navigator.of(context)
                                                  //                             .pop();
                                                  //                         _showDocPicker(
                                                  //                             context);
                                                  //                       },
                                                  //                       child: Text(
                                                  //                           "Image"))
                                                  //                 ],
                                                  //               ),
                                                  //             ));
                                                }),
                                          ],
                                        ),
                                      ),
                                    )),
                                const SizedBox(height: 40.0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 45.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        if (expensetype.toString() == "" ||
                                            expensetype == null) {
                                          showToast(
                                              'Please select expense type');
                                          return;
                                        }
                                        if (remarksController.text
                                                .toString()
                                                .trim()
                                                .isEmpty ||
                                            remarksController.text.toString() ==
                                                "") {
                                          showToast(
                                              'Please enter your remarks');
                                          return;
                                        }
                                        if (expenseamtController.text
                                            .toString()
                                            .isEmpty) {
                                          showToast(
                                              'Please enter expense amount');
                                          return;
                                        }
                                        if (othersConroller.text
                                            .toString()
                                            .isEmpty) {
                                          showToast(
                                              'Please enter other details');
                                          return;
                                        }
                                        if (docPic == "Select Document Proof" ||
                                            docPic == null ||
                                            docPic.toString() == "" ||
                                            docPic.toString() == "null") {
                                          showToast(
                                              'Please upload your document');
                                          return;
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                  title: Text("Please Wait"),
                                                  content: Row(children: [
                                                    CircularProgressIndicator(),
                                                    SizedBox(width: 10),
                                                    Text("Loading...")
                                                  ])));
                                          _submit(
                                              remarksController.text.toString(),
                                              expenseamtController.text
                                                  .toString(),
                                              othersConroller.text.toString());
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textInputField(String text, TextEditingController _controller,
      TextInputType _inputType) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        elevation: 4.0,
        color: Colors.grey.shade300,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
              border: InputBorder.none,
              hintText: text,
            ),
            controller: _controller,
            cursorColor: kPrimaryColor,
            keyboardType: _inputType,
          ),
        ),
      ),
    );
  }

  void _submit(String remarks, String expense, String others) async {
    print("Image here " + _imageCheque.path);

    var requestMulti = http.MultipartRequest(
        'POST', Uri.parse(BASE_URL + applyreimbursementUrl));
    requestMulti.fields["emp_id"] = empid.toString();
    requestMulti.fields["branch_id"] = empbranchid.toString();
    requestMulti.fields["type_of_expense"] = expensetypevalue;
    requestMulti.fields["expense_amt"] = expense;
    requestMulti.fields["expense_remarks"] = remarks;
    requestMulti.fields["others_text"] = others;
    requestMulti.fields["api_access_token"] = "ywrtaw46veltitizqhbs";

    requestMulti.files
        .add(await http.MultipartFile.fromPath('doc_proof', _imageCheque.path));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        var responseString = String.fromCharCodes(value);
        var jsonData = jsonDecode(responseString);
        Navigator.of(context).pop();
        print(jsonData);
        if (jsonData['success'] == true) {
          showToast(jsonData['message'].toString());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ReimbursementScreen()));
        } else {
          showToast(jsonData['message'].toString());
        }
      });
    });
  }

  Future<List<ExpenseData>> _getexpenselist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
    };
    var response = await http.post(
      Uri.parse(BASE_URL + expensetypelistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        demoList = json.decode(response.body)['data'];
        demoList.forEach((element) {
          _data.add(element['name'].toString());
          _dataid.add(element['id'].toString());
        });
      });
      //Iterable list = json.decode(response.body)['data'];
      //List<ExpenseData> _list = list.map((m) => ExpenseData.fromJson(m)).toList();
      //print(_list);
      /*setState(() {
          _data.add(_list[0].s1);
          _data.add(_list[0].s2);
          _data.add(_list[0].s3);
          _data.add(_list[0].s4);
      });*/
      //return leavestatuslist;
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _showDocPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        _docimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _docimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _docimgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imageCheque = photo;
      docPic = _imageCheque.path.split('/').last;
    });
  }

  _docimgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imageCheque = image;
      docPic = _imageCheque.path.split('/').last;
    });
  }
}
