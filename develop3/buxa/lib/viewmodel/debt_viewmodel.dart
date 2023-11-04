import 'package:flutter/material.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/model/debt_model.dart';

class DebtViewModel {
  final DebtModel _model = DebtModel();

  String? getUserEmail() {
    return _model.getUserEmail();
  }

  Future<List<DebtDataModel>> getDebtList() async {
    return _model.getDebtList();
  }

  Future<void> addDebt(DebtDataModel debt) async {
    await _model.addDebt(debt);
  }

  Future<void> updateDebt(DebtDataModel debt) async {
    await _model.updateDebt(debt);
  }

  Future<void> deleteDebt(DebtDataModel debt) async {
    await _model.deleteDebt(debt);
  }
}
