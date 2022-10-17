import 'package:flutter/material.dart';
import 'package:skyways_group/components/coustom_bottom_nav_bar.dart';
import 'package:skyways_group/enums.dart';

class VisitorInviteScreen extends StatefulWidget {
  const VisitorInviteScreen({Key key}) : super(key: key);

  @override
  _VisitorInviteScreenState createState() => _VisitorInviteScreenState();
}

class _VisitorInviteScreenState extends State<VisitorInviteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: Image.asset('assets/images/login_bg.png')
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Image.asset('assets/icons/back.png')
                        ),
                      ),
                      const Expanded(child: Text("Create Invites", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }


}
