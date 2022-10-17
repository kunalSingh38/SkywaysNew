import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/constants/constant.dart';


class SelfCancelLeaveDialog extends StatelessWidget{

  String id;

  SelfCancelLeaveDialog({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
    height: 175,
    decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        SizedBox(height: 24,),
        Text('Are you sure?', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(height: 8,),
        const Padding(
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Text('Do you really want to cancel your leave request?', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
        ),
        SizedBox(height: 24,),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No'), color: Colors.green, textColor: Colors.white),
            SizedBox(width: 8,),
            RaisedButton(onPressed: () async{
              _cancelSelfleave(id);
              Navigator.of(context).pop();
            }, child: Text('Yes'), color: Colors.red, textColor: Colors.white)
          ],
        )
      ],
    ),
  );


  _cancelSelfleave(String id) async{
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + selfleavecancelUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      showToast(json.decode(response.body)['message']);
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}