import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/data_model/person_data_model.dart';

class PersonRepository {
  final String tableName = 'persons';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnEmail = 'email';
  final String columnPassword = 'password';
  final String columnProfileImage = 'profileImage';
  final String columnHasRevolut = 'hasRevolut';

  static PersonRepository? _databaseHelper;
  static Database? _database;

  PersonRepository._createInstance();

  factory PersonRepository() {
    if (_databaseHelper == null) {
      _databaseHelper = PersonRepository._createInstance();
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
    final dbPath = join(databasesPath, 'persons.db');

    _database = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return _database!;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnEmail TEXT,
        $columnPassword TEXT,
        $columnProfileImage TEXT,
        $columnHasRevolut INTEGER
      )
      ''');
  }

  Future<int> insertPerson(PersonDataModel person) async {
    final db = await this.database;
    final result = await db.insert(tableName, person.toMap());
    return result;
  }

  Future<List<PersonDataModel>> getPersonList() async {
    final db = await this.database;
    final maps = await db.query(tableName);
    final persons = <PersonDataModel>[];
    if (maps.isNotEmpty) {
      for (final map in maps) {
        persons.add(PersonDataModel.fromMap(map));
      }
    }
    return persons;
  }

  Future<int> deletePerson(int id) async {
    final db = await this.database;
    final result =
        await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }

  //id alapján kereses
  Future<PersonDataModel?> getPersonById(int id) async {
    final db = await this.database;
    final maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PersonDataModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<PersonDataModel?> getPersonByName(String name) async {
    final db = await this.database;
    final maps = await db.query(
      tableName,
      where: '$columnName = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return PersonDataModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
  //uuujjaaaaaaaak

  Future<int?> getPersonIdByName(String name) async {
    try {
      final db = await this.database;
      final maps = await db.query(
        tableName,
        columns: [columnId],
        where: '$columnName = ?',
        whereArgs: [name],
      );

      if (maps.isNotEmpty) {
        return maps.first[columnId] as int?;
      } else {
        return null;
      }
    } catch (e) {
      print('Hiba a getPersonIdByName függvényben: $e');
      return null;
    }
  }

  Future<List<PersonDataModel>> loadPersons() async {
    try {
      if (!kIsWeb) {
        final personList = await getPersonList();
        return personList.whereType<PersonDataModel>().toList();
      } else {
        List<PersonDataModel> peopleList = [];
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People');

          final peopleQuerySnapshot = await peopleCollectionRef.get();
          if (peopleQuerySnapshot.docs.isNotEmpty) {
            peopleList = await Future.wait(peopleQuerySnapshot.docs.map(
              (doc) async => PersonDataModel.fromMap(doc.data()),
            ));
            return peopleList;
          } else {}
        } else {}
      }
    } catch (e, stackTrace) {
      print('Hiba a loadPersons függvényben: $e');
      print(stackTrace);
    }

    return [];
  }

  Future<bool> doesPersonExist(String name) async {
    try {
      if (!kIsWeb) {
        final db = await this.database;
        final maps = await db.query(
          tableName,
          columns: [columnName],
          where: '$columnName = ?',
          whereArgs: [name],
        );

        return maps.isNotEmpty;
      } else {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final userEmail = user.email;

          final peopleCollectionRef = firestore
              .collection(userEmail!)
              .doc('userData')
              .collection('People');

          final peopleQuerySnapshot = await peopleCollectionRef
              .where(columnName, isEqualTo: name)
              .get();

          return peopleQuerySnapshot.docs.isNotEmpty;
        }
      }
    } catch (e) {
      print('Hiba a doesPersonExist függvényben: $e');
      return false;
    }

    return false;
  }
}
