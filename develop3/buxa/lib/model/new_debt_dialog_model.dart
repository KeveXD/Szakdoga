import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/data_model/debt_data_model.dart';

class NewDebtDialogModel {
  Future<int?> insertPersonIfNeeded(String name) async {
    if (!kIsWeb) {
      final personDbHelper = PersonRepository();
      final existingPerson = await personDbHelper.getPersonByName(name);
      if (existingPerson != null) {
        return existingPerson.id;
      } else {
        final newPerson = PersonDataModel(name: name);
        return personDbHelper.insertPerson(newPerson);
      }
    } else {
      // Web esetén itt kezelhetjük a személy hozzáadását, ha szükséges.
      // Például a helyi tároló vagy hálózati szolgáltatások használatával.
      return null;
    }
  }

  Future<void> insertDebt(DebtDataModel newDebt) async {
    if (!kIsWeb) {
      final dbHelper = DebtRepository();
      await dbHelper.insertDebt(newDebt);
    } else {
      // Web esetén itt kezelhetjük az adósság hozzáadását, ha szükséges.
      // Például a helyi tároló vagy hálózati szolgáltatások használatával.
    }
  }

  Future<List<PersonDataModel>> loadPersons() async {
    if (!kIsWeb) {
      final personDbHelper = PersonRepository();
      return await personDbHelper.getPersonList();
    } else {
      // Web esetén itt kezelhetjük a személyek lekérését, ha szükséges.
      // Például a helyi tároló vagy hálózati szolgáltatások használatával.
      return [];
    }
  }
}
