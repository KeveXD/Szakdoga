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
import 'package:buxa/database/debt_repository.dart';

class MenuPageViewModel {
  MenuPageViewModel();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  void upload(BuildContext context) {
    uploadPeopleAndInitialize(context);
    uploadDebts(context);
  }

  void download(BuildContext context) {
    downloadPeople(context);
    downloadDebts(context);
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
      // Inicializáld a Firebase Core-t
      await Firebase.initializeApp();

      // Ellenőrizd, hogy a felhasználó be van-e jelentkezve (ez csak egy példa, a bejelentkezéstől függ)
      // Például a Firebase Authentication használatakor ellenőrizd a bejelentkezési állapotot.
      bool userLoggedIn =
          true; // Példa, itt a bejelentkezési állapotot kell ellenőrizni

      if (userLoggedIn) {
        // A Firestore adatbázis hivatkozása
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Az aktuális felhasználó e-mail címe (példa)
        String userEmail = getUserEmail() ?? 'example@gmail.com';

        // Az "People" kollekció referenciája
        CollectionReference peopleCollectionRef = firestore
            .collection(userEmail)
            .doc('userData')
            .collection('People');

        // Töröld a lokális adatbázist összes Person rekorddal
        final personRepo = PersonRepository();
        final localPeople = await personRepo.getPersonList();
        for (final person in localPeople) {
          await personRepo.deletePerson(person.id!);
        }

        // Az összes dokumentum lekérése a "People" kollekcióból
        QuerySnapshot peopleCollection = await peopleCollectionRef.get();

        // Itt tudod feldolgozni az összes dokumentumot és menteni a helyi adatbázisba
        for (QueryDocumentSnapshot personSnapshot in peopleCollection.docs) {
          // Példa: a dokumentum adatainak lekérése
          Map<String, dynamic> personData =
              personSnapshot.data() as Map<String, dynamic>;

          // Példa: a dokumentumok létrehozása a helyi adatbázisban
          final person = PersonDataModel.fromMap(personData);
          await personRepo.insertPerson(person);
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Távolítsa el a töltési karikát
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop(); // Távolítsa el a töltési karikát
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
      // A Firestore adatbázis hivatkozása
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Az aktuális felhasználó e-mail címe
      String userEmail = getUserEmail() ?? 'example@gmail.com';

      // Ellenőrizd, hogy a kollekció már létezik-e
      DocumentReference userCollectionRef =
          firestore.collection(userEmail).doc('userData');
      DocumentSnapshot userCollection = await userCollectionRef.get();

      if (!userCollection.exists) {
        // Ha még nincs ilyen kollekció, akkor hozd létre
        await userCollectionRef.set({
          'created_at':
              FieldValue.serverTimestamp(), // A kollekció létrehozásának ideje
        });
      }

      // Az "People" kollekció referenciája
      CollectionReference peopleCollectionRef =
          userCollectionRef.collection('People');

      // Töröld az összes dokumentumot a "People" kollekcióból
      QuerySnapshot existingPeople = await peopleCollectionRef.get();
      for (QueryDocumentSnapshot document in existingPeople.docs) {
        await document.reference.delete();
      }

      // Felhasználói adatok lekérése az SQLite adatbázisból (példa)
      final personRepo = PersonRepository();
      final personList = await personRepo.getPersonList();

      // A felhasználó "People" kollekciójába feltöltés
      for (final person in personList) {
        await peopleCollectionRef.add(person.toMap());
      }
    } catch (error) {
      Navigator.of(context).pop(); // Töltési karika eltávolítása
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop(); // Töltési karika eltávolítása
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
      // Firebase Firestore inicializáció
      await Firebase.initializeApp();

      // Firebase Firestore adatbázis hivatkozása
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Az aktuális felhasználó e-mail címe (példa)
      String userEmail = getUserEmail() ?? 'example@gmail.com';

      // "Debts" nevű dokumentum referenciája
      DocumentReference debtsCollectionRef =
          firestore.collection(userEmail).doc('userData');

      // Töröld az összes dokumentumot a "Debts" dokumentumból
      QuerySnapshot existingDebts =
          await debtsCollectionRef.collection('Debts').get();
      for (QueryDocumentSnapshot document in existingDebts.docs) {
        await document.reference.delete();
      }

      // Tartozások lekérése a helyi adatbázisból (példa)
      final debtRepo = DebtRepository();
      final debtList = await debtRepo.getDebtList();

      // A "Debts" dokumentumba feltöltés
      for (final debt in debtList) {
        await debtsCollectionRef.collection('Debts').add(debt.toMap());
      }
    } catch (error) {
      Navigator.of(context).pop(); // Távolítsd el a töltési karikát
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop(); // Távolítsd el a töltési karikát
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
      // Firebase Firestore inicializáció
      await Firebase.initializeApp();

      // Ellenőrizd, hogy a felhasználó be van-e jelentkezve (a bejelentkezési állapottól függően)
      bool userLoggedIn =
          true; // Példa, itt a bejelentkezési állapotot kell ellenőrizni

      if (userLoggedIn) {
        // Firebase Firestore adatbázis hivatkozása
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Az aktuális felhasználó e-mail címe (példa)
        String userEmail = getUserEmail() ?? 'example@gmail.com';

        // "Debts" nevű dokumentum referenciája
        DocumentReference debtsCollectionRef =
            firestore.collection(userEmail).doc('userData');

        // Töröld a lokális adatbázist az összes tartozással
        final debtRepo = DebtRepository();
        final localDebts = await debtRepo.getDebtList();
        for (final debt in localDebts) {
          await debtRepo.deleteDebt(debt);
        }

        // Az összes dokumentum lekérése a "Debts" dokumentumból
        QuerySnapshot debtsCollection =
            await debtsCollectionRef.collection('Debts').get();

        // Itt tudod feldolgozni az összes dokumentumot és menteni a helyi adatbázisba
        for (QueryDocumentSnapshot debtSnapshot in debtsCollection.docs) {
          // Példa: a dokumentum adatainak lekérése
          Map<String, dynamic> debtData =
              debtSnapshot.data() as Map<String, dynamic>;

          // Példa: a dokumentumok létrehozása a helyi adatbázisban
          final debt = DebtDataModel.fromMap(debtData);
          await debtRepo.insertDebt(debt);
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Távolítsd el a töltési karikát
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop(); // Távolítsd el a töltési karikát
  }
}
