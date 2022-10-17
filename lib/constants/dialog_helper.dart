import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyways_group/constants/exit_confirmation_dialog.dart';
import 'package:skyways_group/constants/logout_confirmation_dialog.dart';
import 'package:skyways_group/constants/selfcancelleave_dialog.dart';


class DialogHelper {

  static exit(context) => showDialog(context: context, builder: (context) => ExitConfirmationDialog());
  static logout(context) => showDialog(context: context, builder: (context) => LogoutConfirmationDialog());
  static selfCancelLeave(String id, context) => showDialog(context: context, builder: (context) => SelfCancelLeaveDialog(id: id));

}