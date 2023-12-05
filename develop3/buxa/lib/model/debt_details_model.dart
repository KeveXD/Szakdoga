import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DebtDetailsModel {
  late List<DebtDataModel> allDebts;

  DebtDetailsModel() {
    allDebts = [];
  }

  Future<void> loadFromDatabase() async {
    if (kIsWeb) {
      // Web platformon használjuk a Firestore-t
      try {
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
            allDebts = debtList;
          }
        } else {
          // Kezeld le az esetet, amikor a felhasználó nincs bejelentkezve
        }
      } catch (e) {
        print('Hiba történt a lekérdezés közben: $e');
      }
    } else {
      // Mobil platformon használjuk a DebtRepository-t

      final debtDbHelper = DebtRepository();
      allDebts = await debtDbHelper.getDebtList();
    }
  }

  Future<List<DebtDataModel>> calculateDebts() async {
    if (allDebts.isEmpty) {
      await loadFromDatabase();
    }

    Map<String, int> debtsMap = {};
    final personDbHelper = kIsWeb ? null : PersonRepository();

    //kiveszem az összes nevet a debtListItem-ekből
    for (DebtDataModel debt in allDebts) {
      final debtorPerson = kIsWeb
          ? await getPersonByIdWeb(debt.debtorPersonId!)
          : await personDbHelper!.getPersonById(debt.debtorPersonId!);

      final personTo = kIsWeb
          ? await getPersonByIdWeb(debt.personToId!)
          : await personDbHelper!.getPersonById(debt.personToId!);

      if (debtorPerson != null) {
        debtsMap[debtorPerson.name] = debtsMap.containsKey(debtorPerson.name)
            ? debtsMap[debtorPerson.name]! + (debt.amount ?? 0)
            : debt.amount ?? 0;
      }

      if (personTo != null) {
        debtsMap[personTo.name] = debtsMap.containsKey(personTo.name)
            ? debtsMap[personTo.name]! - (debt.amount ?? 0)
            : -(debt.amount ?? 0);
      }
    }

    String debtorWithSmallestDebt = '';
    String debtorWithLargestDebt = '';
    int smallestDebt = 0;
    int largestDebt = 0;
    List<DebtDataModel> resultDebts = [];

    debtsMap.forEach((debtor, amount) {
      if (amount > largestDebt) {
        largestDebt = amount;
        debtorWithLargestDebt = debtor;
      }
      if (amount < smallestDebt) {
        smallestDebt = amount;
        debtorWithSmallestDebt = debtor;
      }
    });

    while (debtsMap.values.any((value) => value != 0)) {
      debtorWithSmallestDebt = '';
      debtorWithLargestDebt = '';
      smallestDebt = 0;
      largestDebt = 0;

      debtsMap.forEach((debtor, amount) {
        if (amount > largestDebt) {
          largestDebt = amount;
          debtorWithLargestDebt = debtor;
        }
        if (amount < smallestDebt) {
          smallestDebt = amount;
          debtorWithSmallestDebt = debtor;
        }
      });

      if (smallestDebt.abs() > largestDebt.abs()) {
        debtsMap[debtorWithSmallestDebt] =
            (debtsMap[debtorWithSmallestDebt] ?? 0) + largestDebt;

        debtsMap[debtorWithLargestDebt] =
            (debtsMap[debtorWithLargestDebt] ?? 0) - largestDebt;

        final debtorPerson = kIsWeb
            ? await getPersonByNameWeb(debtorWithLargestDebt)
            : await personDbHelper!.getPersonByName(debtorWithLargestDebt);
        final personTo = kIsWeb
            ? await getPersonByNameWeb(debtorWithSmallestDebt)
            : await personDbHelper!.getPersonByName(debtorWithSmallestDebt);

        if (debtorPerson != null && personTo != null) {
          resultDebts.add(DebtDataModel(
            debtorPersonId: debtorPerson.id,
            personToId: personTo.id,
            amount: largestDebt.abs(),
          ));
        }
      } else {
        debtsMap[debtorWithLargestDebt] =
            (debtsMap[debtorWithLargestDebt] ?? 0) + smallestDebt;

        debtsMap[debtorWithSmallestDebt] =
            (debtsMap[debtorWithSmallestDebt] ?? 0) - smallestDebt;

        final debtorPerson = kIsWeb
            ? await getPersonByNameWeb(debtorWithLargestDebt)
            : await personDbHelper!.getPersonByName(debtorWithLargestDebt);

        final personTo = kIsWeb
            ? await getPersonByNameWeb(debtorWithSmallestDebt)
            : await personDbHelper!.getPersonByName(debtorWithSmallestDebt);

        if (debtorPerson != null && personTo != null) {
          resultDebts.add(DebtDataModel(
            debtorPersonId: debtorPerson.id,
            personToId: personTo.id,
            amount: smallestDebt.abs(),
          ));
        }
      }
    }

    return resultDebts;
  }

  Future<PersonDataModel?> getPersonByIdWeb(int id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final personQuerySnapshot = await firestore
          .collection(userEmail!)
          .doc('userData')
          .collection('People')
          .where('id', isEqualTo: id)
          .get();

      if (personQuerySnapshot.docs.isNotEmpty) {
        final personDoc = personQuerySnapshot.docs.first;
        return PersonDataModel.fromMap(personDoc.data()!);
      } else {
        print("id-s függvény nem jó");
      }
    }

    return null;
  }

  Future<PersonDataModel?> getPersonByNameWeb(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final personQuerySnapshot = await firestore
          .collection(userEmail!)
          .doc('userData')
          .collection('People')
          .where('name', isEqualTo: name)
          .get();

      if (personQuerySnapshot.docs.isNotEmpty) {
        final personDoc = personQuerySnapshot.docs.first;
        return PersonDataModel.fromMap(personDoc.data()!);
      } else
        print("lol name");
    }

    return null;
  }
}
