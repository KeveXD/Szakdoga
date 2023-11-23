import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/viewmodel/new_payment_viewmodel.dart';
import 'package:flutter/material.dart';

class NewPaymentDialog extends StatefulWidget {
  final VoidCallback onAddNewPayment;

  NewPaymentDialog({required this.onAddNewPayment});

  @override
  _NewPaymentDialogState createState() =>
      _NewPaymentDialogState(onAddNewPayment: onAddNewPayment);
}

class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final VoidCallback onAddNewPayment;
  final NewPaymentViewModel viewModel = NewPaymentViewModel();

  _NewPaymentDialogState({required this.onAddNewPayment});

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _showNewPaymentDialog();
    });
  }

  void _showNewPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // A StatefulBuilder használatával újraépíthetjük a dialógus ablakot
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Költség hozzáadása'),
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: viewModel.titleController,
                      decoration: InputDecoration(labelText: 'Cím'),
                    ),
                    TextField(
                      controller: viewModel.commentController,
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
                      controller: viewModel.pocketNameController,
                      decoration: InputDecoration(labelText: 'Zseb név'),
                    ),
                    TextField(
                      controller: viewModel.amountController,
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
                          controller: viewModel.dateController,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
