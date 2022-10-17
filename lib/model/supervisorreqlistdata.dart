class SupervisorreqlistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<LeaveReqData> data;

  SupervisorreqlistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  SupervisorreqlistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <LeaveReqData>[];
      json['data'].forEach((v) {
        data.add(new LeaveReqData.fromJson(v));
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

class LeaveReqData {
  String id;
  String branchId;
  String empId;
  String empHalfDayDate;
  String empHalfDayType;
  String leaveType;
  String empFulldayFromdate;
  String empFulldayTodate;
  String empReasonforleave;
  String leaveStatus;

  LeaveReqData(
      {
        this.id,
        this.branchId,
        this.empId,
        this.empHalfDayDate,
        this.empHalfDayType,
        this.leaveType,
        this.empFulldayFromdate,
        this.empFulldayTodate,
        this.empReasonforleave,
        this.leaveStatus
      });

  LeaveReqData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    empId = json['emp_id'];
    empHalfDayDate = json['emp_half_day_date'];
    empHalfDayType = json['emp_half_day_type'];
    leaveType = json['leave_type'];
    empFulldayFromdate = json['emp_fullday_fromdate'];
    empFulldayTodate = json['emp_fullday_todate'];
    empReasonforleave = json['emp_reasonforleave'];
    leaveStatus = json['leave_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['emp_id'] = this.empId;
    data['emp_half_day_date'] = this.empHalfDayDate;
    data['emp_half_day_type'] = this.empHalfDayType;
    data['leave_type'] = this.leaveType;
    data['emp_fullday_fromdate'] = this.empFulldayFromdate;
    data['emp_fullday_todate'] = this.empFulldayTodate;
    data['emp_reasonforleave'] = this.empReasonforleave;
    data['leave_status'] = this.leaveStatus;
    return data;
  }
}