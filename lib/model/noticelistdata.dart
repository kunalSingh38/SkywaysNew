class NoticelistData {
  bool success;
  String status;
  String message;
  Null error;
  String timestamp;
  List<NoticeData> data;

  NoticelistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  NoticelistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = new List<NoticeData>();
      json['data'].forEach((v) {
        data.add(new NoticeData.fromJson(v));
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

class NoticeData {
  String title;
  String desc;
  String addedDate;

  NoticeData({this.title, this.desc, this.addedDate});

  NoticeData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    addedDate = json['added_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['added_date'] = this.addedDate;
    return data;
  }
}