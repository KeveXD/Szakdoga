import 'package:buxa/widgets/new_debt_dialog.dart';
import 'package:buxa/widgets/debt_list_item.dart';
import 'package:flutter/material.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/widgets/contact_card.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/view/person_page.dart';
import 'package:buxa/view/debt_details_page.dart';
import 'package:buxa/viewmodel/debt_viewmodel.dart';

class DebtPage extends StatefulWidget {
  @override
  _DebtPageState createState() => _DebtPageState();
}

class _DebtPageState extends State<DebtPage> {
  late Future<List<DebtDataModel>> _debtsFuture;
  final DebtViewModel _viewModel = DebtViewModel();

  @override
  void initState() {
    super.initState();
    _debtsFuture = _viewModel.getDebtList();
  }

  void _refreshDebts() {
    setState(() {
      _debtsFuture = _viewModel.getDebtList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C4787),
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
        title: Text('Tartozások'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ContactCard(
            name: "Keve",
            email: _viewModel.getUserEmail() ?? "keve.balla@gmail.com",
            hasDebt: true,
            imagePath: 'assets/profil.png',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'keresés...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DebtDataModel>>(
              future: _viewModel.getDebtList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hiba történt: ${snapshot.error}'));
                } else {
                  final debts = snapshot.data;

                  if (debts == null || debts.isEmpty) {
                    return Center(child: Text('Nincsenek adatok.'));
                  }

                  return ListView.builder(
                    itemCount: debts.length,
                    itemBuilder: (context, index) {
                      final debt = debts[index];
                      return DebtListItem(
                        debt: debt,
                        onDelete: () {
                          _refreshDebts();
                        },
                        onEdit: () => {},
                      );
                    },
                  );
                }
              },
            ),
          ),
          Desk(
            buttons: [
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.menu,
                title: 'Menü',
                function: () {
                  Navigator.pop(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.group,
                title: 'Szétosztás',
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DebtDetailsPage()),
                  );
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.person,
                title: 'Nevek',
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PersonPage()),
                  );
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.add,
                title: 'Új Tartozás',
                function: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NewDebtDialog(
                        onAddNewElement: () {
                          _refreshDebts();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DebtPage(),
  ));
}
