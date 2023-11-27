import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/data_model/debt_data_model.dart';

class DebtRepository {
  final String tableName = 'debts';
  final String columnId = 'id';
  final String columnDebtorPersonId = 'debtorPersonId';
  final String columnPersonToId = 'personToId';
  final String columnAmount = 'amount';
  final String columnIsPaid = 'isPaid';
  final String columnDescription = 'description';

  static DebtRepository? _databaseHelper;
  static Database? _database;

  DebtRepository._createInstance();

  factory DebtRepository() {
    if (_databaseHelper == null) {
      _databaseHelper = DebtRepository._createInstance();
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
    final dbPath = join(databasesPath, 'debts.db');

    _database = await openDatabase(dbPath, version: 3, onCreate: _createDb);
    return _database!;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnDebtorPersonId INTEGER,
      $columnPersonToId INTEGER,
      $columnAmount INTEGER,
      $columnIsPaid INTEGER,
      $columnDescription TEXT
    )
    ''');
  }

  Future<int> insertDebt(DebtDataModel debt) async {
    final db = await this.database;
    final result = await db.insert(tableName, debt.toMap());
    return result;
  }

  Future<List<DebtDataModel>> getDebtList() async {
    final db = await this.database;
    final maps = await db.query(tableName);
    final debts = <DebtDataModel>[];
    if (maps.isNotEmpty) {
      for (final map in maps) {
        debts.add(DebtDataModel.fromMap(map));
      }
    }
    return debts;
  }

  Future<void> deleteDebt(DebtDataModel debt) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [debt.id],
    );
  }

  Future<void> deleteDebtById(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDebt(DebtDataModel debt) async {
    final db = await database;
    await db.update(
      tableName,
      debt.toMap(),
      where: '$columnId = ?',
      whereArgs: [debt.id],
    );
  }
}
