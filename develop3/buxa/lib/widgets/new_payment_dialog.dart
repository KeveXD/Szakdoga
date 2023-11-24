import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/viewmodel/new_payment_viewmodel.dart';

class NewPaymentDialog extends StatefulWidget {
  final VoidCallback onAddNewPayment;

  NewPaymentDialog({required this.onAddNewPayment});

  @override
  _NewPaymentDialogState createState() =>
      _NewPaymentDialogState(onAddNewPayment: onAddNewPayment);
}

class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final NewPaymentViewModel viewModel;
  final VoidCallback onAddNewPayment;

  _NewPaymentDialogState({required this.onAddNewPayment})
      : viewModel = NewPaymentViewModel(onAddNewPayment: onAddNewPayment);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //viewModel.loadDropdownItems();
      _showNewPaymentDialog(context);
    });
  }

  void _showNewPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: viewModel.pocketNameController,
                            decoration: InputDecoration(labelText: 'Zseb'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showPocketList(
                                context, viewModel.pocketNameController);
                          },
                          child: Icon(Icons.arrow_drop_down),
                        ),
                      ],
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
                      viewModel.addPayment(context, onAddNewPayment);
                      //widget.onAddNewPayment();
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

  void _showPocketList(BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: viewModel.pockets.map((person) {
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
}
