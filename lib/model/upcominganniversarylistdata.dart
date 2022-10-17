class UpcomingAnniversarylistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  Data data;

  UpcomingAnniversarylistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  UpcomingAnniversarylistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    data['timestamp'] = this.timestamp;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Today> today;
  List<Upcoming> upcoming;

  Data({this.today, this.upcoming});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['today'] != null) {
      today = new List<Today>();
      json['today'].forEach((v) {
        today.add(new Today.fromJson(v));
      });
    }
    if (json['upcoming'] != null) {
      upcoming = new List<Upcoming>();
      json['upcoming'].forEach((v) {
        upcoming.add(new Upcoming.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today.map((v) => v.toJson()).toList();
    }
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Today {
  String empId;
  String empName;
  String empJoinDate;
  String empMail;
  String empMobile;
  String empImage;
  String desigId;
  String desigName;

  Today(
      {this.empId,
        this.empName,
        this.empJoinDate,
        this.empMail,
        this.empMobile,
        this.empImage,
        this.desigId,
        this.desigName});

  Today.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    empJoinDate = json['emp_join_date'];
    empMail = json['emp_mail'];
    empMobile = json['emp_mobile'];
    empImage = json['emp_image'];
    desigId = json['desig_id'];
    desigName = json['desigName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_join_date'] = this.empJoinDate;
    data['emp_mail'] = this.empMail;
    data['emp_mobile'] = this.empMobile;
    data['emp_image'] = this.empImage;
    data['desig_id'] = this.desigId;
    data['desigName'] = this.desigName;
    return data;
  }
}

class Upcoming {
  String empId;
  String empName;
  String empJoinDate;
  String empMail;
  String empMobile;
  String empImage;
  String desigId;
  String desigName;
  String branchName;

  Upcoming(
      {this.empId,
        this.empName,
        this.empJoinDate,
        this.empMail,
        this.empMobile,
        this.empImage,
        this.desigId,
        this.desigName,
        this.branchName,
      });

  Upcoming.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    empJoinDate = json['emp_join_date'];
    empMail = json['emp_mail'];
    empMobile = json['emp_mobile'];
    empImage = json['emp_image'];
    desigId = json['desig_id'];
    desigName = json['desigName'];
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_join_date'] = this.empJoinDate;
    data['emp_mail'] = this.empMail;
    data['emp_mobile'] = this.empMobile;
    data['emp_image'] = this.empImage;
    data['desig_id'] = this.desigId;
    data['desigName'] = this.desigName;
    data['branchName'] = this.branchName;
    return data;
  }
}