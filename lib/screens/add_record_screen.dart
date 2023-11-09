import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _saveRecord() async {
    String number = _numberController.text;
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.insertOrUpdateRecord(number, quantity, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Record')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Number'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord,
              child: Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }
}
