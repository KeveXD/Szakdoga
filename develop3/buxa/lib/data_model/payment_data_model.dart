enum PaymentType { Income, Expense }

class PaymentDataModel {
  int? id;
  DateTime date;
  String title;
  String comment;
  PaymentType type;
  bool isDebt;
  int pocketId;
  double amount;
  String currency;

  PaymentDataModel({
    this.id,
    required this.date,
    required this.title,
    required this.comment,
    required this.type,
    required this.isDebt,
    required this.pocketId,
    required this.amount,
    required this.currency,
  });

  PaymentDataModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = DateTime.parse(map['date']),
        title = map['title'],
        comment = map['comment'],
        type =
            map['type'] == 'income' ? PaymentType.Income : PaymentType.Expense,
        isDebt = map['isDebt'] == 1,
        pocketId = map['pocketId'],
        amount = map['amount'].toDouble(),
        currency = map['currency'];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'comment': comment,
      'type': type == PaymentType.Income ? 'income' : 'expense',
      'isDebt': isDebt ? 1 : 0,
      'pocketId': pocketId,
      'amount': amount,
      'currency': currency,
    };
  }
}
