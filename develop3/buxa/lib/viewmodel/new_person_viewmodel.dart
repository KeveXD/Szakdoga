import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/model/new_person_model.dart';

class NewPersonViewModel {
  final NewPersonModel _model = NewPersonModel();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool hasRevolut = false;

  final VoidCallback onAddNewPerson;

  NewPersonViewModel({required this.onAddNewPerson});

  Future<void> addNewPerson(BuildContext context) async {
    final name = nameController.text;
    final email = emailController.text;
    final result = await _model.insertPerson(name, email, hasRevolut, context);

    if (result != null) {
      onAddNewPerson();
      Navigator.of(context).pop();
    }
  }
}
