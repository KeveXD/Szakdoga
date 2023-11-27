import 'package:buxa/data_model/debt_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/debt_repository.dart';

class DebtModel {
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
      // A nem webes platformokon a lokális adatbázist használjuk
      final repository = DebtRepository();
      return repository.getDebtList();
    }
  }

  Future<void> addDebt(DebtDataModel debt) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final debtsCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Debts');

        await debtsCollectionRef.add(debt.toMap());
      }
    } else {
      final repository = DebtRepository();
      await repository.insertDebt(debt);
    }
  }

  Future<void> updateDebt(DebtDataModel debt) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final debtsCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Debts');

        final debtRef = debtsCollectionRef.doc(debt.id.toString());
        await debtRef.set(debt.toMap());
      }
    } else {
      final repository = DebtRepository();
      await repository.updateDebt(debt);
    }
  }

  Future<void> deleteDebt(DebtDataModel debt) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final debtsCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Debts');

        final debtRef = debtsCollectionRef.doc(debt.id.toString());
        await debtRef.delete();
      }
    } else {
      final repository = DebtRepository();
      await repository.deleteDebt(debt);
    }
  }
}
