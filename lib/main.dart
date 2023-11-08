// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:intl/intl.dart';

// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

// class DatabaseHelper {
//   static Database? _database;
//   static const String tableName = 'my_table';

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }

//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'my_database.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//             'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, number TEXT, quantity INTEGER, date TEXT)');
//       },
//     );
//   }

//   Future<void> insertOrUpdateRecord(
//       String number, int quantity, String date) async {
//     Database db = await database;
//     print(number);
//     print(quantity);
//     print(date);
//     List<Map> records = await db.query(tableName,
//         where: 'number = ? AND date = ?', whereArgs: [number, date]);

//     if (records.isNotEmpty) {
//       await db.rawUpdate(
//           'UPDATE $tableName SET quantity = quantity + ? WHERE number = ? AND date = ?',
//           [quantity, number, date]);
//     } else {
//       await db.insert(
//         tableName,
//         {'number': number, 'quantity': quantity, 'date': date},
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }

//   Future<List<Map>> getRecordsForDate(String date) async {
//     Database db = await database;
//     return await db.query(tableName, where: 'date = ?', whereArgs: [date]);
//   }
// }

// class AddRecordScreen extends StatefulWidget {
//   @override
//   _AddRecordScreenState createState() => _AddRecordScreenState();
// }

// class _AddRecordScreenState extends State<AddRecordScreen> {
//   final TextEditingController _numberController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();

//   void _saveRecord() async {
//     String number = _numberController.text;
//     int quantity = int.tryParse(_quantityController.text) ?? 0;
//     String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

//     print(number);
//     print(quantity);
//     print(date);

//     DatabaseHelper dbHelper = DatabaseHelper();
//     await dbHelper.insertOrUpdateRecord(number, quantity, date);

//     // Optionally, show a message to indicate success
//     // and navigate back to a different screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Record')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _numberController,
//               decoration: InputDecoration(labelText: 'Number'),
//             ),
//             TextField(
//               controller: _quantityController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Quantity'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveRecord,
//               child: Text('Save Record'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RecordsForDateScreen extends StatefulWidget {
//   final String date;

//   RecordsForDateScreen(this.date);

//   @override
//   _RecordsForDateScreenState createState() => _RecordsForDateScreenState();
// }

// class _RecordsForDateScreenState extends State<RecordsForDateScreen> {
//   List<Map> _records = [];
//   TextEditingController _dateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _dateController.text = widget.date;
//     _loadRecords();
//   }

//   void _loadRecords() async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     List<Map> records = await dbHelper.getRecordsForDate(widget.date);
//     setState(() {
//       _records = records;
//     });
//   }

//   void _onDateChanged(String newDate) {
//     if (_isValidDate(newDate)) {
//       _loadRecordsForDate(newDate);
//     } else {
//       // Show an error message to the user, indicating the date format is incorrect.
//       // You can display an error message using a SnackBar or any other suitable method.
//       // Example:
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //   content: Text('Invalid date format. Please use yyyy-MM-dd.'),
//       //   duration: Duration(seconds: 2),
//       // ));
//     }
//   }

//   bool _isValidDate(String date) {
//     final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
//     return dateRegex.hasMatch(date);
//   }

//   void _loadRecordsForDate(String date) async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     List<Map> records = await dbHelper.getRecordsForDate(date);
//     setState(() {
//       _records = records;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.date}'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _dateController,
//             onChanged: _onDateChanged,
//             decoration: InputDecoration(
//               labelText: 'Enter Date (dd-MM-yyy)',
//             ),
//           ),
//           DataTable(
//             columns: [
//               DataColumn(label: Text('Number')),
//               DataColumn(label: Text('Quantity')),
//             ],
//             rows: _records.map((record) {
//               return DataRow(cells: [
//                 DataCell(Text(record['number'])),
//                 DataCell(Text(record['quantity'].toString())),
//               ]);
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // class RecordsForDateScreen extends StatefulWidget {
// //   final String date;

// //   RecordsForDateScreen(this.date);

// //   @override
// //   _RecordsForDateScreenState createState() => _RecordsForDateScreenState();
// // }

// // class _RecordsForDateScreenState extends State<RecordsForDateScreen> {
// //   List<Map> _records = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadRecords();
// //   }

// //   void _loadRecords() async {
// //     DatabaseHelper dbHelper = DatabaseHelper();
// //     List<Map> records = await dbHelper.getRecordsForDate(widget.date);
// //     setState(() {
// //       _records = records;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Records for ${widget.date}')),
// //       body: ListView.builder(
// //         itemCount: _records.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text('Number: ${_records[index]['number']}'),
// //             subtitle: Text('Quantity: ${_records[index]['quantity']}'),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// void main() {
//   runApp(MaterialApp(
//     home: RecordsForDateScreen(
//         DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()),
//   ));
// }

// // void main() {
// //   runApp(MaterialApp(
// //     home:AddRecordScreen(),
// //   ));
// // }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screens/records_for_date_screen.dart';

void main() {
  runApp(MaterialApp(
    home: RecordsForDateScreen(
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()),
  ));
}
