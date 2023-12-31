import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/model/new_debt_dialog_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';

class NewDebtViewModel {
  final NewDebtDialogModel model = NewDebtDialogModel();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController debtorNameController = TextEditingController();
  bool hasRevolut = false;

  List<DropdownMenuItem<int>> personDropdownItems = [];
  List<PersonDataModel> persons = [];

  Future<void> loadDropdownItems() async {
    final personDbHelper = PersonRepository();
    persons = await personDbHelper.loadPersons();

    personDropdownItems = persons
        .map(
          (person) => DropdownMenuItem<int>(
            value: person.id,
            child: Text(person.name),
          ),
        )
        .toList();
  }

  Future<void> addNewDebt(
      BuildContext context, VoidCallback onAddNewElement) async {
    if (nameController.text.isEmpty ||
        debtorNameController.text.isEmpty ||
        amountController.text.isEmpty) {
      ErrorDialog.show(context, 'Az összes mező kitöltése kötelező.');
      return;
    }

    final personToId =
        await model.insertPersonIfNeeded(nameController.text, context);
    final debtorPersonId =
        await model.insertPersonIfNeeded(debtorNameController.text, context);

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
