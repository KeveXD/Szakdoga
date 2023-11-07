import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DebtModel {
  final DebtRepository _repository = DebtRepository();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<DebtDataModel>> getDebtList() async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final debtsCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Debts');

        final debtQuerySnapshot = await debtsCollectionRef.get();
        if (debtQuerySnapshot.docs.isNotEmpty) {
          final debtList = debtQuerySnapshot.docs
              .map((doc) => DebtDataModel.fromMap(doc.data()))
              .toList();
          return debtList;
        }
      }
      return <DebtDataModel>[];
    } else {
      return _repository.getDebtList();
    }
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
