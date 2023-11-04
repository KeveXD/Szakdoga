import 'package:flutter/material.dart';
import 'package:buxa/database/person_repository.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';

class NewPersonDialog extends StatefulWidget {
  final VoidCallback onAddNewPerson;

  NewPersonDialog({required this.onAddNewPerson});

  @override
  _NewPersonDialogState createState() =>
      _NewPersonDialogState(onAddNewPerson: onAddNewPerson);
}

class _NewPersonDialogState extends State<NewPersonDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _hasRevolut = false;
  final VoidCallback onAddNewPerson;

  _NewPersonDialogState({required this.onAddNewPerson});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showNewPersonDialog();
    });
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
                controller: nameController,
                decoration: InputDecoration(labelText: 'Név'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              Row(
                children: [
                  Text('Van Revolutja?'),
                  Switch(
                    value: _hasRevolut,
                    onChanged: (value) {
                      setState(() {
                        _hasRevolut = value;
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
                if (nameController.text.isEmpty) {
                  ErrorDialog.show(context, 'A nevet kötelező megadni');
                } else {
                  final newPerson = PersonDataModel(
                    name: nameController.text,
                    email: emailController.text,
                    hasRevolut: _hasRevolut,
                  );

                  final dbHelper = PersonRepository();
                  final id = await dbHelper.insertPerson(newPerson);
                  newPerson.id = id;

                  onAddNewPerson();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
