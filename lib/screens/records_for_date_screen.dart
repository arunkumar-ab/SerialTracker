
import 'package:flutter/material.dart';

import '../models/record_model.dart';

import '../database/database_helper.dart';

class RecordsForDateScreen extends StatefulWidget {
  final String date;

  RecordsForDateScreen(this.date);

  @override
  _RecordsForDateScreenState createState() => _RecordsForDateScreenState();
}

class _RecordsForDateScreenState extends State<RecordsForDateScreen> {
  List<Record> _records = [];
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.date;
    _loadRecords();
  }

  void _loadRecords() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Record> records = (await dbHelper.getRecordsForDate(widget.date)).cast<Record>();
    setState(() {
      _records = records;
    });
  }

  void _onDateChanged(String newDate) {
    if (_isValidDate(newDate)) {
      _loadRecordsForDate(newDate);
    } else {
      // Show an error message to the user, indicating the date format is incorrect.
      // You can display an error message using a SnackBar or any other suitable method.
      // Example:
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Invalid date format. Please use dd-MM-yyyy.'),
      //   duration: Duration(seconds: 2),
      // ));
    }
  }

  bool _isValidDate(String date) {
    final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    return dateRegex.hasMatch(date);
  }

  void _loadRecordsForDate(String date) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Record> records = (await dbHelper.getRecordsForDate(date)).cast<Record>();
    setState(() {
      _records = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records for ${widget.date}'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _dateController,
            onChanged: _onDateChanged,
            decoration: InputDecoration(
              labelText: 'Enter Date (dd-MM-yyy)',
            ),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Number')),
              DataColumn(label: Text('Quantity')),
            ],
            rows: _records.map((record) {
              return DataRow(cells: [
                DataCell(Text(record.number)),
                DataCell(Text(record.quantity.toString())),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
