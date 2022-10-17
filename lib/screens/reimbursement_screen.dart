import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/helper/dialog_helper.dart';
import 'package:skyways_group/model/reibursementlistdata.dart';
import 'package:skyways_group/screens/apply_reimbursement_screen.dart';
import 'package:skyways_group/screens/view_policy_screen.dart';

class ReimbursementScreen extends StatefulWidget {

  @override
  _ReimbursementScreenState createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends State<ReimbursementScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: SvgPicture.asset('assets/svg/mask_group_other.svg', fit: BoxFit.fill)
              ),
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
                        padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                        child: Row(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black)),
                            Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.22),
                                child: const Text("Reimbursement List",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              width: double.infinity,
                              child: FutureBuilder(
                                  future: _getReimbursementlist(),
                                  builder: (context, snapshot) {
                                    List<ReimbursementData> list = snapshot.data;
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
                                              color: Colors.transparent,
                                              thickness: 2.0,
                                              height: 4.0);
                                        },
                                        scrollDirection: Axis.vertical,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _reimbursementlistData("Request Date: "+list[index].requestDate, "Expense Amount: "+list[index].expenseAmt, list[index].status, list[index].docProof, list[index].approveRemarks, index);
                                        },
                                      );
                                    }
                                  }))),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      onWillPop: () async {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ApplyReimbursementScreen()));
      },
    );
  }

  Widget _reimbursementlistData(reqdate, expenseamt, status, docproof, approveremark, int index) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Card(
          elevation: 4.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(reqdate, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
                        ),
                        SizedBox(height: 2.0),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(expenseamt, textAlign: TextAlign.start)
                        ),
                        /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Text(expenseamt)
                        ),
                        statusWidget(status.toString()),
                      ],
                    )*/
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        DialogHelper.viewimagedialog(docproof.toString(), context);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0))
                        ),
                        child: CachedNetworkImage(

                          fit: BoxFit.fill,
                          progressIndicatorBuilder: (context, url, progress) => Center(
                            child: Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          imageUrl: docproof.toString(),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Status"),
                         statusWidget(status.toString()),
                       ],
                     ),
                     Column(
                      children: [
                        Text("Approve Remark"),
                        approveremark.toString() == "" || approveremark.toString() == "null" ? Text("") : Text(approveremark)
                      ],
                    ),
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  _getReimbursementlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_id": prefs.getString('employee_id'),
    };
    var response = await http.post(
      Uri.parse(BASE_URL + reimbursementlistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      List<ReimbursementData> leavestatuslist = list.map((m) => ReimbursementData.fromJson(m)).toList();
      return leavestatuslist;
    } else {
      showToast(json.decode(response.body)['error']['error']);
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget statusWidget(String status){
    if(status == "0" || status == "null"){
      return Text("Pending", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16.0));
    }
    else if(status == "1"){
      return Text("Approved", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16.0));
    }
    else {
      return Text("Disapproved", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16.0));
    }
  }
}
