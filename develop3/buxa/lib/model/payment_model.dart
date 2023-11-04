import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PaymentPageModel {
  final PocketDataModel pocket;

  PaymentPageModel({required this.pocket});

  Future<List<PaymentDataModel>> loadPayments() async {
    if (pocket.special) {
      return PaymentRepository().getPaymentList();
    } else {
      return PaymentRepository().getPaymentsByPocket(pocket.name);
    }
  }

  // Implementálhatod további model funkciókat itt

  // Például egy új befizetés hozzáadása:
  Future<void> addNewPayment(Map<String, dynamic> data) async {
    // Implementálj hozzáadási logikát és hívás a repositoryban
  }
}
