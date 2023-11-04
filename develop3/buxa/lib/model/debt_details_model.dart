import 'package:flutter/foundation.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/database/person_repository.dart';

class DebtDetailsModel {
  late List<DebtDataModel> allDebts;

  DebtDetailsModel() {
    allDebts = [];
  }

  Future<void> loadFromDatabase() async {
    if (kIsWeb) {
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
    final personDbHelper = PersonRepository();

    //kiveszem az összes nevet a debtListItem-ekből
    for (DebtDataModel debt in allDebts) {
      final debtorPerson =
          await personDbHelper.getPersonById(debt.debtorPersonId!);
      final personTo = await personDbHelper.getPersonById(debt.personToId!);

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

    int a = 0;
    while (debtsMap.values.any((value) => value != 0)) {
      debtorWithSmallestDebt = '';
      debtorWithLargestDebt = '';
      smallestDebt = 0;
      largestDebt = 0;
      a++;

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

        final debtorPerson =
            await personDbHelper.getPersonByName(debtorWithLargestDebt);
        final personTo =
            await personDbHelper.getPersonByName(debtorWithSmallestDebt);

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

        final debtorPerson =
            await personDbHelper.getPersonByName(debtorWithLargestDebt);
        final personTo =
            await personDbHelper.getPersonByName(debtorWithSmallestDebt);

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
}
