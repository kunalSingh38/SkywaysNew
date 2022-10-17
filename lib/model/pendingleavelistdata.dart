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

  PedingleavelistData.fromJson(Map<String, dynamic> json){
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = null;
    timestamp = json['timestamp'];
    data = List.from(json['data']).map((e)=>PendingData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['status'] = status;
    _data['message'] = message;
    _data['error'] = error;
    _data['timestamp'] = timestamp;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class PendingData {
  PendingData({
    this.id,
    this.empId,
    this.branchId,
    this.empHalfDayDate,
    this.empHalfDayType,
    this.empFullDay,
    this.empFulldayFromdate,
    this.empFulldayTodate,
    this.empReasonforleave,
    this.leaveStatus,
  });


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

  PendingData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    empId = json['emp_id'];
    branchId = json['branch_id'];
    empHalfDayDate = null;
    empHalfDayType = json['emp_half_day_type'];
    empFullDay = json['emp_full_day'];
    empFulldayFromdate = json['emp_fullday_fromdate'];
    empFulldayTodate = json['emp_fullday_todate'];
    empReasonforleave = json['emp_reasonforleave'];
    leaveStatus = json['leave_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['emp_id'] = empId;
    _data['branch_id'] = branchId;
    _data['emp_half_day_date'] = empHalfDayDate;
    _data['emp_half_day_type'] = empHalfDayType;
    _data['emp_full_day'] = empFullDay;
    _data['emp_fullday_fromdate'] = empFulldayFromdate;
    _data['emp_fullday_todate'] = empFulldayTodate;
    _data['emp_reasonforleave'] = empReasonforleave;
    _data['leave_status'] = leaveStatus;
    return _data;
  }
}