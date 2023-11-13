import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/record_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'my_table';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, number INTEGER, quantity INTEGER, date TEXT)');
      },
    );
  }

  Future<void> insertOrUpdateRecord(
      int number, int quantity, String date) async {
    Database db = await database;
    List<Map> records = await db.query(tableName,
        where: 'number = ? AND date = ?', whereArgs: [number, date]);

    if (records.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE $tableName SET quantity = quantity + ? WHERE number = ? AND date = ?',
          [quantity, number, date]);
    } else {
      await db.insert(
        tableName,
        {'number': number, 'quantity': quantity, 'date': date},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final Database db = await database;

    // Replace 'your_table_name' with your actual table name
    List<Map<String, dynamic>> records = await db.query(tableName);

    return records;
  }

  Future<void> deleteRecordsForDateandNumber(String date, int numbers) async {
    final Database db = await database;

    // Replace 'your_table_name' with your actual table name
    await db.delete(
      tableName,
      where: 'date = ? and number =?',
      whereArgs: [date, numbers],
    );
  }

  Future<void> deleteRecordsForDate(String date) async {
    final Database db = await database;

    // Replace 'your_table_name' with your actual table name
    await db.delete(
      tableName,
      where: 'date = ? ',
      whereArgs: [date],
    );
  }

  Future<List<Record>> getRecordsForDate(String date) async {
    Database db = await database;
    List<Map> maps =
        await db.query(tableName, where: 'date = ?', whereArgs: [date]);

    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i]['id'],
        number: maps[i]['number'],
        quantity: maps[i]['quantity'],
        date: maps[i]['date'],
      );
    });
  }
}
