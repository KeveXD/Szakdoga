import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EditPaymentViewModel {
  Future<int> updatePayment(PaymentDataModel updatedPayment) async {
    print("lol");
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
          print("hewwww");

          // Ellenőrizd, hogy van-e már ilyen id-jú dokumentum
          final existingDocument = await paymentsCollectionRef
              .doc(updatedPayment.id.toString())
              .get();

          if (existingDocument.exists) {
            // Ha létezik, akkor töröld
            await paymentsCollectionRef
                .doc(updatedPayment.id.toString())
                .delete();
          }

          // Most tedd hozzá az új dokumentumot
          await paymentsCollectionRef
              .doc(updatedPayment.id.toString())
              .set(updatedPayment.toMap());
        } else {
          print('Nem vagy bejelentkezve.');
        }
      } catch (e) {
        print('Hiba történt a fizetés frissítése közben: $e');
        return 0;
      }
    } else {
      return await PaymentRepository().updatePayment(updatedPayment);
    }

    return 0;
  }
}
