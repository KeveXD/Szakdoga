import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentModel {
  Future<List<PaymentDataModel>> loadPayments(
      BuildContext context, PocketDataModel pocket) async {
    List<PaymentDataModel> paymentsList = [];

    if (kIsWeb) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final paymentsCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Payments');

          final paymentsQuerySnapshot = await paymentsCollectionRef.get();
          if (paymentsQuerySnapshot.docs.isNotEmpty) {
            paymentsList = paymentsQuerySnapshot.docs
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
      } finally {}
    } else {
      final repository = PaymentRepository();
      paymentsList = await repository.getPaymentList();
    }

    if (!pocket.special) {
      // Ha nem speciális a zseb, csak azokat a paymenteket listázzuk, amelyeknek a pocketName attribútuma megegyezik a pocket.name-al
      paymentsList = paymentsList
          .where((payment) => payment.pocketId == pocket.id)
          .toList();
    }

    return paymentsList;
  }
}
