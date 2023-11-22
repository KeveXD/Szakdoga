import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buxa/view/debt_page.dart';
import 'package:buxa/view/pocket_page.dart';
import 'package:buxa/view/query_page.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class MenuPageViewModel {
  MenuPageViewModel();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  void upload(BuildContext context) {
    uploadPeopleAndInitialize(context);
    uploadDebts(context);
    uploadPockets(context);
  }

  void download(BuildContext context) {
    downloadPeople(context);
    downloadDebts(context);
    downloadPockets(context);
  }

  void navigateToQueryPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QueryPage(),
    ));
  }

  void navigateToDebtPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DebtPage(),
    ));
  }

  void navigateToPocketPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PocketPage(),
    ));
  }

  Future<void> downloadPeople(BuildContext context) async {
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
      await Firebase.initializeApp();

      bool userLoggedIn = true;

      if (userLoggedIn) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String userEmail = getUserEmail() ?? 'example@gmail.com';

        CollectionReference peopleCollectionRef = firestore
            .collection(userEmail)
            .doc('userData')
            .collection('People');

        final personRepo = PersonRepository();
        final localPeople = await personRepo.getPersonList();
        for (final person in localPeople) {
          await personRepo.deletePerson(person.id!);
        }

        QuerySnapshot peopleCollection = await peopleCollectionRef.get();

        for (QueryDocumentSnapshot personSnapshot in peopleCollection.docs) {
          Map<String, dynamic> personData =
              personSnapshot.data() as Map<String, dynamic>;

          final person = PersonDataModel.fromMap(personData);
          await personRepo.insertPerson(person);
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }

  Future<void> uploadPeopleAndInitialize(BuildContext context) async {
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String userEmail = getUserEmail() ?? 'example@gmail.com';

      DocumentReference userCollectionRef =
          firestore.collection(userEmail).doc('userData');
      DocumentSnapshot userCollection = await userCollectionRef.get();

      if (!userCollection.exists) {
        await userCollectionRef.set({
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      CollectionReference peopleCollectionRef =
          userCollectionRef.collection('People');

      QuerySnapshot existingPeople = await peopleCollectionRef.get();
      for (QueryDocumentSnapshot document in existingPeople.docs) {
        await document.reference.delete();
      }

      final personRepo = PersonRepository();
      final personList = await personRepo.getPersonList();

      for (final person in personList) {
        await peopleCollectionRef.add(person.toMap());
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }

  Future<void> uploadDebts(BuildContext context) async {
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
      await Firebase.initializeApp();

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String userEmail = getUserEmail() ?? 'example@gmail.com';

      DocumentReference debtsCollectionRef =
          firestore.collection(userEmail).doc('userData');

      QuerySnapshot existingDebts =
          await debtsCollectionRef.collection('Debts').get();
      for (QueryDocumentSnapshot document in existingDebts.docs) {
        await document.reference.delete();
      }

      final debtRepo = DebtRepository();
      final debtList = await debtRepo.getDebtList();

      for (final debt in debtList) {
        await debtsCollectionRef.collection('Debts').add(debt.toMap());
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }

  Future<void> downloadDebts(BuildContext context) async {
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
      await Firebase.initializeApp();

      bool userLoggedIn = true;

      if (userLoggedIn) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String userEmail = getUserEmail() ?? 'example@gmail.com';

        DocumentReference debtsCollectionRef =
            firestore.collection(userEmail).doc('userData');

        final debtRepo = DebtRepository();
        final localDebts = await debtRepo.getDebtList();
        for (final debt in localDebts) {
          await debtRepo.deleteDebt(debt);
        }

        QuerySnapshot debtsCollection =
            await debtsCollectionRef.collection('Debts').get();

        for (QueryDocumentSnapshot debtSnapshot in debtsCollection.docs) {
          Map<String, dynamic> debtData =
              debtSnapshot.data() as Map<String, dynamic>;

          final debt = DebtDataModel.fromMap(debtData);
          await debtRepo.insertDebt(debt);
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }

  Future<void> uploadPockets(BuildContext context) async {
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String userEmail = getUserEmail() ?? 'example@gmail.com';

      DocumentReference pocketsCollectionRef =
          firestore.collection(userEmail).doc('userData');

      // Ellenőrzi, hogy van-e már 'Pockets' kollekció
      bool pocketsCollectionExists = (await pocketsCollectionRef.get()).exists;

      if (!pocketsCollectionExists) {
        // Ha nincs 'Pockets' kollekció, létrehozza
        await pocketsCollectionRef.set({
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      QuerySnapshot existingPockets =
          await pocketsCollectionRef.collection('Pockets').get();
      for (QueryDocumentSnapshot document in existingPockets.docs) {
        await document.reference.delete();
      }

      // Placeholder, helyettesítsd a saját logikáddal a pénztárcák lekérését
      final pocketRepo = PocketRepository();
      final pocketList = await pocketRepo.getPocketList();

      for (final pocket in pocketList) {
        await pocketsCollectionRef.collection('Pockets').add(pocket.toMap());
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }

  Future<void> downloadPockets(BuildContext context) async {
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
      await Firebase.initializeApp();

      bool userLoggedIn = true;

      if (userLoggedIn) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String userEmail = getUserEmail() ?? 'example@gmail.com';

        DocumentReference pocketsCollectionRef =
            firestore.collection(userEmail).doc('userData');

        final pocketRepo = PocketRepository();

        // Letölti a Firestore-ból a Pocket-eket
        QuerySnapshot pocketsCollection =
            await pocketsCollectionRef.collection('Pockets').get();

        // Törli a lokális repóból a Pocket-eket
        final localPockets = await pocketRepo.getPocketList();
        for (final pocket in localPockets) {
          await pocketRepo.deletePocket(pocket.id!);
        }

        // Betölti a letöltött Pocket-eket a repository-ba
        for (QueryDocumentSnapshot pocketSnapshot in pocketsCollection.docs) {
          Map<String, dynamic> pocketData =
              pocketSnapshot.data() as Map<String, dynamic>;

          final pocket = PocketDataModel.fromMap(pocketData);
          await pocketRepo.insertPocket(pocket);
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop();
  }
}
