import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/viewmodel/new_person_viewmodel.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/model/new_person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewDebtDialogModel {
  Future<int?> insertPersonIfNeeded(String name, BuildContext context) async {
    try {
      final NewPersonModel _model = NewPersonModel();
      final NewPersonViewModel viewmodel =
          NewPersonViewModel(onAddNewPerson: () {});
      PersonRepository personRepository = new PersonRepository();
      final need = await personRepository.doesPersonExist(name);

      if (kIsWeb) {
        final id = await viewmodel.generateUniqueId();
        viewmodel.addNewPersonToFirebase(context, name, id);
        return id;
      } else {
        if (!need) {
          await _model.insertPerson(name, "pelda@gmail.com", false, context);
          Future<int?> personId = personRepository.getPersonIdByName(name);
          return personId;
        } else {
          final personId = await personRepository.getPersonIdByName(name);
          return personId;
        }
      }
    } catch (error) {
      return 0;
    }

    //return int.tryParse(newPersonDocRef.id);
  }

  Future<void> insertDebt(DebtDataModel newDebt) async {
    if (!kIsWeb) {
      final dbHelper = DebtRepository();
      await dbHelper.insertDebt(newDebt);
    } else {
      try {
        newDebt.id = await generateUniqueId();
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
        print('Hiba történt az adósság hozzáadása közben: $e');
      }
    }
  }

  Future<PersonDataModel?> getPersonByNameWeb(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final personQuerySnapshot = await firestore
          .collection(userEmail!)
          .doc('userData')
          .collection('People')
          .where('name', isEqualTo: name)
          .get();

      if (personQuerySnapshot.docs.isNotEmpty) {
        final personDoc = personQuerySnapshot.docs.first;
        return PersonDataModel.fromMap(personDoc.data()!);
      }
    }

    return null;
  }

  Future<int> generateUniqueId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final peopleCollectionRef =
          firestore.collection(userEmail!).doc('userData').collection('Debts');
      int uniqueId;

      // Keresd meg a legnagyobb id-t a Firestore-ban
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await peopleCollectionRef
              .orderBy('id', descending: true)
              .limit(1)
              .get();

      // Ha vannak dokumentumok, használd azokat, különben kezdd az id-t 1-től
      if (querySnapshot.docs.isNotEmpty) {
        final int highestId = querySnapshot.docs.first['id'];
        uniqueId = highestId + 1;
      } else {
        // Ha nincsenek dokumentumok, kezd el az id-t 1-től
        uniqueId = 1;
      }

      // Ellenőrizd, hogy az újonnan generált id még nincs használatban
      bool idExists;

      do {
        final snapshot =
            await peopleCollectionRef.where('id', isEqualTo: uniqueId).get();

        idExists = snapshot.docs.isNotEmpty;

        // Ha az id már létezik, növeld meg és ellenőrizd újra
        if (idExists) {
          uniqueId++;
        }
      } while (idExists);

      return uniqueId;
    }
    return 0;
  }
}
