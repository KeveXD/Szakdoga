import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/pocket_repository.dart';

class PaymentRepository {
  final String tableName = 'payments';
  final String columnId = 'id';
  final String columnDate = 'date';
  final String columnTitle = 'title';
  final String columnComment = 'comment';
  final String columnType = 'type';
  final String columnIsDebt = 'isDebt';
  final String columnPocketId = 'pocketId';
  final String columnAmount = 'amount';
  final String columnCurrency = 'currency';

  static PaymentRepository? _databaseHelper;
  Database? _database;

  PaymentRepository._createInstance();

  factory PaymentRepository() {
    if (_databaseHelper == null) {
      _databaseHelper = PaymentRepository._createInstance();
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
    final dbPath = join(databasesPath, 'payments.db');

    _database = await openDatabase(dbPath, version: 2, onCreate: _createDb);
    return _database!;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT,
        $columnTitle TEXT,
        $columnComment TEXT,
        $columnType TEXT,
        $columnIsDebt INTEGER,
        $columnPocketId INTEGER, 
        $columnAmount REAL,
        $columnCurrency TEXT
      )
    ''');
  }

  Future<int> insertPayment(PaymentDataModel payment) async {
    final db = await this.database;
    final result = await db.insert(tableName, payment.toMap());
    return result;
  }

  Future<List<PaymentDataModel>> getPaymentList() async {
    final db = await this.database;
    final maps = await db.query(tableName);
    final payments = <PaymentDataModel>[];
    if (maps.isNotEmpty) {
      for (final map in maps) {
        payments.add(PaymentDataModel.fromMap(map));
      }
    }
    return payments;
  }

  Future<int> deletePayment(int id) async {
    final db = await this.database;
    final result =
        await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }

  Future<List<PaymentDataModel>> getPaymentsByPocket(String pocketName) async {
    final db = await this.database;
    final payments = <PaymentDataModel>[];

    final pocketRepo = PocketRepository();
    final pocketList = await pocketRepo.getPocketList();
    final matchingPockets =
        pocketList.where((pocket) => pocket.name == pocketName);

    if (matchingPockets.isNotEmpty) {
      final matchingPocketId = matchingPockets.first.id;

      final maps = await db.query(
        tableName,
        where: '$columnPocketId = ?',
        whereArgs: [matchingPocketId],
      );

      for (final map in maps) {
        payments.add(PaymentDataModel.fromMap(map));
      }
    }

    return payments;
  }

  Future<int> updatePayment(PaymentDataModel payment) async {
    final db = await database;
    final int rowsUpdated = await db.update(
      tableName,
      payment.toMap(),
      where: '$columnId = ?',
      whereArgs: [payment.id],
    );
    return rowsUpdated;
  }
}
