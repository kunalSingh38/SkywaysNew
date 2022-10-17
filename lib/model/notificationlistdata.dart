class Notificationlistdata {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<NotificationData> data;

  Notificationlistdata(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  Notificationlistdata.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    data['timestamp'] = this.timestamp;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String notifyId;
  String empId;
  String notiMessage;
  String isRead;
  String notiType;
  String triggerTime;

  NotificationData(
      {
        this.notifyId,
        this.empId,
        this.notiMessage,
        this.isRead,
        this.notiType,
        this.triggerTime
      });

  NotificationData.fromJson(Map<String, dynamic> json) {
    notifyId = json['notify_id'];
    empId = json['emp_id'];
    notiMessage = json['noti_message'];
    isRead = json['is_read'];
    notiType = json['noti_type'];
    triggerTime = json['trigger_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_id'] = this.notifyId;
    data['emp_id'] = this.empId;
    data['noti_message'] = this.notiMessage;
    data['is_read'] = this.isRead;
    data['noti_type'] = this.notiType;
    data['trigger_time'] = this.triggerTime;
    return data;
  }
}