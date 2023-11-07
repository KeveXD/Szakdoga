import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/model/debt_list_item_model.dart';

class DebtListItemViewModel {
  final DebtListItemModel model = DebtListItemModel();

  Future<String> loadDebtorName(int debtorPersonId) async {
    return model.getDebtorName(debtorPersonId);
  }

  Future<String> loadPersonToName(int personToId) async {
    return model.getPersonToName(personToId);
  }
}
