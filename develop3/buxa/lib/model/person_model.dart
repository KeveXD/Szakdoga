import 'package:buxa/data_model/person_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/person_repository.dart';

class PersonModel {
  Future<List<PersonDataModel>> loadPeople() async {
    if (kIsWeb) {
      return _loadMockPeople();
    } else {
      final repository = PersonRepository();
      return await repository.getPersonList();
    }
  }

  Future<void> refreshPeople() async {
    if (!kIsWeb) {
      final repository = PersonRepository();
      await repository.getPersonList();
    }
  }

//ez csak példa
  List<PersonDataModel> _loadMockPeople() {
    return [
      PersonDataModel(id: 1, name: 'Személy 1'),
      PersonDataModel(id: 2, name: 'Személy 2'),
    ];
  }
}
