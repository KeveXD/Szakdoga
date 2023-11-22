import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/viewmodel/new_payment_viewmodel.dart';
import 'package:flutter/material.dart';

class NewPaymentDialog extends StatefulWidget {
  final Function() onAddNewPayment;

  NewPaymentDialog({required this.onAddNewPayment});

  @override
  _NewPaymentDialogState createState() => _NewPaymentDialogState();
}

class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController pocketNameController = TextEditingController();

  late final NewPaymentViewModel viewModel;

  void _showNewPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Költség hozzáadása'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Cím'),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Megjegyzés'),
                ),
                DropdownButton<PaymentType>(
                  value: viewModel.selectedPaymentType,
                  items: PaymentType.values.map((PaymentType value) {
                    return DropdownMenuItem<PaymentType>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      viewModel.selectedPaymentType = value!;
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: viewModel.isDebt,
                      onChanged: (value) {
                        setState(() {
                          viewModel.isDebt = value!;
                        });
                      },
                    ),
                    Text('Tartozás'),
                  ],
                ),
                TextField(
                  controller: pocketNameController,
                  decoration: InputDecoration(labelText: 'Zseb név'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Összeg'),
                ),
                DropdownButton<String>(
                  value: viewModel.selectedCurrency,
                  items: <String>['HUF', 'EUR', 'GBP', 'USD', 'JPY', 'CHF']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      viewModel.selectedCurrency = value!;
                    });
                  },
                ),
                InkWell(
                  onTap: () {
                    viewModel.selectDate(context);
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: 'Dátum'),
                    ),
                  ),
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
                onPressed: () {
                  viewModel.addPayment(context);
                  widget.onAddNewPayment();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel = NewPaymentViewModel(onAddNewPayment: () {
      // Itt írd le azokat a lépéseket, amelyeket az onAddNewPayment meghívásakor kell végrehajtani
    });

    Future.delayed(Duration.zero, () {
      viewModel.init();
      _showNewPaymentDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
