import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/widgets/person_list_item.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/widgets/new_person_dialog.dart';
import 'package:buxa/model/person_model.dart';

class PersonViewModel {
  final PersonModel _model = PersonModel();

  late Future<List<PersonDataModel>> peopleFuture;

  PersonViewModel(BuildContext context) {
    loadPeople(context);
  }

  Future<void> loadPeople(BuildContext context) async {
    peopleFuture = _model.loadPeople(context);
  }
}
