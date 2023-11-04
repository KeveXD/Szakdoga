import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/services/debt_details_model.dart';

class DebtDetailsViewModel {
  final DebtDetailsModel _debtDetailsModel = DebtDetailsModel();

  Future<List<DebtDataModel>> getCalculatedDebts() {
    return _debtDetailsModel.calculateDebts();
  }
}
