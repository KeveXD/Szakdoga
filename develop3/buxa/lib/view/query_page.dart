import 'package:flutter/material.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/model/query_service.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/view/query_details_page.dart';

class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _pocketController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  bool _isExpenseSelected = false;
  bool _isIncomeSelected = false;

  DateTime? _startDate;
  DateTime? _endDate;

  final QueryService _queryService = QueryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lekérdezések'),
        backgroundColor: Color(0xFF00008577),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF3C4787),
              child: ListView(
                children: [
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _queryService.buildDatePicker(
                            context: context,
                            label: 'Listázás kezdődátuma:',
                            date: _startDate,
                            controller: _fromController,
                            onDateSelected: (date) {
                              if (date != null) {
                                setState(() {
                                  _startDate = date;
                                  _fromController.text =
                                      date.toLocal().toString().split(' ')[0];
                                });
                              }
                            },
                          ),
                          _queryService.buildDatePicker(
                            context: context,
                            label: 'Listázás végsődátuma:',
                            date: _endDate,
                            controller: _toController,
                            onDateSelected: (date) {
                              if (date != null) {
                                setState(() {
                                  _endDate = date;
                                  _toController.text =
                                      date.toLocal().toString().split(' ')[0];
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keresés összeg alapján:'),
                          TextField(
                            controller: _minAmountController,
                            decoration: InputDecoration(
                              labelText: 'Minimum összeg',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: _maxAmountController,
                            decoration: InputDecoration(
                              labelText: 'Maximum összeg',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cím alapján keresés:'),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'cím',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Válassz zsebet:'),
                          TextFormField(
                            controller: _pocketController,
                            decoration: InputDecoration(
                              labelText: 'Zseb',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _showPocketList(context, _pocketController);
                                },
                                icon: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Válassz bevétel vagy kiadás:'),
                          Row(
                            children: [
                              _queryService.buildToggleButton(
                                text: 'Költés',
                                isSelected: _isExpenseSelected,
                                onToggle: (selected) {
                                  setState(() {
                                    _isExpenseSelected = selected;
                                  });
                                },
                              ),
                              _queryService.buildToggleButton(
                                text: 'Bevétel',
                                isSelected: _isIncomeSelected,
                                onToggle: (selected) {
                                  setState(() {
                                    _isIncomeSelected = selected;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    color: Color(0xFFFFFFF9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Megjegyzés alapján keresés:'),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: 'megjegyzés',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                icon: Icons.arrow_right,
                title: 'Tovább',
                function: () {
                  // Az értékek beállítása a gombnyomás eseménykezelőjében
                  _queryService.startDate = _startDate;
                  _queryService.endDate = _endDate;
                  _queryService.minAmount =
                      double.tryParse(_minAmountController.text);
                  _queryService.maxAmount =
                      double.tryParse(_maxAmountController.text);
                  _queryService.pocketName = _pocketController.text;
                  _queryService.isExpense = _isExpenseSelected;
                  _queryService.isIncome = _isIncomeSelected;
                  _queryService.title = _titleController.text;
                  _queryService.comment = _commentController.text;

                  // Navigáció a QueryDetailsPage-re
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          QueryDetailsPage(queryService: _queryService),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getPocketNamesFromDatabase() async {
    final repository = PocketRepository();
    return repository.getAllPocketNames();
  }

  void _showPocketList(
      BuildContext context, TextEditingController controller) async {
    List<String> pocketNames = [];
    // await _getPocketNamesFromDatabase();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: pocketNames.map((pocketName) {
            return ListTile(
              title: Text(pocketName),
              onTap: () {
                setState(() {
                  controller.text = pocketName;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QueryPage(),
  ));
}
