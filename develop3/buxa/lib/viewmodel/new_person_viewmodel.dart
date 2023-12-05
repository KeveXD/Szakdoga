import 'package:buxa/database/person_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/model/new_person_model.dart';

class NewPersonViewModel {
  final NewPersonModel _model = NewPersonModel();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool hasRevolut = false;

  final VoidCallback onAddNewPerson;

  NewPersonViewModel({required this.onAddNewPerson});

  Future<void> addNewPerson(BuildContext context) async {
    final name = nameController.text;
    final email = emailController.text;
    final id = await generateUniqueId();
    final result = addNewPersonToFirebase(context, name, id);
    // await _model.insertPerson(name, email, hasRevolut, context, id);

    if (result != null) {
      onAddNewPerson();
      Navigator.of(context).pop();
    }
  }

  Future<int> generateUniqueId() async {
    List<PersonDataModel> persons = [];
    final personDbHelper = PersonRepository();
    persons = await personDbHelper.loadPersons();

    // Keresd meg a legnagyobb id-t a persons listában
    int highestId = 0;
    for (final person in persons) {
      if (person.id! > highestId) {
        highestId = person.id!;
      }
    }

    // Az új id érték a legnagyobb id-hez + 1
    int newId = highestId + 1;

    print(newId);
    return newId;
  }

  Future<void> addNewPersonToFirebase(
      BuildContext context, String name, int id) async {
    final newPerson = PersonDataModel(
      id: id,
      name: name,
      email: '',
      hasRevolut: hasRevolut,
    );

    final result = await insertPersonToFirebase(newPerson, context);

    if (result != null) {
      onAddNewPerson();
      Navigator.of(context).pop();
    }
  }

  Future<bool?> insertPersonToFirebase(
      PersonDataModel newPerson, BuildContext context) async {
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

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          try {
            // Tranzakció a dokumentum hozzáadásához az egyedi id-vel
            await peopleCollectionRef.add(newPerson.toMap());

            Navigator.of(context).pop(); // Töltő ikon eltávolítása
            return true;
          } catch (error) {}
        }
      } catch (error) {}
    } else {
      // Mobil platform esetén itt lehet implementálni a Firestore adatbázisba való beszúrást
      // A kódot nem változtattam meg, mert azt már korábban is megírtad a helyi adatbázisra
    }
  }
}
