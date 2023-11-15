import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, dynamic>> _records = [];
  final FocusNode _numberFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _quantityController.value = const TextEditingValue(text: '1');
    _loadPreviousRecords();
  }

  Future<void> _loadPreviousRecords() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> previousRecords =
        await dbHelper.getAllRecordsFromPreviousTable();
    setState(() {
      _records = previousRecords;
    });
  }

  void _saveRecord() async {
    String n = _numberController.text.toString();
    if (n.isEmpty || (int.tryParse(n)) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid integer for Number'),
          duration: Duration(seconds: 4),
        ),
      );

      return;
    }
    // int numb = int.tryParse(number) ?? 0;
    n = n.toString();

    int quantity = int.tryParse(_quantityController.text) ?? 0;
    if (n.isEmpty || quantity == 0) {
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
    await dbHelper.insertOrUpdateRecord(n.toString(), quantity, date);
    _numberController.clear();
    _quantityController.text = '1';
    setState(() {
      // _records.clear();
      // _records.add({'n': n.toString(), 'quantity': quantity});
      _loadPreviousRecords();
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
                style: const TextStyle(fontSize: 35),
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
                style: const TextStyle(fontSize: 35),
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
                          DataCell(Text(
                            record['number'].toString(),
                            style: TextStyle(fontSize: 35),
                          )),
                          DataCell(Text(record['quantity'].toString(),
                              style: TextStyle(fontSize: 35))),
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
