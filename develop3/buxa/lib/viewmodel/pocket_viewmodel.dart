import 'package:flutter/material.dart';
import 'package:buxa/widgets/pocket_list_item.dart';
import 'package:buxa/widgets/new_pocket_dialog.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/model/pocket_model.dart';

class PocketPageViewModel {
  final PocketPageModel model;
  List<PocketDataModel> pockets = [];

  PocketPageViewModel() : model = PocketPageModel();

  Future<List<PocketDataModel>> loadPockets() async {
    pockets = await model.loadPockets();
    return pockets;
  }

  Future<void> deletePocket(PocketDataModel pocket) async {
    await model.deletePocket(pocket);
    loadPockets();
  }
}
