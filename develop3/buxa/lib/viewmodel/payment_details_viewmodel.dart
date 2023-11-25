import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/view/edit_payment_page.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPageViewModel {
  final PaymentDataModel payment;

  PaymentDetailsPageViewModel({required this.payment});

  Future<String> getPocketNameById(int id) async {
    final pocketRepo = PocketRepository();
    final pocket = await pocketRepo.getPocketById(id);
    return pocket?.name ?? 'No Pocket Found';
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
