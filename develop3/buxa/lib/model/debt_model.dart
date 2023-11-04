import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DebtModel {
  final DebtRepository _repository = DebtRepository();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<DebtDataModel>> getDebtList() async {
    if (!kIsWeb) {
      // Csak akkor kérjük le az adatokat az adatbázisból, ha nem webes környezetben fut a program.
      return _repository.getDebtList();
    }
    return <DebtDataModel>[];
  }

  Future<void> addDebt(DebtDataModel debt) async {
    await _repository.insertDebt(debt);
  }

  Future<void> updateDebt(DebtDataModel debt) async {
    await _repository.updateDebt(debt);
  }

  Future<void> deleteDebt(DebtDataModel debt) async {
    await _repository.deleteDebt(debt);
  }
}
