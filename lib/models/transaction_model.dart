class TransactionModel {
  int? id;
  int? userId;
  int? bookId;
  String? transactionId;
  String? duration;
  String? status;
  int? fine;
  DateTime? returnDate;
  String? note;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  TransactionModel(
      {this.id,
      this.userId,
      this.bookId,
      this.transactionId,
      this.duration,
      this.status,
      this.fine,
      this.returnDate,
      this.note,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    transactionId = json['transaction_id'];
    duration = json['duration'];
    status = json['status'];
    fine = json['fine'];
    returnDate = DateTime.parse(json['return_date']).toLocal();
    note = json['note'];
    deletedAt = DateTime.parse(json['deleted_at']).toLocal();
    createdAt = DateTime.parse(json['created_at']).toLocal();
    updatedAt = DateTime.parse(json['updated_at']).toLocal();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['book_id'] = bookId;
    data['transaction_id'] = transactionId;
    data['duration'] = duration;
    data['status'] = status;
    data['fine'] = fine;
    data['return_date'] = returnDate?.toIso8601String();
    data['note'] = note;
    data['deleted_at'] = deletedAt?.toIso8601String();
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
