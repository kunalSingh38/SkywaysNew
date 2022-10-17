import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyways_group/constants/constant.dart';

class NoticeBoardDetailScreen extends StatefulWidget {
  final Object argument;
  const NoticeBoardDetailScreen({Key key, this.argument}) : super(key: key);

  @override
  _NoticeBoardDetailScreenState createState() =>
      _NoticeBoardDetailScreenState();
}


class _NoticeBoardDetailScreenState extends State<NoticeBoardDetailScreen> {

  String title;
  String timestamp;
  String description;


  @override
  void initState() {

    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);

    print(data['title'].toString());

    title = data['title'].toString();
    timestamp = data['date'].toString();
    description = data['desc'].toString();

  }

  void dispose() {

    super.dispose();
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
              child: SvgPicture.asset(
                'assets/svg/mask_group_other.svg',
                fit: BoxFit.fill,
              )),
          Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
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
                          }, icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black)),
                          Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.22),
                              child: Text("Notice Board", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                          /*IconButton(
                              icon: Icon(Icons.bookmark_border,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {

                              }),*/
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            timestamp,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 5.0),
                        child: Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
