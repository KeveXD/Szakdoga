import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PersonListItemModel {
  final PersonRepository _repository = PersonRepository();

  Future<List<PersonDataModel>> getPeople() async {
    return await _repository.getPersonList();
  }

  Future<int> deletePerson(int id) async {
    if (kIsWeb) {
      try {
        final firestore = FirebaseFirestore.instance;
        final user = FirebaseAuth.instance.currentUser;
        String? userEmail;

        if (user != null) {
          userEmail = user.email;
          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People');

          final personQuerySnapshot =
              await peopleCollectionRef.where('id', isEqualTo: id).get();
          if (personQuerySnapshot.docs.isNotEmpty) {
            // Csak egy elemet töröljünk, ha több azonosító is megegyezik, válasszuk ki azt, amelyiket törölni szeretnénk
            final personDocRef = personQuerySnapshot.docs.first.reference;
            await personDocRef.delete();
          } else {
            print('Az $id azonosítójú személy nem található a Firestore-ban.');
          }
        } else {
          // Kezeld le az esetet, amikor a felhasználó nincs bejelentkezve
          print('Nem vagy bejelentkezve.');
        }
      } catch (e) {
        print('Hiba történt a személy törlése közben: $e');
      }
    } else {
      // Ha nem webes platformon fut az alkalmazás, akkor helyi adatbázis használata
      print('A $id azonosítójú törölveeee');
      return await _repository.deletePerson(id);
    }

    return 0; // Itt visszaadjuk az alapértelmezett értéket, de változtathatod
  }
}
