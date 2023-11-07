import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/database/debt_repository.dart';

class DebtListItemModel {
  final DebtRepository _debtRepository = DebtRepository();

  Future<String> getDebtorName(int debtorPersonId) async {
    final debtorPerson = await PersonRepository().getPersonById(debtorPersonId);
    return debtorPerson?.name ?? 'N/A';
  }

  Future<String> getPersonToName(int personToId) async {
    final personTo = await PersonRepository().getPersonById(personToId);
    return personTo?.name ?? 'N/A';
  }
}
