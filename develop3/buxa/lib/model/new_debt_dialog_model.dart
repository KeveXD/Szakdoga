import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/data_model/debt_data_model.dart';

class NewDebtDialogModel {
  Future insertPersonIfNeeded(String name) async {
    if (!kIsWeb) {
      final personDbHelper = PersonRepository();
      final existingPerson = await personDbHelper.getPersonByName(name);
      if (existingPerson != null) {
        return existingPerson.id;
      } else {
        final newPerson = PersonDataModel(name: name);
        return personDbHelper.insertPerson(newPerson);
      }
    } else {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          // Ellenőrizzük, hogy van-e már személy az adott névvel
          final existingPersonQuerySnapshot = await firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People')
              .where('name', isEqualTo: name)
              .get();

          if (existingPersonQuerySnapshot.docs.isNotEmpty) {
            final existingPersonDoc = existingPersonQuerySnapshot.docs.first;
            return existingPersonDoc['id'];
          }

          // Ha nincs, hozzáadjuk az új személyt
          final newPersonDoc = await firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People')
              .add({'name': name});

          return newPersonDoc.id;
        }
      } catch (e) {
        // Hiba kezelése
        print('Hiba történt a személy hozzáadása közben: $e');

        return null;
      }
    }
  }

  Future<void> insertDebt(DebtDataModel newDebt) async {
    if (!kIsWeb) {
      final dbHelper = DebtRepository();
      await dbHelper.insertDebt(newDebt);
    } else {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          // Adósság hozzáadása a Firestore-ba
          await firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Debts')
              .add(newDebt.toMap());
        }
      } catch (e) {
        // Hiba kezelése
        print('Hiba történt az adósság hozzáadása közben: $e');
      }
    }
  }

  Future<List<PersonDataModel>> loadPersons() async {
    if (!kIsWeb) {
      final personDbHelper = PersonRepository();
      return await personDbHelper.getPersonList();
    } else {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          // Személyek lekérdezése a Firestore-ból
          final personQuerySnapshot = await firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People')
              .get();

          return personQuerySnapshot.docs
              .map((doc) => PersonDataModel.fromMap(doc.data()))
              .toList();
        }
      } catch (e) {
        // Hiba kezelése
        print('Hiba történt a személyek lekérdezése közben: $e');
        return [];
      }
    }
    return [];
  }
}
