import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/model/new_debt_dialog_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/debt_data_model.dart';

class NewDebtDialogViewModel {
  final NewDebtDialogModel model = NewDebtDialogModel();
  final TextEditingController amountController = TextEditingController();
  bool hasRevolut = false;

  List<DropdownMenuItem<int>> personDropdownItems = [];
  List<PersonDataModel> persons = [];

  Future<void> loadDropdownItems() async {
    persons = await model.loadPersons();

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
    final personToId = await model.insertPersonIfNeeded(name);
    final debtorPersonId = await model.insertPersonIfNeeded(debtorName);

    final newDebt = DebtDataModel(
      debtorPersonId: debtorPersonId,
      personToId: personToId,
      amount: int.parse(amountController.text),
      isPaid: false,
      description: "Leírás",
    );

    model.insertDebt(newDebt);

    onAddNewElement();
    Navigator.of(context).pop();
  }
}
