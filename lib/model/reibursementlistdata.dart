class ReimbursementlistData {
  bool success;
  String status;
  String message;
  String error;
  String timestamp;
  List<ReimbursementData> data;

  ReimbursementlistData(
      {this.success,
        this.status,
        this.message,
        this.error,
        this.timestamp,
        this.data});

  ReimbursementlistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = new List<ReimbursementData>();
      json['data'].forEach((v) {
        data.add(new ReimbursementData.fromJson(v));
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

class ReimbursementData {
  String id;
  String compId;
  String branchId;
  String requestDate;
  String typeOfExpense;
  String requestBy;
  String othersText;
  String expenseRemarks;
  String expenseAmt;
  String docProof;
  String status;
  String approveRemarks;
  String approvePaymentProof;

  ReimbursementData(
      {this.id,
        this.compId,
        this.branchId,
        this.requestDate,
        this.typeOfExpense,
        this.requestBy,
        this.othersText,
        this.expenseRemarks,
        this.expenseAmt,
        this.docProof,
        this.status,
        this.approveRemarks,
        this.approvePaymentProof});

  ReimbursementData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    compId = json['comp_id'];
    branchId = json['branch_id'];
    requestDate = json['request_date'];
    typeOfExpense = json['type_of_expense'];
    requestBy = json['request_by'];
    othersText = json['others_text'];
    expenseRemarks = json['expense_remarks'];
    expenseAmt = json['expense_amt'];
    docProof = json['doc_proof'];
    status = json['status'];
    approveRemarks = json['approve_remarks'].toString();
    approvePaymentProof = json['approve_payment_proof'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comp_id'] = this.compId;
    data['branch_id'] = this.branchId;
    data['request_date'] = this.requestDate;
    data['type_of_expense'] = this.typeOfExpense;
    data['request_by'] = this.requestBy;
    data['others_text'] = this.othersText;
    data['expense_remarks'] = this.expenseRemarks;
    data['expense_amt'] = this.expenseAmt;
    data['doc_proof'] = this.docProof;
    data['status'] = this.status;
    data['approve_remarks'] = this.approveRemarks;
    data['approve_payment_proof'] = this.approvePaymentProof;
    return data;
  }
}