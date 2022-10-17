class DepartmentListData {
  bool success;
  String status;
  String message;
  Null error;
  String timestamp;
  List<DepartmentData> data;

  DepartmentListData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  DepartmentListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <DepartmentData>[];
      json['data'].forEach((v) {
        data.add(new DepartmentData.fromJson(v));
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

class DepartmentData {
  String id;
  String deptName;

  DepartmentData({this.id, this.deptName});

  DepartmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deptName = json['dept_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dept_name'] = this.deptName;
    return data;
  }
}