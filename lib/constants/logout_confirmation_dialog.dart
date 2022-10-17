import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/screens/login_screen.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({Key key}) : super(key: key);

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
    height: 250,
    decoration: BoxDecoration(
        color: kPrimaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/new_logo.png', height: 60, width: 60, fit: BoxFit.fitHeight),
          ),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        SizedBox(height: 24,),
        Text('Are you sure?', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        SizedBox(height: 8,),
        const Padding(
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Text('Do you really want to logout from application?', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No'),textColor: Colors.white),
            SizedBox(width: 8),
            RaisedButton(onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              prefs.setBool('logged_in', false);
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()),
                      (route) => false);
            }, child: Text('Yes'), color: Colors.white, textColor: kPrimaryColor)
          ],
        )
      ],
    ),
  );

  /*_buildChild(BuildContext context) => Container(
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
          child: Text('Do you really want to logout from application?', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
        ),
        SizedBox(height: 24,),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No'), color: Colors.green, textColor: Colors.white),
            SizedBox(width: 8),
            RaisedButton(onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('logged_in', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }, child: Text('Yes'), color: Colors.red, textColor: Colors.white)
          ],
        )
      ],
    ),
  );*/
}
