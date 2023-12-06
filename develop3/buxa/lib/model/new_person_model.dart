import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/error_dialog.dart';

class NewPersonModel {
  Future<bool?> insertPerson(
      String name, String email, bool hasRevolut, BuildContext context) async {
    if (kIsWeb) {
    } else {
      // Mobil platformon használjuk a PersonRepository-t
      final dbHelper = PersonRepository();
      final newPerson = PersonDataModel(
        name: name,
        email: email,
        hasRevolut: hasRevolut,
      );

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      try {
        final id = await dbHelper.insertPerson(newPerson);
        Navigator.of(context).pop(); // Töltő ikon eltávolítása
        return true;
      } catch (error) {
        //Navigator.of(context).pop(); // Töltő ikon eltávolítása
        ErrorDialog.show(context, 'Hiba történt a beszúrás közben: $error');
        return false;
      }
    }
  }
}
