import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class NewPaymentDialogService {
//hasznalatban

  Future<int> getOrCreatePocketId(String pocketName) async {
    final pocketRepo = PocketRepository();
    final existingPocket = await pocketRepo.getPocketByName(pocketName);
    if (existingPocket != null) {
      return existingPocket.id ?? 0;
    } else {
      final newPocket = PocketDataModel(name: pocketName);
      final pocketId = await pocketRepo.insertPocket(newPocket);
      return pocketId;
    }
  }
}
