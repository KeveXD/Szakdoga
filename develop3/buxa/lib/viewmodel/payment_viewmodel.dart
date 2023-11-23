import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/model/payment_model.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:flutter/material.dart';

class PaymentViewModel {
  final PaymentModel model = PaymentModel();
  late Future<List<PaymentDataModel>> paymentsFuture;

  PaymentViewModel(BuildContext context) {}

  Future<void> loadPayments(
      BuildContext context, PocketDataModel pocket) async {
    paymentsFuture = model.loadPayments(context, pocket);
  }

  Future<void> addNewPayment(Map<String, dynamic> data) {
    return model.addNewPayment(data);
  }
}
