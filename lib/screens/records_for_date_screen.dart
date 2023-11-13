// import 'package:flutter/material.dart';

// import '../models/record_model.dart';

// import '../database/database_helper.dart';

// class RecordsForDateScreen extends StatefulWidget {
//   final String date;

//   RecordsForDateScreen(this.date);

//   @override
//   _RecordsForDateScreenState createState() => _RecordsForDateScreenState();
// }

// class _RecordsForDateScreenState extends State<RecordsForDateScreen> {
//   List<Record> _records = [];
//   TextEditingController _dateController = TextEditingController();
//   int? sortColumnIndex;
//   bool isAscending = false;

//   @override
//   void initState() {
//     super.initState();
//     _dateController.text = widget.date;
//     _loadRecords();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).requestFocus(FocusNode());
//     });
//   }

//   void _loadRecords() async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     List<Record> records =
//         (await dbHelper.getRecordsForDate(widget.date)).cast<Record>();
//     // Sort the records based on the "Number" column in ascending order
//     // records.sort((a, b) => a.number.compareTo(b.number));
//     if (sortColumnIndex != null) {
//       records.sort((a, b) {
//         var aValue = getValueByColumnIndex(a, sortColumnIndex!);
//         var bValue = getValueByColumnIndex(b, sortColumnIndex!);
//         return isAscending
//             ? aValue.compareTo(bValue)
//             : bValue.compareTo(aValue);
//       });
//     }
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
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Invalid date format. Please use dd-MM-yyyy.'),
//         duration: Duration(seconds: 4),
//       ));
//     }
//   }

//   bool _isValidDate(String date) {
//     final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
//     return dateRegex.hasMatch(date);
//   }

//   dynamic getValueByColumnIndex(Record record, int columnIndex) {
//     switch (columnIndex) {
//       case 0:
//         return record.number;
//       case 1:
//         return record.quantity;
//       // Add more cases for additional columns if needed
//       default:
//         return null;
//     }
//   }

//   void _loadRecordsForDate(String date) async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     List<Record> records =
//         (await dbHelper.getRecordsForDate(date)).cast<Record>();
//     // Sort the records based on the selected column and order
//     if (sortColumnIndex != null) {
//       records.sort((a, b) {
//         var aValue = getValueByColumnIndex(a, sortColumnIndex!);
//         var bValue = getValueByColumnIndex(b, sortColumnIndex!);
//         return isAscending
//             ? aValue.compareTo(bValue)
//             : bValue.compareTo(aValue);
//       });
//     }
//     setState(() {
//       _records = records;
//     });
//   }

//   int _calculateTotalQuantity() {
//     int totalQuantity = 0;
//     for (var record in _records) {
//       totalQuantity += record.quantity;
//     }
//     return totalQuantity;
//   }

//   void onSort(int columnIndex, bool ascending) {
//     setState(() {
//       this.sortColumnIndex = columnIndex;
//       this.isAscending = ascending;
//       _loadRecords(); // Reload records with the new sorting configuration
//     });
//   }

//   int compareString(bool ascending, String value1, String value2) =>
//       ascending ? value1.compareTo(value2) : value2.compareTo(value1);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.date}'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               controller: _dateController,
//               onChanged: _onDateChanged,
//               decoration: InputDecoration(
//                 labelText: 'Enter Date (dd-MM-yyy)',
//               ),
//             ),
//             DataTable(
//               sortColumnIndex: sortColumnIndex,
//               sortAscending: isAscending,
//               // columnSpacing: 5,
//               columns: [
//                 DataColumn(
//                     label: Text(
//                       'Number',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     onSort: onSort),
//                 DataColumn(
//                     label: Text('Quantity', style: TextStyle(fontSize: 20)),
//                     onSort: onSort),
//               ],
//               rows: _records.map((record) {
//                 return DataRow(cells: [
//                   DataCell(Container(
//                     child: Text(
//                       record.number,
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     width: MediaQuery.of(context).size.width * 0.6,
//                   )),
//                   DataCell(Container(
//                     child: Text(record.quantity.toString(),
//                         style: TextStyle(fontSize: 20)),
//                     width: MediaQuery.of(context).size.width * 0.2,
//                   )),
//                 ]);
//               }).toList(),
//             ),
//             Container(
//               padding: EdgeInsets.all(9.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Total Quantity: ${_calculateTotalQuantity()}',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//

