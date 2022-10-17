import 'package:flutter/material.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/screens/salary_slips_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfViewerScreen extends StatefulWidget {

  String filepath;

  MyPdfViewerScreen({this.filepath});

  @override
  _MyPdfViewerScreenState createState() => _MyPdfViewerScreenState(filepath);
}

class _MyPdfViewerScreenState extends State<MyPdfViewerScreen> {

  String filepath;

  PdfViewerController _controller;

  _MyPdfViewerScreenState(this.filepath);

  @override
  void initState() {
    _controller = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text("Salary Slip", style: TextStyle(color: Colors.white)),
          actions: [
            GestureDetector(
                onTap: (){
                  _controller.zoomLevel = 1.50;
                },
                child: Icon(Icons.zoom_in, color: Colors.white, size: 24.0,)
            )
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
              initialZoomLevel: 1.25,
            ),
          ),
        )
    ),
        onWillPop: _willPopCallback,
    );
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SalarySlipScreen()));
  }
}
