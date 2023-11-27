import 'package:flutter/material.dart';
import 'package:buxa/viewmodel/new_person_viewmodel.dart';

class NewPersonDialog extends StatefulWidget {
  final VoidCallback onAddNewPerson;

  NewPersonDialog({required this.onAddNewPerson});

  @override
  NewPersonDialogState createState() =>
      NewPersonDialogState(onAddNewPerson: onAddNewPerson);
}

class NewPersonDialogState extends State<NewPersonDialog> {
  final NewPersonViewModel viewModel;

  NewPersonDialogState({required VoidCallback onAddNewPerson})
      : viewModel = NewPersonViewModel(onAddNewPerson: onAddNewPerson);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _showNewPersonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Új Személy hozzáadása'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: viewModel.nameController,
                decoration: InputDecoration(labelText: 'Név'),
              ),
              TextField(
                controller: viewModel.emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              Row(
                children: [
                  Text('Van Revolutja?'),
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
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Mégsem'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hozzáad'),
              onPressed: () async {
                viewModel.addNewPerson(context);
                widget.onAddNewPerson();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _showNewPersonDialog();
  }
}
