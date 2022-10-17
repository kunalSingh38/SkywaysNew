class BalanceleaveData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<BalancelvData> data;

  BalanceleaveData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  BalanceleaveData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = new List<BalancelvData>();
      json['data'].forEach((v) {
        data.add(new BalancelvData.fromJson(v));
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

class BalancelvData {
  String id;
  String cl;
  String el;
  String supervisorEmpId;
  String supervisorName;

  BalancelvData({this.id, this.cl, this.el, this.supervisorEmpId, this.supervisorName});

  BalancelvData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cl = json['cl'];
    el = json['el'];
    supervisorEmpId = json['supervisor_emp_id'];
    supervisorName = json['supervisor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cl'] = this.cl;
    data['el'] = this.el;
    data['supervisor_emp_id'] = this.supervisorEmpId;
    data['supervisor_name'] = this.supervisorName;
    return data;
  }
}