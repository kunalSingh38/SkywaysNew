import 'package:flutter/material.dart';

const String ALERT_DIALOG_TITLE = "Alert";
const String BASE_URL = "http://api.skyways-group.com/api/web/internal/";

const String loginUrl = "logins/1";
const String branchlistUrl = "branchlists/1";
const String employeelistUrl = "employeelists/1";
const String companylistUrl = "companylists/1";
const String departmentlistUrl = "departmentlists/1";
const String destinationlistUrl = "designationlists/1";
const String leaveformUrl = "applyleaves/1";
const String leavelistUrl = "leavelistings/1";
const String balanceleaveUrl = "balanceleaves/1";
const String pendingleavelistUrl = "pendingleavelists/1";
const String leaveStatuschangeUrl = "leavestatuschanges/1";
const String salarysliplistUrl = "salarysliplists/1";
const String birthdaylistUrl = "birthdaylists/1";
const String anniversarylistUrl = "anniversarieslists/1";
const String noticelistUrl = "noticeslists/1";
const String annoucenoticelisturl = "noticeannouncementlists/1";
const String selfleavecancelUrl = "selfcancelleaves/1";
const String reimbursementlistUrl = "reimburshmentrequestlists/1";
const String applyreimbursementUrl = "reimburshmentrequests/1";
const String expensetypelistUrl = "expensetypelists/1";
const String leaverequestlistUrl = "leavesupervisors/1";
const String notificationslistUrl = "notificationlists/1";
const String notificationstatusUrl = "markreadallnotifications/1";
const String policylistingUrl = "policylistings/1";
const String policyacceptanceUrl = "policyaccepts/1";
//const String announcenoticelistUrl = "noticeslists/1";

final String path = 'assets/images/';

final List<Draw> drawerItems = [
  Draw(title: 'Home', icon: path + 'home.png'),
  Draw(title: 'Scanned Tickets', icon: path + 'clipboard.png'),
  Draw(title: 'Data Analysis', icon: path + 'pie.png'),
  Draw(title: 'Tickets', icon: path + 'side_tickets.png'),
];

class Draw {
  final String title;
  final String icon;
  Draw({this.title, this.icon});
}
