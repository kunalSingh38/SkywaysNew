import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/screens/birthday_and_anniversary_screen.dart';
import 'package:skyways_group/screens/employee_directory_screen.dart';
import 'package:skyways_group/screens/home_sceen.dart';
import 'package:skyways_group/screens/leave_application_screen.dart';
import 'package:skyways_group/screens/leave_status_screen.dart';
import 'package:skyways_group/screens/notice_board_detail_screen.dart';
import 'package:skyways_group/screens/notice_board_screen.dart';
import 'package:skyways_group/screens/notifications_screen.dart';
import 'package:skyways_group/screens/profile_screen.dart';
import 'package:skyways_group/screens/salary_slips_screen.dart';
import 'package:skyways_group/screens/splash_screen.dart';
import 'package:skyways_group/screens/workanniversary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skyways Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/leavestatusscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => LeaveStatusScreen());
        }
        if (settings.name == '/empdirectoryscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => EmployeeDirectoryScreen());
        }
        if (settings.name == '/leaveapplyscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => LeaveApplicationScreen());
        }
        if (settings.name == '/birthdayscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => BirthdayAnniversaryScreen());
        }
        if (settings.name == '/anniversaryscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => WorkAnniversaryScreen());
        }
        if (settings.name == '/profilescreen') {
          return PageRouteBuilder(pageBuilder: (_, __, ___) => ProfileScreen());
        }
        if (settings.name == '/homescreen') {
          return PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen());
        }
        if (settings.name == '/salaryslipscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => SalarySlipScreen());
        }
        if (settings.name == '/noticeboardscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => NoticeBoardScreen());
        }
        if (settings.name == '/notificationscreen') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => NotificationsScreen());
        }
        if (settings.name == '/noticeboarddetailscreen') {
          var obj = settings.arguments;
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  NoticeBoardDetailScreen(argument: obj));
        }

        return null;
      },
    );
  }
}
