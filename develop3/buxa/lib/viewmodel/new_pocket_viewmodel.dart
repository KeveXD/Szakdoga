import 'package:buxa/database/pocket_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/model/new_pocket_model.dart';

class NewPocketViewModel {
  final BuildContext context;
  final NewPocketModel model = NewPocketModel();

  NewPocketViewModel({required this.context});

  Future<void> addNewPocket(String name, VoidCallback onAddNewPocket) async {
    if (name.isEmpty) {
      ErrorDialog.show(context, 'A nevet kötelező megadni');
    } else {
      final id = await generateUniqueId();

      await model.insertPocket(name, id);

      onAddNewPocket();

      Navigator.of(context).pop();
    }
  }

  Future<int> generateUniqueId() async {
    List<PocketDataModel> pockets = [];
    final personDbHelper = PocketRepository();
    pockets = await personDbHelper.loadPersons();

    // Keresd meg a legnagyobb id-t a persons listában
    int highestId = 0;
    for (final pocket in pockets) {
      if (pocket.id! > highestId) {
        highestId = pocket.id!;
      }
    }

    // Az új id érték a legnagyobb id-hez + 1
    int newId = highestId + 1;

    return newId;
  }

  /*Future<int> generateUniqueId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final peopleCollectionRef = firestore
          .collection(userEmail!)
          .doc('userData')
          .collection('Pockets');
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
*/
}
