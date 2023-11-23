import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class PaymentModel {
  Future<List<PaymentDataModel>> loadPayments(
      BuildContext context, PocketDataModel pocket) async {
    List<PaymentDataModel> peopleList = [];

    if (kIsWeb) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Payments');

          final peopleQuerySnapshot = await peopleCollectionRef.get();
          if (peopleQuerySnapshot.docs.isNotEmpty) {
            peopleList = peopleQuerySnapshot.docs
                .map((doc) => PaymentDataModel.fromMap(doc.data()))
                .toList();
          } else {
            ErrorDialog.show(context, 'Nincsenek adatok a Firestore-ban.');
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
      final repository = PaymentRepository();
      peopleList = await repository.getPaymentList();

      if (peopleList.isEmpty) {
        // ErrorDialog.show(context, 'Nincsenek adatok a helyi adatbázisban.');
      }
    }

    return peopleList;
  }

  Future<void> addNewPayment(Map<String, dynamic> data) async {
    // Új befizetés hozzáadása Firestore-ba
    try {
      await firestore.FirebaseFirestore.instance
          .collection('userData') // Módosítsd a Firestore struktúrádhoz
          .doc(data['userId'])
          .collection('Pockets')
          .doc(data['pocketId'])
          .collection('Payments')
          .add(data);
    } catch (error) {
      // Kezelheted a hibát itt
      print('Hiba történt az új befizetés hozzáadása közben: $error');
    }
  }
}
