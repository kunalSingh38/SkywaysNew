import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/salaryslipslistdata.dart';
import 'package:skyways_group/screens/mypdf_viewer_screen.dart';

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({Key key}) : super(key: key);

  @override
  _SalarySlipScreenState createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  String currentyear;
  String years;
  var path;
  String _saveDir;

  var date = DateTime.now().toString();

  //var dateParse = DateTime.parse(date);

  //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  String dropdownvalue = '2022';

  // List of items in our dropdown menu
  var items = [
    '2019',
    '2020',
    '2021',
    '2022',
  ];

  var yearlist = [];

  final List tilelist = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  final List monthlist = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentYear();
    _getDirectory();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  ReceivePort _port = ReceivePort();
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _getDirectory() async {
    if (Platform.isAndroid) {
      final baseStorage = await getExternalStorageDirectory();
      setState(() {
        _saveDir = baseStorage.path;
      });
    } else {
      final baseStorage = await getApplicationDocumentsDirectory();
      setState(() {
        _saveDir = baseStorage.path;
      });
    }
  }

  _getCurrentYear() {
    DateTime selectedDate = DateTime.now();
    setState(() {
      currentyear = selectedDate.year.toString();
      years = (int.parse(selectedDate.year.toString()) - 1).toString() +
          "-" +
          selectedDate.year.toString();

      yearlist.add((int.parse(currentyear) - 5).toString());
      yearlist.add((int.parse(currentyear) - 4).toString());
      yearlist.add((int.parse(currentyear) - 3).toString());
      yearlist.add((int.parse(currentyear) - 2).toString());
      yearlist.add((int.parse(currentyear) - 1).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 20)),
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.22),
                          child: Text("Salary Slips",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 5.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownvalue = newValue;
                                    currentyear = newValue;
                                    _salaryslipslist();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 25.0, right: 10.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.67,
                              child: FutureBuilder(
                                  future: _salaryslipslist(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    List<SalarySlipData> list = [];
                                    list.clear();
                                    list = snapshot.data;
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: Container(
                                              height: 24.0,
                                              width: 24.0,
                                              child: CircularProgressIndicator(
                                                  color: kPrimaryColor)));
                                    } else {
                                      if (list.isEmpty ||
                                          list == "" ||
                                          list == null) {
                                        return Center(
                                          child: Text("Data Not Found"),
                                        );
                                      } else {
                                        return ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                  color: Colors.transparent,
                                                  height: 8.0);
                                            },
                                            padding: EdgeInsets.zero,
                                            itemCount: list.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (list[index].month == "1") {
                                                return _listItem(
                                                    tilelist[0],
                                                    monthlist[0],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "2") {
                                                return _listItem(
                                                    tilelist[1],
                                                    monthlist[1],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "3") {
                                                return _listItem(
                                                    tilelist[2],
                                                    monthlist[2],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "4") {
                                                return _listItem(
                                                    tilelist[3],
                                                    monthlist[3],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "5") {
                                                return _listItem(
                                                    tilelist[4],
                                                    monthlist[4],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "6") {
                                                return _listItem(
                                                    tilelist[5],
                                                    monthlist[5],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "7") {
                                                return _listItem(
                                                    tilelist[6],
                                                    monthlist[6],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "8") {
                                                return _listItem(
                                                    tilelist[7],
                                                    monthlist[7],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "9") {
                                                return _listItem(
                                                    tilelist[8],
                                                    monthlist[8],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "10") {
                                                return _listItem(
                                                    tilelist[9],
                                                    monthlist[9],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "11") {
                                                return _listItem(
                                                    tilelist[10],
                                                    monthlist[10],
                                                    list[index].filePath);
                                              }
                                              if (list[index].month == "12") {
                                                return _listItem(
                                                    tilelist[11],
                                                    monthlist[11],
                                                    list[index].filePath);
                                              }
                                            });
                                      }
                                    }
                                  })))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  Widget _listItem(String tile, String name, String filepath) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Text(tile,
                  style: TextStyle(color: Colors.white, fontSize: 12.0)),
            ),
            SizedBox(width: 5.0),
            Expanded(
                child: Text(name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold))),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPdfViewerScreen(
                              filepath: filepath,
                            )));
              },
              child: Container(
                height: 30,
                width: 65,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    "View",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            GestureDetector(
              onTap: () async {
                _setPath(filepath);
                // _requestDownload(filepath);
              },
              child: Container(
                height: 30,
                width: 90,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    "Download",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<List<SalarySlipData>> _salaryslipslist() async {
    List<SalarySlipData> salarysliplist = [];
    salarysliplist.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "input_year": currentyear, //currentyear,
      "emp_id": prefs.getString('employee_id')
    };
    var response = await http.post(
      Uri.parse(BASE_URL + salarysliplistUrl),
      body: body,
    );
    print(jsonDecode(response.body)['data']);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      salarysliplist = list.map((m) => SalarySlipData.fromJson(m)).toList();
      return salarysliplist;
    } else {
      return [];
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _setPath(String filepath) async {
    bool permissionAccess = false;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionAccess = true;
      });
    }
    if (await Permission.manageExternalStorage.request().isGranted) {
      setState(() {
        permissionAccess = true;
      });
    }

    if (permissionAccess) {
      final externalDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      String fileName = DateTime.now().toString() + ".pdf";
      print(externalDir.path + "/" + fileName);
      final id = await FlutterDownloader.enqueue(
          url: filepath,
          savedDir: externalDir.path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true);
      if (id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File Downloaded"),
          ),
        );
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("View Downloaded File"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          OpenFile.open(externalDir.path + "/" + fileName);
                        },
                        child: Text("View"))
                  ],
                ));
      }

      // print(id.toString());

      // print(externalDir.path + "/" + fileName);
    }
  }
}
