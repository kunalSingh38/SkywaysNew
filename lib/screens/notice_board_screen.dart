import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/api/api_service.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/model/noticelistdata.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({Key key}) : super(key: key);

  @override
  _NoticeBoardScreenState createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {

  List<NoticeData> _noticeslist = List<NoticeData>();
  List<NoticeData> _searchResult = List<NoticeData>();

  @override
  void initState() {
    _noticelist().then((value) {
      setState(() {
        _noticeslist.addAll(value);
        _searchResult = _noticeslist;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/svg/mask_group_other.svg', fit: BoxFit.fill,)
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                      Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.22),
                          child: Text("Notice Board", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/svg/search.svg'),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Search Notification',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (text){
                                      text = text.toLowerCase();
                                      setState(() {
                                          _searchResult = _noticeslist.where((post) {
                                          var title = post.title.toLowerCase();
                                          return title.contains(text);
                                        }).toList();
                                      });
                                    },
                                    cursorColor: kPrimaryColor,
                                  )
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container (
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Recent Notifications", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, top: 8.0, right: 20.0),
                              child: Container(
                                 height: MediaQuery.of(context).size.height * 0.64,
                                 width: double.infinity,
                                 child: FutureBuilder(
                                 future: _noticelist(),
                                 builder: (context, AsyncSnapshot snapshot) {
                                    if(!snapshot.hasData){
                                      return Center(
                                          child: Container(height: 24.0, width: 24.0, child: const CircularProgressIndicator(color: kPrimaryColor)));
                                    }
                                    else{
                                      return ListView.separated(
                                          shrinkWrap: true,
                                          primary: false,
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) {
                                            return Divider(color: Colors.grey, height: 0.0);
                                          },
                                          itemCount: _searchResult.length,
                                          scrollDirection: Axis.vertical,
                                          physics: AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,int index){
                                            return _noticelistItem(_searchResult[index].title, _searchResult[index].desc, _searchResult[index].addedDate);
                                          }
                                      );
                                    }
                                 }
                                 )
                              )
                            )
                          ],
                        ),
                      ),
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

  _noticelist() async {
    List<NoticeData> noticelist = [];
    noticelist.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "api_access_token" : "ywrtaw46veltitizqhbs",
      "emp_id" :  prefs.getString('employee_id')
    };
    var response = await http.post(
      Uri.parse(BASE_URL+noticelistUrl),
      body: body,
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      noticelist = list.map((m) => NoticeData.fromJson(m)).toList();
      return noticelist;
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget _noticelistItem(String title, String desc, String date){
     return InkWell(
       onTap: (){
         Navigator.pushNamed(
           context,
           '/noticeboarddetailscreen',
           arguments: <String, String>{
             'title' : title.toString(),
             'desc' : desc.toString(),
             'date' : date.toString()
           },
         );
       },
       child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0),
                        Text(date, style: TextStyle(color: Colors.black, fontSize: 12.0)),
                        SizedBox(height: 4.0),
                        Text(desc, style: TextStyle(color: Colors.black, fontSize: 14.0))
                      ],
                    )
                ),
               SizedBox(width: 15.0),
               Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey.shade300)
             ],
          ),
       ),
     );
  }

  Widget _listItem(BuildContext context, String title, String image){
    return Padding(
      padding: EdgeInsets.only(left: 0.0, top: 5.0),
      child: GestureDetector(
        onTap: (){

        },
        child: Card(
          elevation: 1.0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width/2 - 20,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Image.asset(image),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyNotification() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              margin: const EdgeInsets.only(bottom: 20),
              child: Image.asset("assets/images/notify_bell.png"),
            ),
            const Text(
              "No Notifications Yet!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 80),
              child: Text("Check this section for updates, exclusive offers and general notifications.", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
