class BranchListData {
  bool success;
  String status;
  String message;
  Null error;
  String timestamp;
  List<BranchData> data;

  BranchListData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  BranchListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <BranchData>[];
      json['data'].forEach((v) {
        data.add(new BranchData.fromJson(v));
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

class BranchData {
  String id;
  String branchName;
  String branchNo;

  BranchData({this.id, this.branchName, this.branchNo});

  BranchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
    branchNo = json['branch_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_name'] = this.branchName;
    data['branch_no'] = this.branchNo;
    return data;
  }
}