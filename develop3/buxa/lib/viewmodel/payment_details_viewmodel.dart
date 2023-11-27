import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/view/edit_payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPageViewModel {
  final PaymentDataModel payment;

  PaymentDetailsPageViewModel({required this.payment});

  Future<String> getPocketNameById(int id) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final pocketQuerySnapshot = await firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Pockets')
            .where('id', isEqualTo: id)
            .get();

        if (pocketQuerySnapshot.docs.isNotEmpty) {
          final pocketDoc = pocketQuerySnapshot.docs.first;
          final pocket = PocketDataModel.fromMap(pocketDoc.data()!);
          return pocket.name;
        } else {
          return 'No Pocket Found';
        }
      } else {
        // User not signed in
        return 'User not signed in';
      }
    } else {
      // Non-web platform, use local repository
      final pocketRepo = PocketRepository();
      final pocket = await pocketRepo.getPocketById(id);
      return pocket?.name ?? 'No Pocket Found';
    }
  }

  void showEditPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPaymentPage(
          onAddNewPayment: () {
            // Itt tudsz valamit tenni, ha a dialógus bezárásakor frissíteni kell az adatokat.
          },
          initialPayment: payment,
        );
      },
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
