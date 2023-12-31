import 'package:buxa/data_model/person_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/error_dialog.dart';

class PersonModel {
  Future<List<PersonDataModel>> loadPeople(BuildContext context) async {
    List<PersonDataModel> peopleList = [];

    if (kIsWeb) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People');

          final peopleQuerySnapshot = await peopleCollectionRef.get();
          if (peopleQuerySnapshot.docs.isNotEmpty) {
            peopleList = peopleQuerySnapshot.docs
                .map((doc) => PersonDataModel.fromMap(doc.data()))
                .toList();
          } else {
            ErrorDialog.show(context, 'Nincsenek adatok a Firestore-ban.');
          }
        } else {
          ErrorDialog.show(context, 'Nem vagy bejelentkezve.');
        }
      } catch (error) {
        ErrorDialog.show(context, 'Hiba történt: $error');
      } finally {
        //Navigator.of(context).pop(); // Töltő ikon eltávolítása
      }
    } else {
      final repository = PersonRepository();
      peopleList = await repository.getPersonList();

      if (peopleList.isEmpty) {
        // ErrorDialog.show(context, 'Nincsenek adatok a helyi adatbázisban.');
      }
    }

    return peopleList;
  }
}
