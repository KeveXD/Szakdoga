import 'package:flutter/material.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/model/new_pocket_model.dart';

class NewPocketViewModel {
  final BuildContext context;
  final NewPocketModel model = NewPocketModel();

  NewPocketViewModel({required this.context});

  Future<void> addNewPocket(String name, VoidCallback onAddNewPocket) async {
    if (name.isEmpty) {
      ErrorDialog.show(context, 'A nevet kötelező megadni');
    } else {
      await model.insertPocket(name);

      onAddNewPocket();

      Navigator.of(context).pop();
    }
  }
}
