import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/datepicker_widget.dart';
import 'package:flutter/material.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/widgets/error_dialog.dart';

class NewPaymentViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCurrency = 'HUF';
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  PaymentType selectedPaymentType = PaymentType.Income;
  bool isDebt = false;
  final TextEditingController pocketNameController = TextEditingController();

  Function()? onAddNewPayment;

  NewPaymentViewModel({required this.onAddNewPayment});

  void init() {}

  Future<void> addPayment(BuildContext context) async {
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

    // Logika a kiválasztott dátum beállítására
    await selectDate(context);

    final pocketId = await getOrCreatePocketId(pocketName);

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

    final dbHelper = PaymentRepository();

    try {
      final id = await dbHelper.insertPayment(payment);
      //Navigator.of(context).pop(); // Töltő ikon eltávolítása
      print("siker");
    } catch (error) {
      // Navigator.of(context).pop(); // Töltő ikon eltávolítása
      ErrorDialog.show(context, 'Hiba történt a beszúrás közben: $error');
    }
    // Logika az új fizetés hozzáadásához
    onAddNewPayment?.call();
  }

  Future<void> selectDate(BuildContext context) async {
    // Dátumválasztó megjelenítése és kiválasztott dátum beállítása
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      dateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        // Esetlegesen más input mezők...
        DatePickerWidget(
          label: 'Dátum',
          date: DateTime.parse(dateController.text),
          controller: dateController,
          onDateSelected: (date) {
            dateController.text = formatDate(date) ?? '';
          },
        ),
      ],
    );
  }

  String? formatDate(DateTime? date) {
    return date?.toLocal().toString().split(' ')[0];
  }

  Future<int> getOrCreatePocketId(String pocketName) async {
    // Zsebazonosító lekérdezése vagy létrehozása
    return 1; // Példa érték, itt a valós logikát kell beilleszteni
  }
}
