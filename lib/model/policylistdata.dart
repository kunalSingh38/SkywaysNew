class PolicylistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<PolicyData> data;

  PolicylistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  PolicylistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = new List<PolicyData>();
      json['data'].forEach((v) {
        data.add(new PolicyData.fromJson(v));
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

class PolicyData {
  String id;
  String title;
  String desc;
  String policyDoc;

  PolicyData({this.id, this.title, this.desc, this.policyDoc});

  PolicyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    policyDoc = json['policy_doc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['policy_doc'] = this.policyDoc;
    return data;
  }
}