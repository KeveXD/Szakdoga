import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NewPersonModel {
  Future<int?> insertPerson(String name, String email, bool hasRevolut) async {
    if (kIsWeb) {
      // Webes platformon Firestore használata
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People');
          final newPerson = PersonDataModel(
            name: name,
            email: email,
            hasRevolut: hasRevolut,
          );

          final docRef = await peopleCollectionRef.add(newPerson.toMap());
          return newPerson.id;
        }
      } catch (error) {
        print('Hiba történt: $error');
        return null;
      }
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
