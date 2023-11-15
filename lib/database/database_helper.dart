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
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, n TEXT, quantity INTEGER, date TEXT)');
        await db.execute(
          'CREATE TABLE previous(id INTEGER PRIMARY KEY, number TEXT, quantity INTEGER)',
        );
      },
      readOnly: false,
    );
  }

  Future<List<Map<String, dynamic>>> getAllRecordsFromPreviousTable() async {
    Database db = await database;
    return await db.query('previous');
  }

  Future<void> insertOrUpdateRecord(String n, int quantity, String date) async {
    Database db = await database;
    await db.delete('previous');
    // Query records before the update/insert
    List<Map> records = await db
        .query(tableName, where: 'n = ? AND date = ?', whereArgs: [n, date]);

    int updatedRows = await db.rawUpdate(
      'UPDATE $tableName SET quantity = quantity + ? WHERE n = ? AND date = ?',
      [quantity, n.toString(), date],
    );
    print(updatedRows);
    if (updatedRows == 0) {
      await db.insert(
        tableName,
        {'n': n.toString(), 'quantity': quantity, 'date': date},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    // Update the 'previous' table with the latest 'number' and 'quantity'
    await db.insert(
      'previous',
      {'number': n.toString(), 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(records.map((record) => record['n'].runtimeType));

    // if (records.isNotEmpty) {
    //   await db.rawUpdate(
    //       'UPDATE $tableName SET quantity = quantity + ? WHERE number = ? AND date = ?',
    //       [quantity, number.toString(), date]);
    // } else {
    //   await db.insert(
    //     tableName,
    //     {'number': number.toString(), 'quantity': quantity, 'date': date},
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    // }
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final Database db = await database;

    // Replace 'your_table_name' with your actual table name
    List<Map<String, dynamic>> records = await db.query(tableName);

    return records;
  }

  Future<void> deleteRecordsForDateandNumber(
      String date, String numbers) async {
    final Database db = await database;

    // Replace 'your_table_name' with your actual table name
    await db.delete(
      tableName,
      where: 'date = ? and n =?',
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
        n: maps[i]['n'],
        quantity: maps[i]['quantity'],
        date: maps[i]['date'],
      );
    });
  }
}
