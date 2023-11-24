import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/datepicker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  NewPaymentViewModel({required this.onAddNewPayment});

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

    //final pocketId = await getOrCreatePocketId(pocketName);

    int pID = await getOrCreatePocketId(pocketName) ?? 0;
    final payment = PaymentDataModel(
      //id:
      date: date,
      title: title,
      comment: comment,
      type: type,
      isDebt: isDebt,
      pocketId: pID,
      amount: amount,
      currency: currency,
    );

    try {
      if (kIsWeb) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          var firestore;
          final firestoreInstance = FirebaseFirestore.instance;
          final userEmail = user.email;

          await firestoreInstance
              .collection(userEmail!)
              .doc('userData')
              .collection('Payments')
              .add(payment.toMap());
        } else {
          ErrorDialog.show(context, 'Nem vagy bejelentkezve.');
        }
      } else {
        final dbHelper = PaymentRepository();
        await dbHelper.insertPayment(payment);
        print("siker");
      }
    } catch (error) {
      ErrorDialog.show(context, 'Hiba történt a beszúrás közben: $error');
    }
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

  String? formatDate(DateTime? date) {
    return date?.toLocal().toString().split(' ')[0];
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

  Future<int?> getOrCreatePocketId(String pocketName) async {
    if (kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userEmail = user.email;

        final personQuerySnapshot = await firestore
            .collection(userEmail!)
            .doc('userData')
            .collection('Pockets')
            .where('name', isEqualTo: pocketName)
            .get();

        if (personQuerySnapshot.docs.isNotEmpty) {
          final personDoc = personQuerySnapshot.docs.first;
          PocketDataModel p = PocketDataModel.fromMap(personDoc.data()!);
          return p.id;
        }
      }
      return 0;
    } else {
      final pocketRepo = PocketRepository();

      // Ellenőrizze, hogy van-e már pénztárca a megadott névvel
      final existingPocket = await pocketRepo.getPocketByName(pocketName);

      if (existingPocket != null) {
        // Ha már létezik a pénztárca, akkor adja vissza az azonosítóját
        return existingPocket.id ?? 0;
      } else {
        //Ha még nem létezik a pénztárca, hozzon létre egy újat és adja vissza az azonosítóját
        final newPocket = PocketDataModel(name: pocketName, special: false);
        final newPocketId = await pocketRepo.insertPocket(newPocket);
        return 0; //newPocketId;
      }
      return 0;
    }
  }

  Future<int> generateUniqueId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final userEmail = user.email;

      final peopleCollectionRef =
          firestore.collection(userEmail!).doc('userData').collection('Debts');
      int uniqueId;

      // Keresd meg a legnagyobb id-t a Firestore-ban
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await peopleCollectionRef
              .orderBy('id', descending: true)
              .limit(1)
              .get();

      // Ha vannak dokumentumok, használd azokat, különben kezdd az id-t 1-től
      if (querySnapshot.docs.isNotEmpty) {
        final int highestId = querySnapshot.docs.first['id'];
        uniqueId = highestId + 1;
      } else {
        // Ha nincsenek dokumentumok, kezd el az id-t 1-től
        uniqueId = 1;
      }

      // Ellenőrizd, hogy az újonnan generált id még nincs használatban
      bool idExists;

      do {
        final snapshot =
            await peopleCollectionRef.where('id', isEqualTo: uniqueId).get();

        idExists = snapshot.docs.isNotEmpty;

        // Ha az id már létezik, növeld meg és ellenőrizd újra
        if (idExists) {
          uniqueId++;
        }
      } while (idExists);

      return uniqueId;
    }
    return 0;
  }
}
