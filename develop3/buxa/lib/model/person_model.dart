import 'package:buxa/data_model/person_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/person_repository.dart';

class PersonModel {
  Future<List<PersonDataModel>> loadPeople() async {
    if (kIsWeb) {
      // Webes környezetben a helyi mock adatokat használjuk
      return _loadMockPeople();
    } else {
      // Mobilalkalmazásban a repositorytől kérjük le az adatokat
      final repository = PersonRepository();
      return await repository.getPersonList();
    }
  }

  Future<void> refreshPeople() async {
    if (!kIsWeb) {
      // Mobilalkalmazásban az adatok újratöltéséhez használjuk a repositoryt
      final repository = PersonRepository();
      await repository.getPersonList();
    }
  }

  List<PersonDataModel> _loadMockPeople() {
    // Itt definiálhatod a helyi mock adatokat
    return [
      PersonDataModel(id: 1, name: 'Személy 1'),
      PersonDataModel(id: 2, name: 'Személy 2'),
      // További mock adatok
    ];
  }
}
