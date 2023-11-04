import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/widgets/person_list_item.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/widgets/new_person_dialog.dart';
import 'package:buxa/model/person_model.dart';

class PersonPageViewModel {
  final PersonModel _model = PersonModel();

  late Future<List<PersonDataModel>> peopleFuture;

  PersonPageViewModel() {
    peopleFuture = _model.loadPeople();
  }

  Future<void> refreshPeople() async {
    await _model.refreshPeople();
  }

  Future<void> loadPeople() async {
    peopleFuture = _model.loadPeople();
  }
}
