class LeaveStatusListData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<LeaveStatusData> data;

  LeaveStatusListData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  LeaveStatusListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <LeaveStatusData>[];
      json['data'].forEach((v) {
        data.add(new LeaveStatusData.fromJson(v));
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

class LeaveStatusData {
  String id;
  String empId;
  String branchId;
  String empHalfDayDate;
  String empHalfDayType;
  String empFullDay;
  String empFulldayFromdate;
  String empFulldayTodate;
  String empReasonforleave;
  String leaveStatus;

  LeaveStatusData(
      {this.id,
        this.empId,
        this.branchId,
        this.empHalfDayDate,
        this.empHalfDayType,
        this.empFullDay,
        this.empFulldayFromdate,
        this.empFulldayTodate,
        this.empReasonforleave,
        this.leaveStatus});

  LeaveStatusData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}