import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:skyways_group/components/notification_item.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/model/notificationlistdata.dart';
import 'package:skyways_group/screens/home_sceen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  int counter = 0;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ModalProgressHUD(
         inAsyncCall: _loading,
         child: Stack(
           children: [
             Positioned(
                 left: 0,
                 bottom: 0,
                 right: 0,
                 child: SvgPicture.asset('assets/svg/mask_group_other.svg', fit: BoxFit.fill)),
             Padding(
               padding:
               EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                     child: Row(
                       children: [
                         IconButton(onPressed: (){
                           Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(
                                   builder: (context) =>
                                   const HomeScreen()));
                         }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)
                         ),
                         const Expanded(
                             child: Text("Notifications",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Colors.black87,
                                     fontSize: 16.0,
                                     fontWeight: FontWeight.bold))
                         ),
                         counter != 0 ? Stack(
                           children: <Widget>[
                             Icon(Icons.notifications, color: kPrimaryColor, size: 30,),
                             counter != 0 ? Positioned(
                               right: 2,
                               top: 2,
                               child: Container(
                                 padding: EdgeInsets.all(2),
                                 decoration: BoxDecoration(
                                   color: Colors.red,
                                   borderRadius: BorderRadius.circular(6),
                                 ),
                                 constraints: const BoxConstraints(
                                   minWidth: 12,
                                   minHeight: 12,
                                 ),
                                 child: Text(
                                   '$counter',
                                   style: const TextStyle(
                                     color: Colors.white,
                                     fontSize: 8,
                                   ),
                                   textAlign: TextAlign.center,
                                 ),
                               ),
                             ) : Container()
                           ],
                         ) : Container(width: 25),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left:8.0, right: 8.0),
                     child: Container(
                       height: MediaQuery.of(context).size.height * 0.80,
                       width: MediaQuery.of(context).size.width,
                       child: FutureBuilder(
                           future: _getNotificationslist(),
                           builder: (context, AsyncSnapshot snapshot){
                             List<NotificationData> list = snapshot.data;
                             if(!snapshot.hasData){
                               return Center(
                                 child: Container(
                                   height: 32.0,
                                   width: 32.0,
                                   child: CircularProgressIndicator(color: kPrimaryColor,),
                                 ),
                               );
                             }
                             else{
                               if(list.isEmpty || list == "" || list == null){
                                 return const Center(
                                   child: Text("No Notification!"),
                                 );
                               }
                               else{
                                 return ListView.separated(
                                     itemCount: list.length,
                                     separatorBuilder: (_, __) => Container(
                                       height: 1,
                                       color: Colors.white,
                                     ),
                                     itemBuilder: (_, index) {
                                       NotificationData m = list[index];
                                       try {
                                         return NotificationItem(m);
                                       } catch (e) {
                                         return const Center(child: Text('Some error occurred'),
                                         );
                                       }
                                     });
                               }
                             }

                           }
                       ),
                     ),
                   )
                 ],
               ),
             ),
             counter != 0 ? Positioned(
                 bottom: 0,
                 right: 10,
                 left: 10,
                 child: Container(
                   height: 60,
                   width: MediaQuery.of(context).size.width,
                   child: Card(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         const Expanded(
                             child: Padding(
                               padding: EdgeInsets.only(left: 8.0),
                               child: Text("Mark as read all notifications", style: TextStyle(color: Colors.black)),
                             )
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 8.0),
                           child: GestureDetector(
                             onTap: (){
                               _markednotifications();
                             },
                             child: Container(
                               height: 40,
                               width: 120,
                               decoration: BoxDecoration(
                                   color: kPrimaryColor,
                                   borderRadius: BorderRadius.circular(4.0)
                               ),
                               alignment: Alignment.center,
                               child: const Text("READ ALL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                             ),
                           ),
                         )
                       ],
                     ),
                   ),
                 )
             ) : Container()
           ],
         ),
      ),
    );
  }

  Future<List<NotificationData>> _getNotificationslist() async {

/*Map map={};


 map["notify_id"]="1130";
 map["emp_id"]= "1334";
 map["noti_message"]= "Title of notice";
 map["is_read"]= "1";
 map["noti_type"]= "3";
    map["trigger_time"]= "2022-03-29 17:21:38";*/

/*Map map1={};


map1["notify_id"]="1130";
map1["emp_id"]= "1334";
map1["noti_message"]= "Title of notice";
map1["is_read"]= "0";
map1["noti_type"]= "3";
map1["trigger_time"]= "2022-03-29 17:21:38";

List temp=[];
temp.add(map);
temp.add(map1);
return temp;*/

    List<NotificationData> unreadlist= [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "emp_id": prefs.getString('employee_id'),
      //"emp_id" : "451"

    };
    var response = await http.post(Uri.parse(BASE_URL + notificationslistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      unreadlist.clear();
      Iterable list = json.decode(response.body)['data'];
      List<NotificationData> notificationlist = list.map((m) => NotificationData.fromJson(m)).toList();
      for(int i=0; i<notificationlist.length; i++){
         if(notificationlist[i].isRead.toString() != "1"){
            unreadlist.add(notificationlist[i]);
         }
      }
      setState(() {
         counter = unreadlist.length;
      });
      return notificationlist;
    } else {
      return [];
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<List<NotificationData>> _markednotifications() async {
    setState(() {
       _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token": "ywrtaw46veltitizqhbs",
      "employee_id": prefs.getString('employee_id').toString(),
      //"emp_id" : "451"

    };
    var response = await http.post(Uri.parse(BASE_URL + notificationstatusUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _loading = false;
      });
      String msg = json.decode(response.body)['message'];
      Fluttertoast.showToast(msg: msg);
    } else {
      print(response.body);
      setState(() {
        _loading = false;
      });
    }
  }
}
