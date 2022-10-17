class ExpenselistData {
  bool success;
  String status;
  String message;
  Null error;
  String timestamp;
  ExpenseData data;

  ExpenselistData(
      {
        this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data
      });

  ExpenselistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    data = json['data'] != null ? new ExpenseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    data['timestamp'] = this.timestamp;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ExpenseData {
  String s1;
  String s2;
  String s3;
  String s4;

  ExpenseData({this.s1, this.s2, this.s3, this.s4});

  ExpenseData.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    return data;
  }
}