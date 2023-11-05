import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/model/new_payment_dialog_service.dart';

class NewPaymentDialog extends StatefulWidget {
  final Function() onAddNewPayment;

  NewPaymentDialog({required this.onAddNewPayment});

  @override
  _NewPaymentDialogState createState() =>
      _NewPaymentDialogState(onAddNewPayment: onAddNewPayment);
}

class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final NewPaymentDialogService service = NewPaymentDialogService();

  _NewPaymentDialogState({required this.onAddNewPayment});

  final Function() onAddNewPayment;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCurrency = 'USD'; // Alapértelmezett deviza
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  PaymentType selectedPaymentType = PaymentType.Income;
  bool isDebt = false;
  final TextEditingController pocketNameController = TextEditingController();

  void _showNewPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add New Payment'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Comment'),
                ),
                DropdownButton<PaymentType>(
                  value: selectedPaymentType,
                  items: PaymentType.values.map((PaymentType value) {
                    return DropdownMenuItem<PaymentType>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentType = value!;
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: isDebt,
                      onChanged: (value) {
                        setState(() {
                          isDebt = value!;
                        });
                      },
                    ),
                    Text('Is Debt'),
                  ],
                ),
                TextField(
                  controller: pocketNameController,
                  decoration: InputDecoration(labelText: 'Pocket Name'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                DropdownButton<String>(
                  value: selectedCurrency,
                  items: <String>['USD', 'EUR', 'GBP', 'HUF', 'JPY', 'CHF']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value!;
                    });
                  },
                ),
                InkWell(
                  onTap: () {
                    _showDatePicker();
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  _addPayment;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _addPayment() async {
    final date = dateController.text.isNotEmpty
        ? DateTime.parse(dateController.text)
        : DateTime.now();
    final title =
        titleController.text.isNotEmpty ? titleController.text : 'valami';
    final comment =
        commentController.text.isNotEmpty ? commentController.text : 'komi';
    final type = selectedPaymentType;
    final pocketName = pocketNameController.text.isNotEmpty
        ? pocketNameController.text
        : 'Pocket1';
    final amount = amountController.text.isNotEmpty
        ? double.parse(amountController.text)
        : 1000.0;
    final currency = selectedCurrency;

    final pocketId = await service.getOrCreatePocketId(pocketName);

    final payment = PaymentDataModel(
      date: date,
      title: title,
      comment: comment,
      type: type,
      isDebt: isDebt,
      pocketId: pocketId,
      amount: amount,
      currency: currency,
    );

    PaymentRepository().insertPayment(payment).then((result) {
      if (result > 0) {
        onAddNewPayment();
      }
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showNewPaymentDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
