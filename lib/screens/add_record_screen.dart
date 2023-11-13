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
