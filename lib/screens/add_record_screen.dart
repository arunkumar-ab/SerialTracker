import 'package:count_app/screens/records_for_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> _records = [];
  FocusNode _numberFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _quantityController.value = const TextEditingValue(text: '1');
    // FocusScope.of(context).requestFocus(_numberFocusNode);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(FocusNode());
    // });
  }

  void _saveRecord() async {
    String number = _numberController.text;
    if (number.isEmpty || (int.tryParse(number)) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid integer for Number'),
          duration: Duration(seconds: 4),
        ),
      );

      return;
    }
    int numb = int.tryParse(number) ?? 0;

    int quantity = int.tryParse(_quantityController.text) ?? 0;
    if (number.isEmpty || quantity == 0) {
      // Display a Snackbar if number or quantity is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Number and Quantity are required'),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.insertOrUpdateRecord(numb, quantity, date);
    _numberController.clear();
    _quantityController.text = '1';

    setState(() {
      _records.add({'number': number, 'quantity': quantity});
    });
    // Set focus on the Number TextField
    FocusScope.of(context).requestFocus(_numberFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Record')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 18),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(fontSize: 35),
                autofocus: true,
                focusNode: _numberFocusNode,
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Number'),
                keyboardType: TextInputType.number,
                onSubmitted: (String value) {
                  // Move focus to the quantity TextField
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                style: TextStyle(fontSize: 35),
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              // Display DataTable below the button
              DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    'Number',
                    style: TextStyle(fontSize: 35),
                  )),
                  DataColumn(
                      label: Text(
                    'Quantity',
                    style: TextStyle(fontSize: 35),
                  )),
                ],
                rows: _records
                    .map(
                      (record) => DataRow(
                        cells: [
                          DataCell(Text(record['number'].toString())),
                          DataCell(Text(record['quantity'].toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 105,
        height: 105,
        child: FloatingActionButton(
          onPressed: _saveRecord,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:async';
// // import 'package:shared_preferences/shared_preferences.dart';

// class AddRecordScreen extends StatefulWidget {
//   @override
//   _AddRecordScreen createState() => _AddRecordScreen();
// }

// class _AddRecordScreen extends State<AddRecordScreen> {
//   TextEditingController _numberController = TextEditingController();
//   TextEditingController _quantityController = TextEditingController();
//   List<Map<String, dynamic>> _records = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadRecords();
//   }

//   Future<void> _loadRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String recordsJson = prefs.getString('records') ?? '[]';
//     setState(() {
//       _records = List<Map<String, dynamic>>.from(
//         (json.decode(recordsJson) as List)
//             .map((record) => Map<String, dynamic>.from(record)),
//       );
//     });
//   }

//   Future<void> _saveRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String recordsJson = json.encode(_records);
//     await prefs.setString('records', recordsJson);
//   }

//   void _saveRecord() async {
//     String number = _numberController.text;
//     int quantity = int.tryParse(_quantityController.text) ?? 0;
//     if (number.isEmpty || quantity == 0) {
//       // Display a Snackbar if number or quantity is empty
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Number and Quantity are required'),
//           duration: Duration(seconds: 4),
//         ),
//       );
//       return;
//     }

//     String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

//     // Update the list of records
//     setState(() {
//       _records.add({'number': number, 'quantity': quantity});
//     });

//     _saveRecords();

//     _numberController.clear();
//     _quantityController.clear();
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
//               decoration: const InputDecoration(labelText: 'Number'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _quantityController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'Quantity'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveRecord,
//               child: Text('Save Record'),
//             ),
//             SizedBox(height: 20),
//             // Display DataTable below the button
//             DataTable(
//               columns: [
//                 DataColumn(label: Text('Number')),
//                 DataColumn(label: Text('Quantity')),
//               ],
//               rows: _records
//                   .map(
//                     (record) => DataRow(
//                       cells: [
//                         DataCell(Text(record['number'].toString())),
//                         DataCell(Text(record['quantity'].toString())),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
