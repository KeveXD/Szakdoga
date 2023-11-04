class DebtDataModel {
  int? id;
  int? debtorPersonId;
  int? personToId;
  int? amount;
  bool? isPaid;
  String? description;

  DebtDataModel({
    this.id,
    this.debtorPersonId,
    this.personToId,
    this.amount,
    this.isPaid,
    this.description,
  });

  DebtDataModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    debtorPersonId = map['debtorPersonId'];
    personToId = map['personToId'];
    amount = map['amount'];
    isPaid = map['isPaid'] == 1;
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'debtorPersonId': debtorPersonId,
      'personToId': personToId,
      'amount': amount,
      'isPaid': isPaid == true ? 1 : 0,
      'description': description,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
