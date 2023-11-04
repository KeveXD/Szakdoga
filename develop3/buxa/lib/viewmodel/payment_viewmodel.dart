import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/model/payment_model.dart';

class PaymentPageViewModel {
  final PaymentPageModel model;
  late Future<List<PaymentDataModel>> paymentsFuture;

  PaymentPageViewModel({required this.model});

  Future<void> loadPayments() async {
    paymentsFuture = model.loadPayments();
  }

  Future<void> refreshPayments() {
    return loadPayments();
  }

  Future<void> addNewPayment(Map<String, dynamic> data) {
    // Implementálj hozzáadási logikát a model használatával
    return model.addNewPayment(data);
  }
}
