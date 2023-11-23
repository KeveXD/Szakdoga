import 'package:flutter/material.dart';
import 'package:buxa/viewmodel/new_pocket_viewmodel.dart';

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
  late final NewPocketViewModel viewModel;

  _NewPocketDialogState({required this.onAddNewPocket});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showNewPocketDialog(context); // Pass the context here
    });
  }

  void _showNewPocketDialog(BuildContext context) {
    // Receive the context here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        viewModel = NewPocketViewModel(context: context);
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
                viewModel.addNewPocket(nameController.text,
                    onAddNewPocket); // Pass context to the viewModel
                Navigator.of(context).pop();
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
