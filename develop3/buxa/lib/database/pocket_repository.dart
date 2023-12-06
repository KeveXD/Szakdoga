import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PocketRepository {
  final String tableName = 'pockets';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnSpecial = 'special'; // special tulajdonság hozzáadva

  static PocketRepository? _databaseHelper;
  static Database? _database;

  PocketRepository._createInstance();

  factory PocketRepository() {
    if (_databaseHelper == null) {
      _databaseHelper = PocketRepository._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'pockets.db');

    _database = await openDatabase(dbPath, version: 3, onCreate: _createDb);
    return _database!;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnSpecial INTEGER
      )
      ''');
  }

  Future<int> insertPocket(PocketDataModel pocket) async {
    final db = await this.database;
    final result = await db.insert(tableName, pocket.toMap());
    return result;
  }

  Future<List<PocketDataModel>> getPocketList() async {
    final db = await this.database;
    final maps = await db.query(tableName);
    final pockets = <PocketDataModel>[];
    if (maps.isNotEmpty) {
      for (final map in maps) {
        pockets.add(PocketDataModel.fromMap(map));
      }
    }
    return pockets;
  }

  Future<int> deletePocket(int id) async {
    final db = await this.database;
    final result =
        await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }

  Future<PocketDataModel?> getPocketById(int id) async {
    final db = await this.database;
    final maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PocketDataModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<PocketDataModel?> getPocketByName(String name) async {
    final db = await this.database;
    final maps = await db.query(
      tableName,
      where: '$columnName = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return PocketDataModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updatePocketSpecial(int id, bool special) async {
    final db = await this.database;
    await db.update(
      tableName,
      {columnSpecial: special ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getAllPocketNames() async {
    final db = await this.database;
    final result = await db.query(tableName, columns: [columnName]);

    if (result.isNotEmpty) {
      return List<String>.from(result.map((map) => map[columnName].toString()));
    } else {
      return [];
    }
  }

//nem biztos hogy kell
  Future<List<String>> getAllPocketNames2() async {
    final db = await this.database;
    final result = await db.query(tableName, columns: [columnName]);

    if (result.isNotEmpty) {
      return List<String>.from(result.map((map) => map[columnName].toString()));
    } else {
      return [];
    }
  }

  //ujak webes függvények

  Future<List<PocketDataModel>> loadPersons() async {
    try {
      if (!kIsWeb) {
        final pocketList = await getPocketList();
        return pocketList.whereType<PocketDataModel>().toList();
      } else {
        List<PocketDataModel> pocketList = [];
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('Pockets');

          final pocketQuerySnapshot = await peopleCollectionRef.get();
          if (pocketQuerySnapshot.docs.isNotEmpty) {
            pocketList = await Future.wait(pocketQuerySnapshot.docs.map(
              (doc) async => PocketDataModel.fromMap(doc.data()),
            ));
            return pocketList;
          } else {}
        } else {}
      }
    } catch (e, stackTrace) {
      print('Hiba a loadPockets függvényben: $e');
      print(stackTrace);
    }

    return [];
  }
}
