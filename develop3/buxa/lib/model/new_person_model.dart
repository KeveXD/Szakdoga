import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'dart:math';

class NewPersonModel {
  Future<bool?> insertPerson(
      String name, String email, bool hasRevolut, BuildContext context) async {
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

          // Generálj egy egyedi id-t
          final newPersonId = await generateUniqueId();

          final newPerson = PersonDataModel(
            id: newPersonId,
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
            },
          );

          try {
            // Tranzakció a dokumentum hozzáadásához az egyedi id-vel
            final docRef = await peopleCollectionRef.add(newPerson.toMap());

            Navigator.of(context).pop(); // Töltő ikon eltávolítása
            return true;
          } catch (error) {
            Navigator.of(context).pop(); // Töltő ikon eltávolítása
            ErrorDialog.show(context,
                'Hiba történt a Firestore-ba való beszúrás közben: $error');
            return false;
          }
        }
      } catch (error) {
        Navigator.of(context).pop(); // Töltő ikon eltávolítása
        ErrorDialog.show(context, 'Hiba történt: $error');
        return false;
      }
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
        Navigator.of(context).pop(); // Töltő ikon eltávolítása
        ErrorDialog.show(context, 'Hiba történt a beszúrás közben: $error');
        return false;
      }
    }
  }

  Future<int> generateUniqueId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final peopleCollectionRef =
          firestore.collection(userEmail!).doc('userData').collection('People');
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
