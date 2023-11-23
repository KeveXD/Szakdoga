import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:buxa/model/pocket_model.dart';
import 'package:flutter/material.dart';

class PocketPageViewModel {
  final PocketPageModel model;
  List<PocketDataModel> pockets = [];

  PocketPageViewModel() : model = PocketPageModel();

  Future<List<PocketDataModel>> loadPockets(BuildContext context) async {
    pockets = await model.loadPockets(context);
    return pockets;
  }

  Future<void> deletePocket(
      BuildContext context, PocketDataModel pocket) async {
    await model.deletePocket(pocket);
    loadPockets(context);
  }
}
