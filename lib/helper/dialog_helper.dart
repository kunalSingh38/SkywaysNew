import 'package:flutter/material.dart';
import 'package:skyways_group/helper/branch_list_dialog.dart';
import 'package:skyways_group/helper/view_image_dialog.dart';


class DialogHelper {

  static branchdialog(String image, String desc, context) => showDialog(context: context, builder: (context) => BranchlistDialog());
  static viewimagedialog(String image, context) => showDialog(context: context, builder: (context) => ViewImageDialog(image: image));

}