class PedingleavelistData {
  PedingleavelistData({
    this.success,
    this.status,
    this.message,
    this.error,
    this.timestamp,
    this.data,
  });

  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<PendingData> data;

  PedingleavelistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = null;
    timestamp = json['timestamp'];
    data = List.from(json['data']).map((e) => PendingData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['status'] = status;
    _data['message'] = message;
    _data['error'] = error;
    _data['timestamp'] = timestamp;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PendingData {
  String id;
  String empId;
  String branchId;
  Null empHalfDayDate;
  String empHalfDayType;
  String empFullDay;
  String empFulldayFromdate;
  String empFulldayTodate;
  String empReasonforleave;
  String leaveStatus;
  String empName;
  String empOfficialId;
  String clBal;
  String elBal;
  int leaveBalance;

  PendingData(
      {this.id,
      this.empId,
      this.branchId,
      this.empHalfDayDate,
      this.empHalfDayType,
      this.empFullDay,
      this.empFulldayFromdate,
      this.empFulldayTodate,
      this.empReasonforleave,
      this.leaveStatus,
      this.empName,
      this.empOfficialId,
      this.clBal,
      this.elBal,
      this.leaveBalance});

  PendingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['emp_id'];
    branchId = json['branch_id'];
    empHalfDayDate = json['emp_half_day_date'];
    empHalfDayType = json['emp_half_day_type'];
    empFullDay = json['emp_full_day'];
    empFulldayFromdate = json['emp_fullday_fromdate'];
    empFulldayTodate = json['emp_fullday_todate'];
    empReasonforleave = json['emp_reasonforleave'];
    leaveStatus = json['leave_status'];
    empName = json['empName'];
    empOfficialId = json['emp_official_id'];
    clBal = json['cl_bal'];
    elBal = json['el_bal'];
    leaveBalance = json['leaveBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_id'] = this.empId;
    data['branch_id'] = this.branchId;
    data['emp_half_day_date'] = this.empHalfDayDate;
    data['emp_half_day_type'] = this.empHalfDayType;
    data['emp_full_day'] = this.empFullDay;
    data['emp_fullday_fromdate'] = this.empFulldayFromdate;
    data['emp_fullday_todate'] = this.empFulldayTodate;
    data['emp_reasonforleave'] = this.empReasonforleave;
    data['leave_status'] = this.leaveStatus;
    data['empName'] = this.empName;
    data['emp_official_id'] = this.empOfficialId;
    data['cl_bal'] = this.clBal;
    data['el_bal'] = this.elBal;
    data['leaveBalance'] = this.leaveBalance;
    return data;
  }
}
