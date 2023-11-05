import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/model/person_list_item_model.dart';

class PersonListItemViewModel {
  final PersonListItemModel model = PersonListItemModel();
  late Future<List<PersonDataModel>> peopleFuture;

  PersonListItemViewModel() {}

  Future<void> loadPeople(BuildContext context) async {
    //peopleFuture = model.getPeople();
  }

  Future<void> refreshPeople(BuildContext context) async {
    loadPeople(context);
  }

  Future<void> deletePerson(int id) async {
    model.deletePerson(id);
  }
}
