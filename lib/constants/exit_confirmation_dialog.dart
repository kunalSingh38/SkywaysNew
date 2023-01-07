import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skyways_group/constants/constant.dart';

class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 250,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/new_logo.png',
                    height: 60, width: 60, fit: BoxFit.fitHeight),
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Do you want to exit the application?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            // SizedBox(
            //   height: 8,
            // ),
            // const Padding(
            //   padding: EdgeInsets.only(right: 16, left: 16),
            //   child: Text(
            //     'Do you really want to exit from application?',
            //     style: TextStyle(color: Colors.white),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    return exit(0);
                    //return Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
