import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/pocket_repository.dart';

class NewPocketModel {
  Future<int> insertPocket(String name, int pocketId) async {
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
            PocketDataModel(id: pocketId, name: name, special: false);

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
}
