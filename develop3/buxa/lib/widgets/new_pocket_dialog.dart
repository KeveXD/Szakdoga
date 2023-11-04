import 'package:flutter/material.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/widgets/error_dialog.dart';

class NewPocketDialog extends StatefulWidget {
  final VoidCallback onAddNewPocket;

  NewPocketDialog({required this.onAddNewPocket});

  @override
  _NewPocketDialogState createState() =>
      _NewPocketDialogState(onAddNewPocket: onAddNewPocket);
}

class _NewPocketDialogState extends State<NewPocketDialog> {
  final TextEditingController nameController = TextEditingController();
  final VoidCallback onAddNewPocket;

  _NewPocketDialogState({required this.onAddNewPocket});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showNewPocketDialog();
    });
  }

  void _showNewPocketDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Új Zseb hozzáadása'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Név'),
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
                  final newPocket = PocketDataModel(name: nameController.text);

                  final dbHelper = PocketRepository();
                  final id = await dbHelper.insertPocket(newPocket);
                  newPocket.id = id;

                  onAddNewPocket();

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
