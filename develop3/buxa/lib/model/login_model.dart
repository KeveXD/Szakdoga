import 'package:firebase_auth/firebase_auth.dart';

import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/pocket_repository.dart';

class LoginModel {
  // Firebase authentikáció
  Future<User?> loginFirebase(String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Hiba a bejelentkezés során: $e');
      return null;
    }
  }

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> clearAllRepositoryData() async {
    await _clearDebtRepository();
    await _clearPaymentRepository();
    await _clearPersonRepository();
    await _clearPocketRepository();
  }

  Future<void> _clearDebtRepository() async {
    final debtRepository = DebtRepository();
    final debtList = await debtRepository.getDebtList();
    if (debtList.isNotEmpty) {
      for (final debt in debtList) {
        await debtRepository.deleteDebt(debt);
      }
    }
  }

  Future<void> _clearPaymentRepository() async {
    final paymentRepository = PaymentRepository();
    final paymentList = await paymentRepository.getPaymentList();
    if (paymentList.isNotEmpty) {
      for (final payment in paymentList) {
        await paymentRepository.deletePayment(payment.id!);
      }
    }
  }

  Future<void> _clearPersonRepository() async {
    final personRepository = PersonRepository();
    final personList = await personRepository.getPersonList();
    if (personList.isNotEmpty) {
      for (final person in personList) {
        await personRepository.deletePerson(person.id!);
      }
    }
  }

  Future<void> _clearPocketRepository() async {
    final pocketRepository = PocketRepository();
    final pocketList = await pocketRepository.getPocketList();
    if (pocketList.isNotEmpty) {
      for (final pocket in pocketList) {
        await pocketRepository.deletePocket(pocket.id!);
      }
    }
  }
}
