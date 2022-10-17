class EmployeelistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<Data> data;

  EmployeelistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  EmployeelistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String id;
  String companyId;
  String branchId;
  String empId;
  String empName;
  String empFather;
  String empDob;
  String empJoinDate;
  String deptId;
  String desigId;
  String gender;
  String aadharNo;
  String empPan;
  String empAdd1;
  String empAdd2;
  String empAdd3;
  String empAdd4;
  String empMobile;
  String empMail;
  String empMailPersonal;
  String empNeighPh;
  String empImage;
  String officeTime;
  String maritalstatus;
  String bloodgroup;
  String basicSalary;
  String da;
  String hra;
  String pfNo;
  String pfPercent;
  String esicNo;
  String esicPercent;
  String conveyance;
  String phoneAllow;
  String otherAllow;
  String empStatus;
  String permanentAddress;
  String emergencyNo;
  String reportingTo;
  String compName;
  String branchName;
  String deptName;
  String desigName;
  String genderVal;
  String maritalStatus;
  String bloodGroup;
  String employeeStatus;
  String empDobDatemonth;
  String empDobMonthyear;
  String empJoinDateDdmmyy;
  String reportingManager;

  Data(
      {this.id,
        this.companyId,
        this.branchId,
        this.empId,
        this.empName,
        this.empFather,
        this.empDob,
        this.empJoinDate,
        this.deptId,
        this.desigId,
        this.gender,
        this.aadharNo,
        this.empPan,
        this.empAdd1,
        this.empAdd2,
        this.empAdd3,
        this.empAdd4,
        this.empMobile,
        this.empMail,
        this.empMailPersonal,
        this.empNeighPh,
        this.empImage,
        this.officeTime,
        this.maritalstatus,
        this.bloodgroup,
        this.basicSalary,
        this.da,
        this.hra,
        this.pfNo,
        this.pfPercent,
        this.esicNo,
        this.esicPercent,
        this.conveyance,
        this.phoneAllow,
        this.otherAllow,
        this.empStatus,
        this.permanentAddress,
        this.emergencyNo,
        this.reportingTo,
        this.compName,
        this.branchName,
        this.deptName,
        this.desigName,
        this.genderVal,
        this.maritalStatus,
        this.bloodGroup,
        this.employeeStatus,
        this.empDobDatemonth,
        this.empDobMonthyear,
        this.empJoinDateDdmmyy,
        this.reportingManager});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    branchId = json['branch_id'];
    empId = json['emp_id'];
    empName = json['emp_name'];
    empFather = json['emp_father'];
    empDob = json['emp_dob'];
    empJoinDate = json['emp_join_date'];
    deptId = json['dept_id'];
    desigId = json['desig_id'];
    gender = json['gender'];
    aadharNo = json['aadhar_no'];
    empPan = json['emp_pan'];
    empAdd1 = json['emp_add_1'];
    empAdd2 = json['emp_add_2'];
    empAdd3 = json['emp_add_3'];
    empAdd4 = json['emp_add_4'];
    empMobile = json['emp_mobile'];
    empMail = json['emp_mail'];
    empMailPersonal = json['emp_mail_personal'];
    empNeighPh = json['emp_neigh_ph'];
    empImage = json['emp_image'];
    officeTime = json['office_time'];
    maritalstatus = json['marital_status'];
    bloodgroup = json['blood_group'];
    basicSalary = json['basic_salary'];
    da = json['da'];
    hra = json['hra'];
    pfNo = json['pf_no'];
    pfPercent = json['pf_percent'];
    esicNo = json['esic_no'];
    esicPercent = json['esic_percent'];
    conveyance = json['conveyance'];
    phoneAllow = json['phone_allow'];
    otherAllow = json['other_allow'];
    empStatus = json['emp_status'];
    permanentAddress = json['permanent_address'];
    emergencyNo = json['emergency_no'];
    reportingTo = json['reporting_to'];
    compName = json['compName'];
    branchName = json['branchName'];
    deptName = json['deptName'];
    desigName = json['desigName'].toString();
    genderVal = json['genderVal'];
    maritalStatus = json['maritalStatus'];
    bloodGroup = json['bloodGroup'];
    employeeStatus = json['employeeStatus'];
    empDobDatemonth = json['emp_dob_datemonth'];
    empDobMonthyear = json['emp_dob_monthyear'];
    empJoinDateDdmmyy = json['emp_join_date_ddmmyy'];
    reportingManager = json['reporting_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['branch_id'] = this.branchId;
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['emp_father'] = this.empFather;
    data['emp_dob'] = this.empDob;
    data['emp_join_date'] = this.empJoinDate;
    data['dept_id'] = this.deptId;
    data['desig_id'] = this.desigId;
    data['gender'] = this.gender;
    data['aadhar_no'] = this.aadharNo;
    data['emp_pan'] = this.empPan;
    data['emp_add_1'] = this.empAdd1;
    data['emp_add_2'] = this.empAdd2;
    data['emp_add_3'] = this.empAdd3;
    data['emp_add_4'] = this.empAdd4;
    data['emp_mobile'] = this.empMobile;
    data['emp_mail'] = this.empMail;
    data['emp_mail_personal'] = this.empMailPersonal;
    data['emp_neigh_ph'] = this.empNeighPh;
    data['emp_image'] = this.empImage;
    data['office_time'] = this.officeTime;
    data['marital_status'] = this.maritalstatus;
    data['blood_group'] = this.bloodgroup;
    data['basic_salary'] = this.basicSalary;
    data['da'] = this.da;
    data['hra'] = this.hra;
    data['pf_no'] = this.pfNo;
    data['pf_percent'] = this.pfPercent;
    data['esic_no'] = this.esicNo;
    data['esic_percent'] = this.esicPercent;
    data['conveyance'] = this.conveyance;
    data['phone_allow'] = this.phoneAllow;
    data['other_allow'] = this.otherAllow;
    data['emp_status'] = this.empStatus;
    data['permanent_address'] = this.permanentAddress;
    data['emergency_no'] = this.emergencyNo;
    data['reporting_to'] = this.reportingTo;
    data['compName'] = this.compName;
    data['branchName'] = this.branchName;
    data['deptName'] = this.deptName;
    data['desigName'] = this.desigName;
    data['genderVal'] = this.genderVal;
    data['maritalStatus'] = this.maritalStatus;
    data['bloodGroup'] = this.bloodGroup;
    data['employeeStatus'] = this.employeeStatus;
    data['emp_dob_datemonth'] = this.empDobDatemonth;
    data['emp_dob_monthyear'] = this.empDobMonthyear;
    data['emp_join_date_ddmmyy'] = this.empJoinDateDdmmyy;
    data['reporting_manager'] = this.reportingManager;
    return data;
  }
}