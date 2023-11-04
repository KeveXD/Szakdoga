import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:buxa/data_model/debt_data_model.dart';

class NewDebtDialogService {
  final TextEditingController amountController = TextEditingController();
  bool hasRevolut = false;

  List<DropdownMenuItem<int>> personDropdownItems = [];
  List<PersonDataModel> persons = [];

  Future<void> loadDropdownItems() async {
    final personDbHelper = PersonRepository();
    persons = await personDbHelper.getPersonList();

    personDropdownItems = persons
        .map(
          (person) => DropdownMenuItem<int>(
            value: person.id,
            child: Text(person.name),
          ),
        )
        .toList();
  }

  Future<void> addNewDebt(BuildContext context, VoidCallback onAddNewElement,
      String name, String debtorName) async {
    final personDbHelper = PersonRepository();
    final personTo = await personDbHelper.getPersonByName(name);
    final debtorPerson = await personDbHelper.getPersonByName(debtorName);

    int? personToId;
    if (personTo != null) {
      personToId = personTo.id;
    } else {
      final newPersonTo = PersonDataModel(name: name);
      personToId = await personDbHelper.insertPerson(newPersonTo);
    }

    int? debtorPersonId;
    if (debtorPerson != null) {
      debtorPersonId = debtorPerson.id;
    } else {
      final newDebtorPerson = PersonDataModel(name: debtorName);
      debtorPersonId = await personDbHelper.insertPerson(newDebtorPerson);
    }

    final newDebt = DebtDataModel(
      debtorPersonId: debtorPersonId,
      personToId: personToId,
      amount: int.parse(amountController.text),
      isPaid: false,
      description: "Leírás",
    );

    final dbHelper = DebtRepository();
    final id = await dbHelper.insertDebt(newDebt);
    newDebt.id = id;
    onAddNewElement();
    Navigator.of(context).pop();
  }

  Future<void> selectPersonByName(String name) async {
    final personDbHelper = PersonRepository();
    final person = await personDbHelper.getPersonByName(name);

    if (person != null) {
      // Találtunk egy személyt a megadott név alapján
      // Itt megteheted, amit szeretnél ezzel az adattal
      // Például beállíthatod a kiválasztott személyt
    } else {
      // Nem találtunk megfelelő személyt a név alapján
      // Kezelheted ezt a helyzetet
    }
  }
}
