import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buxa/view/debt_page.dart';
import 'package:buxa/view/pocket_page.dart';
import 'package:buxa/view/query_page.dart';
import 'package:buxa/widgets/error_dialog.dart';

class MenuPageViewModel {
  MenuPageViewModel();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> download(BuildContext context) async {
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

        // Ellenőrizd, hogy a kollekció már létezik-e
        DocumentReference userCollectionRef =
            firestore.collection(userEmail).doc('userData');
        DocumentSnapshot userCollection = await userCollectionRef.get();

        if (!userCollection.exists) {
          // Ha még nincs ilyen kollekció, akkor hozd létre
          await userCollectionRef.set({
            'created_at': FieldValue
                .serverTimestamp(), // A kollekció létrehozásának ideje
          });

          // Mostantól a 'userEmail' névvel egy kollekció van a Firestore adatbázisban
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Távolítsa el a töltési karikát
      ErrorDialog.show(context, 'Hiba történt: $error');
    }

    Navigator.of(context).pop(); // Távolítsa el a töltési karikát
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
}
