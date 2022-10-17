import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/enums.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: bottomBarColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)
          ),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(1, 1)
            )
          ]
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.home,
                    color: MenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                        Navigator.pop(context);
                       //Navigator.pushNamed(context, '/homescreen');
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  }),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg'),
                onPressed: () {
                  Navigator.pushNamed(context, '/empdirectoryscreen');
                },
              ),
              Container(
                height: 32,
                child: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white, size: 24),
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, '/leaveapplyscreen');
                  },
                ),
              ),
              IconButton(
                  icon: Icon(Icons.notification_add,
                    color: MenuState.notification == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notificationscreen');
                  }

              ),
              IconButton(
                  icon: Icon(Icons.person,
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                        //Navigator.pop(context);
                       Navigator.pushNamed(context, '/profilescreen');
                       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  }

              ),
            ],
          )
      ),
    );
  }
}