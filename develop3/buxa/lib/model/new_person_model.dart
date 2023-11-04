import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:flutter/foundation.dart';

class NewPersonModel {
  Future<int?> insertPerson(String name, String email, bool hasRevolut) async {
    if (kIsWeb) {
    } else {
      // Mobil platformon használjuk a PersonRepository-t
      final dbHelper = PersonRepository();
      final newPerson = PersonDataModel(
        name: name,
        email: email,
        hasRevolut: hasRevolut,
      );
      return await dbHelper.insertPerson(newPerson);
    }
  }
}
