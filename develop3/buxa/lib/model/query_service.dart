import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/viewmodel/payment_viewmodel.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/payment_list_item.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';

class QueryService {
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;
  String? pocketName;
  bool? isExpense;
  bool? isIncome;
  String? title;
  String? comment;

  List<PaymentDataModel> paymentsList = [];

  Widget buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required TextEditingController controller,
    required Function(DateTime?) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            ).then((date) {
              if (date != null) {
                onDateSelected(date);
              }
            });
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(label),
              ),
              Spacer(),
              Text(
                _formatDate(date) ?? 'Válassz dátumot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildToggleButton({
    required String text,
    required bool isSelected,
    required Function(bool) onToggle,
  }) {
    return TextButton(
      onPressed: () {
        onToggle(!isSelected);
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  String? _formatDate(DateTime? date) {
    return date?.toLocal().toString().split(' ')[0];
  }

  Future<List<PaymentDataModel>> loadFromDatabase() async {
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
            //ErrorDialog.show(context, 'Nincsenek adatok a Firestore-ban.');
          }
        } else {
          //ErrorDialog.show(context, 'Nem vagy bejelentkezve.');
        }
      } catch (error) {
        //ErrorDialog.show(context, 'Hiba történt: $error');
      } finally {
        //Navigator.of(context).pop(); // Töltő ikon eltávolítása
      }
    } else {
      final repository = PaymentRepository();
      paymentsList = await repository.getPaymentList();
    }

    if (paymentsList.isEmpty) {
      //ErrorDialog.show(context, 'Nincsenek adatok a helyi adatbázisban.');
    }

    return paymentsList;
  }

  Future<List<PaymentDataModel>> calculatePayments() async {
    final payments = await loadFromDatabase();

    PocketDataModel? pocketPocket;

    if (pocketName != null) {
      if (kIsWeb) {
        // Firebase-ről lekérés weben
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final personQuerySnapshot = await firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Pockets')
              .where('name', isEqualTo: pocketName)
              .get();

          if (personQuerySnapshot.docs.isNotEmpty) {
            final personDoc = personQuerySnapshot.docs.first;
            pocketPocket = PocketDataModel.fromMap(personDoc.data()!);
          }
        }
      } else {
        // Lokális adatbázisból lekérés mobilalkalmazásban
        final pocketRepo = PocketRepository();
        pocketPocket = await pocketRepo.getPocketByName(pocketName!);
      }
    }

    final filteredPayments = payments.where((payment) {
      // Dátum ellenőrzés
      if (startDate != null && payment.date.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && payment.date.isAfter(endDate!)) {
        return false;
      }
      // Egyéb feltételek
      if (minAmount != null && payment.amount < minAmount!) {
        return false;
      }
      if (maxAmount != null && payment.amount > maxAmount!) {
        return false;
      }

      if (title != null && title!.isNotEmpty) {
        if (!payment.title.toLowerCase().contains(title!.toLowerCase())) {
          return false;
        }
      }

      if (comment != null && comment!.isNotEmpty) {
        if (!payment.comment.toLowerCase().contains(comment!.toLowerCase())) {
          return false;
        }
      }

      if (pocketName != null && pocketPocket != null) {
        if (payment.pocketId != pocketPocket.id) {
          return false;
        }
      }

      if (isExpense != null &&
          isExpense != (payment.type == PaymentType.Expense)) {
        return false;
      }

      if (isIncome != null &&
          isIncome != (payment.type == PaymentType.Income)) {
        return false;
      }
      return true;
    }).toList();

    return filteredPayments;
  }
}
