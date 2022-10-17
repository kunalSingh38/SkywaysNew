import 'package:flutter/material.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/screens/employee_induction_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPolicyScreen extends StatefulWidget {
  String filepath;
  String policynumber;

  ViewPolicyScreen({this.filepath, this.policynumber});

  @override
  _ViewPolicyScreenState createState() => _ViewPolicyScreenState(filepath, policynumber);
}

class _ViewPolicyScreenState extends State<ViewPolicyScreen> {
  String filepath;
  String policynumber;

  PdfViewerController _controller;

  _ViewPolicyScreenState(this.filepath, this.policynumber);

  @override
  void initState() {
    _controller = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title:
                Text("Company Policy", style: TextStyle(color: Colors.white)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Text(policynumber, textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor)),
                ),
              ),
            ],
          ),
          body: Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SfPdfViewer.network(
                filepath,
                controller: _controller,
                initialZoomLevel: 1.00,
              ),
            ),
          )),
      onWillPop: () async {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const EmployeeInductionScreen()));
      },
    );
  }
}
