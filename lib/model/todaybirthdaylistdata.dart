class TodayBirthdaylistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  Data data;

  TodayBirthdaylistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  TodayBirthdaylistData.fromJson(Map<String, dynamic> json) {
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
  List<CustomDate> customDate;

  Data({this.customDate});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['custom_date'] != null) {
      customDate = new List<CustomDate>();
      json['custom_date'].forEach((v) {
        customDate.add(new CustomDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customDate != null) {
      data['custom_date'] = this.customDate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomDate{
  String empId;
  String empName;
  String empDob;
  String empMail;
  String empMobile;
  String empImage;
  String desigId;
  String desigName;
  String branchname;

  CustomDate(
      {
        this.empId,
        this.empName,
        this.empDob,
        this.empMail,
        this.empMobile,
        this.empImage,
        this.desigId,
        this.desigName,
        this.branchname
      });

  CustomDate.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    empDob = json['emp_dob'];
    empMail = json['emp_mail'];
    empMobile = json['emp_mobile'];
    empImage = json['emp_image'];
    desigId = json['desig_id'];
    desigName = json['desigName'];
    branchname = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_dob'] = this.empDob;
    data['emp_mail'] = this.empMail;
    data['emp_mobile'] = this.empMobile;
    data['emp_image'] = this.empImage;
    data['desig_id'] = this.desigId;
    data['desigName'] = this.desigName;
    data['branchName'] = this.branchname;
    return data;
  }
}