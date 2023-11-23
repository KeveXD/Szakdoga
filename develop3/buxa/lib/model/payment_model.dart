import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:flutter/material.dart';

class PaymentModel {
  Future<List<PaymentDataModel>> loadPayments(
      BuildContext context, PocketDataModel pocket) async {
    final repository = PaymentRepository();
    if (pocket.special) {
      return repository.getPaymentList();
    } else {
      return PaymentRepository().getPaymentsByPocket(pocket.name);
    }
  }

  Future<void> addNewPayment(Map<String, dynamic> data) async {}
}
