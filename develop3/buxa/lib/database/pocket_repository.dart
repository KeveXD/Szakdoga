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
}
