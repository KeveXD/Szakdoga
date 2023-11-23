import 'package:flutter/material.dart';
import 'package:buxa/viewmodel/new_debt_dialog_viewmodel.dart';

class NewDebtDialog extends StatefulWidget {
  final VoidCallback onAddNewElement;

  NewDebtDialog({required this.onAddNewElement});

  @override
  _NewDebtDialogState createState() =>
      _NewDebtDialogState(onAddNewElement: onAddNewElement);
}

class _NewDebtDialogState extends State<NewDebtDialog> {
  final NewDebtDialogViewModel viewModel = NewDebtDialogViewModel();
  final VoidCallback onAddNewElement;
  //final TextEditingController nameController = TextEditingController();
  //final TextEditingController debtorNameController = TextEditingController();

  _NewDebtDialogState({required this.onAddNewElement});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      viewModel.loadDropdownItems();
      _showNewDebtDialog();
    });
  }

  void _showNewDebtDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Új adósság hozzáadása'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: viewModel.nameController,
                        decoration: InputDecoration(labelText: 'Ki'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showPersonList(context, viewModel.nameController);
                      },
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: viewModel.debtorNameController,
                        decoration: InputDecoration(labelText: 'Kinek'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showPersonList(
                            context, viewModel.debtorNameController);
                      },
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
                TextFormField(
                  controller: viewModel.amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Összeg'),
                ),
                Row(
                  children: [
                    Text('Van-e Revolutja?'),
                    Switch(
                      value: viewModel.hasRevolut,
                      onChanged: (value) {
                        setState(() {
                          viewModel.hasRevolut = value;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Leírás'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Mégse'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hozzáadás'),
              onPressed: () {
                viewModel.addNewDebt(
                  context,
                  onAddNewElement,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showPersonList(BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: viewModel.persons.map((person) {
            return ListTile(
              title: Text(person.name),
              onTap: () {
                setState(() {
                  controller.text = person.name;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
