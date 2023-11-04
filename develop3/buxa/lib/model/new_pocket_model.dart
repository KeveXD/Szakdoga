import 'package:buxa/data_model/pocket_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:buxa/database/pocket_repository.dart';

class NewPocketModel {
  Future<int> insertPocket(PocketDataModel newPocket) async {
    if (kIsWeb) {
      return 0;
    } else {
      final pocketRepo = PocketRepository();
      return await pocketRepo.insertPocket(newPocket);
    }
  }
}
