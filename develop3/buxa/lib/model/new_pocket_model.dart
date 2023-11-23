import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/pocket_repository.dart';

class NewPocketModel {
  Future<int> insertPocket(String name) async {
    if (kIsWeb) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return 0;
        }

        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final pocketCollectionRef = firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Pockets');

        // Generate a unique id
        int newPocketId = 100; //await generateUniqueId();

        final newPocket =
            PocketDataModel(id: newPocketId, name: name, special: false);

        try {
          // Transaction to add the document with the unique id
          pocketCollectionRef.add(newPocket.toMap());
          return newPocketId;
        } catch (error) {
          print("Error during document addition: $error");
          return 0; // Error during document addition
        }
      } catch (error) {
        print("Error getting user or Firestore instance: $error");
        return -1; // Error getting user or Firestore instance
      }
    } else {
      final pocketRepo = PocketRepository();
      final newPocket = PocketDataModel(name: name);
      return await pocketRepo.insertPocket(newPocket);
    }
  }

  Future<int> generateUniqueId() async {
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
}
