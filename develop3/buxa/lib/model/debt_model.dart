import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DebtModel {
  final DebtRepository _repository = DebtRepository();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<DebtDataModel>> getDebtList() async {
    return _repository.getDebtList();
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
