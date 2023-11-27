import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/widgets/error_dialog.dart';

class PocketPageModel {
  Future<List<PocketDataModel>> loadPockets(BuildContext context) async {
    List<PocketDataModel> pocketList = [];
    if (kIsWeb) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final pocketsCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Pockets');

          final pocketsQuerySnapshot = await pocketsCollectionRef.get();
          if (pocketsQuerySnapshot.docs.isNotEmpty) {
            pocketList = pocketsQuerySnapshot.docs
                .map((doc) => PocketDataModel.fromMap(doc.data()))
                .toList();
          } else {
            //ErrorDialog.show(context, 'Nincsenek adatok a Firestore-ban.');
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
      final repository = PocketRepository();
      pocketList = await repository.getPocketList();

      if (pocketList.isEmpty) {
        // ErrorDialog.show(context, 'Nincsenek adatok a helyi adatbázisban.');
      }
    }
    pocketList.add(PocketDataModel(name: 'Összes', special: true));
    return pocketList;
  }

  Future<void> deletePocket(PocketDataModel pocket) async {
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
              .collection('Pockets');

          final personQuerySnapshot =
              await peopleCollectionRef.where('id', isEqualTo: pocket.id).get();
          if (personQuerySnapshot.docs.isNotEmpty) {
            final personDocRef = personQuerySnapshot.docs.first.reference;
            await personDocRef.delete();
          } else {}
        } else {
          print('Nem vagy bejelentkezve.');
        }
      } catch (e) {
        print('Hiba történt a személy törlése közben: $e');
      }
    } else {
      final repository = PocketRepository();
      if (pocket.id != null) {
        await repository.deletePocket(pocket.id!);
      }
    }
  }
}
