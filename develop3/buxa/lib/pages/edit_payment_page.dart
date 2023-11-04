import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/services/new_payment_dialog_service.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EditPaymentPage extends StatefulWidget {
  final Function() onAddNewPayment;
  final PaymentDataModel initialPayment;

  EditPaymentPage({
    required this.onAddNewPayment,
    required this.initialPayment,
  });

  @override
  _EditPaymentPageState createState() => _EditPaymentPageState();
}

class _EditPaymentPageState extends State<EditPaymentPage> {
  final NewPaymentDialogService service = NewPaymentDialogService();

  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController commentController;
  late TextEditingController pocketNameController;

  String selectedCurrency = 'USD';
  PaymentType selectedPaymentType = PaymentType.Income;
  bool isDebt = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialPayment.title);
    amountController =
        TextEditingController(text: widget.initialPayment.amount.toString());
    dateController = TextEditingController(
        text: DateFormat.yMMMd().format(widget.initialPayment.date));
    commentController =
        TextEditingController(text: widget.initialPayment.comment);
    pocketNameController = TextEditingController(text: 'Pocket1');
    selectedCurrency = widget.initialPayment.currency;
    selectedPaymentType = widget.initialPayment.type;
    isDebt = widget.initialPayment.isDebt;
  }

  void _updatePayment() async {
    final date = DateFormat.yMMMd().parse(dateController.text);
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

    final updatedPayment = PaymentDataModel(
      id: widget.initialPayment.id,
      date: date,
      title: title,
      comment: comment,
      type: type,
      isDebt: isDebt,
      pocketId: pocketId,
      amount: amount,
      currency: currency,
    );

    // Call the repository method to update the payment
    PaymentRepository().updatePayment(updatedPayment).then((result) {
      if (result > 0) {
        widget.onAddNewPayment();
      }
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: titleController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Comment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: commentController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter comment',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
              isExpanded: true,
            ),
            SizedBox(height: 16),
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
                Text(
                  'Is Debt',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Pocket Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: pocketNameController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter pocket name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: amountController,
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Currency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
              isExpanded: true,
            ),
            SizedBox(height: 16),
            Text(
              'Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                _showDatePicker();
              },
              child: IgnorePointer(
                child: TextField(
                  controller: dateController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Select date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                child: Text('Cancel', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('Update', style: TextStyle(fontSize: 16)),
                onPressed: _updatePayment,
              ),
            ],
          ),
        ),
      ),
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
        dateController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }
}
