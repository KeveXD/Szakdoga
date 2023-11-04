import 'package:flutter/material.dart';
import 'package:buxa/widgets/pocket_list_item.dart';
import 'package:buxa/widgets/new_pocket_dialog.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PocketPageModel {
  Future<List<PocketDataModel>> loadPockets() async {
    final pocketRepo = PocketRepository();
    final pocketList = await pocketRepo.getPocketList();
    pocketList.add(PocketDataModel(name: 'Összes', special: true));
    return pocketList;
  }

  Future<void> deletePocket(PocketDataModel pocket) async {
    final pocketRepo = PocketRepository();
    if (pocket.id != null) {
      await pocketRepo.deletePocket(pocket.id!);
    }
  }
}
