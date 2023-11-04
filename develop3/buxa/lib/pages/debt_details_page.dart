import 'package:flutter/material.dart';
import 'package:buxa/widgets/debt_list_item.dart';
import 'package:buxa/data_model/debt_data_model.dart';
import 'package:buxa/view_models/debt_details_view_model.dart'; // Importáltuk a ViewModel osztályt

class DebtDetailsPage extends StatefulWidget {
  @override
  _DebtDetailsPageState createState() => _DebtDetailsPageState();
}

class _DebtDetailsPageState extends State<DebtDetailsPage> {
  late Future<List<DebtDataModel>> _debtsFuture;
  late DebtDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DebtDetailsViewModel();
    _debtsFuture = _viewModel.getCalculatedDebts();
  }

  void _refreshDebts() {
    setState(() {
      _debtsFuture = _viewModel.getCalculatedDebts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C4787),
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
        title: Text('Tartozások szétosztása'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<DebtDataModel>>(
              future: _debtsFuture,
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
                        onEdit: () {},
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DebtDetailsPage(),
  ));
}
