class SalarySlipsListData {
  bool success;
  String status;
  String message;
  Null error;
  String timestamp;
  List<SalarySlipData> data;

  SalarySlipsListData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  SalarySlipsListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <SalarySlipData>[];
      json['data'].forEach((v) {
        data.add(new SalarySlipData.fromJson(v));
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

class SalarySlipData {
  String id;
  String branchId;
  String empId;
  String company;
  String month;
  String year;
  String filePath;

  SalarySlipData(
      {this.id,
        this.branchId,
        this.empId,
        this.company,
        this.month,
        this.year,
        this.filePath});

  SalarySlipData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    empId = json['emp_id'];
    company = json['company'];
    month = json['month'];
    year = json['Year'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['emp_id'] = this.empId;
    data['company'] = this.company;
    data['month'] = this.month;
    data['Year'] = this.year;
    data['file_path'] = this.filePath;
    return data;
  }
}