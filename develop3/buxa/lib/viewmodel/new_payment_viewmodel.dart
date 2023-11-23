import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/datepicker_widget.dart';
import 'package:flutter/material.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class NewPaymentViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCurrency = 'HUF';
  final TextEditingController dateController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  PaymentType selectedPaymentType = PaymentType.Income;
  bool isDebt = false;
  final TextEditingController pocketNameController = TextEditingController();
  List<PocketDataModel> pockets = [];
  List<DropdownMenuItem<int>> pocketDropdownItems = [];

  Function()? onAddNewPayment;

  NewPaymentViewModel();

  void init() {
    loadDropdownItems();
  }

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

    // datumot allitja be
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
    final pocketRepo = PocketRepository();

    // Ellenőrizze, hogy van-e már pénztárca a megadott névvel
    final existingPocket = await pocketRepo.getPocketByName(pocketName);

    if (existingPocket != null) {
      // Ha már létezik a pénztárca, akkor adja vissza az azonosítóját
      return existingPocket.id ?? 0;
    } else {
      // Ha még nem létezik a pénztárca, hozzon létre egy újat és adja vissza az azonosítóját
      final newPocket = PocketDataModel(name: pocketName, special: false);
      final newPocketId = await pocketRepo.insertPocket(newPocket);
      return newPocketId;
    }
  }

  Future<void> loadDropdownItems() async {
    pockets = await () async {
      final pocketDbHelper = PocketRepository();
      final pocketList = await pocketDbHelper.getPocketList();
      return pocketList.whereType<PocketDataModel>().toList();
    }();

    pocketDropdownItems = pockets
        .map(
          (pockets) => DropdownMenuItem<int>(
            value: pockets.id,
            child: Text(pockets.name),
          ),
        )
        .toList();
  }
}
