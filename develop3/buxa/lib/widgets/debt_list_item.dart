import 'package:flutter/material.dart';
import 'package:buxa/database/debt_repository.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/viewmodel/debt_list_item_viewmodel.dart';

class DebtListItem extends StatelessWidget {
  final DebtDataModel debt;
  final DebtListItemViewModel viewModel = DebtListItemViewModel();
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  DebtListItem({
    required this.debt,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FutureBuilder<String>(
                      future: viewModel.loadDebtorName(debt.personToId ?? -1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final debtorPersonName =
                              snapshot.data ?? 'nincs személy';
                          return Text(
                            "$debtorPersonName ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          );
                        } else {
                          return Text("Loading...");
                        }
                      },
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    Text(
                      " ${debt.amount}Ft ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    FutureBuilder<String>(
                      future:
                          viewModel.loadPersonToName(debt.debtorPersonId ?? -1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final personToName = snapshot.data ?? 'nincs személy';
                          return Text(
                            " $personToName",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          );
                        } else {
                          return Text("Loading...");
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Kifizetve:"),
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        viewModel.deleteDebt(debt.id ?? -1).then((result) {
                          onDelete();
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
