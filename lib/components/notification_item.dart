import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyways_group/constants/constant.dart';
import 'package:skyways_group/model/notificationlistdata.dart';

class NotificationItem extends StatefulWidget {

  final NotificationData notification;

  const NotificationItem(this.notification);
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        color: widget.notification.isRead == "0" ? kPrimaryColor.withOpacity(0.5) : Colors.white70,
        child: Column(
          children: [
            ListTile(
              onTap: () {

              },
              dense: true,
              title: Text(
                widget.notification.notiMessage,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              trailing: Text("${DateFormat().add_yMd().format(DateTime.parse("${widget.notification.triggerTime}"))},"" ${DateFormat().add_jm().format(DateTime.parse("${widget.notification.triggerTime}"))}",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            /*Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: (){},
                child:  widget.notification.isRead == "0" ? Text("Unread", style: TextStyle(color: Colors.grey.shade700)) : Text("Read", style: TextStyle(color: Colors.grey.shade400)),
                textColor: Colors.white,
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
