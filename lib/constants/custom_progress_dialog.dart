import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyways_group/constants/constant.dart';

class CustomProgressDialog{

  static Widget getProgress(BuildContext context, String message){
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      child: Container(
          height: 65.0,
          width: double.infinity,
          child: Card(
              elevation: 5.0,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 24.0,
                      width:  24.0,
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                    SizedBox(width: 20.0),
                    Text(message, style: TextStyle(color: Colors.black, fontSize: 18.0))
                  ],
                ),
              )
          )
      ),
    );
  }

}