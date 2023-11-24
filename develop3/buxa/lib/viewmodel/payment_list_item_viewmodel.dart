import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buxa/view/payment_details_page.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:flutter/foundation.dart';

class PaymentListItemViewModel {
  Future<int> deletePayment(int id) async {
    if (kIsWeb) {
      try {
        final firestore = FirebaseFirestore.instance;
        final user = FirebaseAuth.instance.currentUser;
        String? userEmail;

        if (user != null) {
          userEmail = user.email;
          final paymentsCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Payments');

          final paymentQuerySnapshot =
              await paymentsCollectionRef.where('id', isEqualTo: id).get();
          if (paymentQuerySnapshot.docs.isNotEmpty) {
            final paymentDocRef = paymentQuerySnapshot.docs.first.reference;
            await paymentDocRef.delete();
          } else {
            print('A $id azonosítójú fizetés nem található a Firestore-ban.');
          }
        } else {
          print('Nem vagy bejelentkezve.');
        }
      } catch (e) {
        print('Hiba történt a fizetés törlése közben: $e');
      }
    } else {
      print('A $id azonosítójú fizetés törölveeee');
      final PaymentRepository _repository = PaymentRepository();
      return await _repository.deletePayment(id);
    }

    return 0;
  }

  void navigateToPaymentDetailsPage(
      BuildContext context, PaymentDataModel payment) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PaymentDetailsPage(payment: payment),
    ));
  }
}
