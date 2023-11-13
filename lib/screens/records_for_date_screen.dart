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
  // State variables
  List<Record> _records = [];
  List<Record> _filteredRecords = [];
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quantitySearchController = TextEditingController();
  int? sortColumnIndex;
  bool isAscending = false;
  bool displayThreeDigitNumbers = false;
  bool displayFourDigitNumbers = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.date;
    _loadRecords();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  // Load records from the database
  void _loadRecords() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Record> records =
        (await dbHelper.getRecordsForDate(widget.date)).cast<Record>();
    // Sort the records based on the selected column and order
    if (sortColumnIndex != null) {
      records.sort((a, b) {
        var aValue = getValueByColumnIndex(a, sortColumnIndex!);
        var bValue = getValueByColumnIndex(b, sortColumnIndex!);
        return isAscending
            ? compareValues(aValue, bValue)
            : compareValues(bValue, aValue);
      });
    }
    _applyFilters(records);
  }

  // Compare values based on their types
  int compareValues(dynamic value1, dynamic value2) {
    if (value1 is String && value2 is String) {
      return value1.compareTo(value2);
    } else if (value1 is int && value2 is int) {
      return value1.compareTo(value2);
    } else {
      // Handle other types if needed
      return 0;
    }
  }

  // Get the value of a record based on the selected column index
  dynamic getValueByColumnIndex(Record record, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return record.number;
      case 1:
        return record.quantity;
      default:
        return null;
    }
  }

  // Apply filters based on display options and search criteria
  void _applyFilters(List<Record> records) {
    _filteredRecords = records.where((record) {
      bool numberMatch = true;

      if (displayThreeDigitNumbers && record.number.length != 3) {
        numberMatch = false;
      }

      if (displayFourDigitNumbers && record.number.length != 4) {
        numberMatch = false;
      }

      bool quantityMatch =
          record.quantity.toString().contains(_quantitySearchController.text);

      return numberMatch && quantityMatch;
    }).toList();

    setState(() {});
  }

  // Handle date changes and reload records
  void _onDateChanged(String newDate) {
    if (_isValidDate(newDate)) {
      _loadRecordsForDate(newDate);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid date format. Please use dd-MM-yyyy.'),
        duration: Duration(seconds: 4),
      ));
    }
  }

  // Validate date format
  bool _isValidDate(String date) {
    final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    return dateRegex.hasMatch(date);
  }

  // Load records for a specific date
  void _loadRecordsForDate(String date) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Record> records =
        (await dbHelper.getRecordsForDate(date)).cast<Record>();
    // Sort the records based on the selected column and order
    if (sortColumnIndex != null) {
      records.sort((a, b) {
        var aValue = getValueByColumnIndex(a, sortColumnIndex!);
        var bValue = getValueByColumnIndex(b, sortColumnIndex!);
        return isAscending
            ? compareValues(aValue, bValue)
            : compareValues(bValue, aValue);
      });
    }
    _applyFilters(records);
  }

  // Calculate the total quantity of filtered records
  int _calculateTotalQuantity() {
    int totalQuantity = 0;
    for (var record in _filteredRecords) {
      totalQuantity += record.quantity;
    }
    return totalQuantity;
  }

  // Handle column sorting
  void onSort(int columnIndex, bool ascending) {
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
      _loadRecords(); // Reload records with the new sorting configuration
    });
  }

  // Handle search criteria changes
  void _filterRecords() {
    _loadRecords(); // Reload records with the new filtering criteria
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records for ${widget.date}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date TextField
            TextField(
              controller: _dateController,
              onChanged: _onDateChanged,
              decoration: InputDecoration(
                labelText: 'Enter Date (dd-MM-yyy)',
              ),
            ),
            // Display options checkboxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(
                  value: displayThreeDigitNumbers,
                  onChanged: (value) {
                    setState(() {
                      displayThreeDigitNumbers = value!;
                      _filterRecords();
                    });
                  },
                ),
                Text('Display 3-digit numbers'),
                Checkbox(
                  value: displayFourDigitNumbers,
                  onChanged: (value) {
                    setState(() {
                      displayFourDigitNumbers = value!;
                      _filterRecords();
                    });
                  },
                ),
                Text('Display 4-digit numbers'),
              ],
            ),
            // Quantity search TextField
            TextField(
              controller: _quantitySearchController,
              onChanged: (value) {
                _filterRecords();
              },
              decoration: InputDecoration(
                labelText: 'Search by Quantity',
              ),
            ),
            // DataTable to display records
            DataTable(
              sortColumnIndex: sortColumnIndex,
              sortAscending: isAscending,
              columns: [
                DataColumn(
                  label: Text(
                    'Number',
                    style: TextStyle(fontSize: 20),
                  ),
                  onSort: onSort,
                ),
                DataColumn(
                  label: Text('Quantity', style: TextStyle(fontSize: 20)),
                  onSort: onSort,
                ),
              ],
              rows: _filteredRecords.map((record) {
                return DataRow(cells: [
                  DataCell(
                    Container(
                      child: Text(
                        record.number,
                        style: TextStyle(fontSize: 20),
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(
                        record.quantity.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                ]);
              }).toList(),
            ),
            // Total Quantity display
            Container(
              padding: EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Quantity: ${_calculateTotalQuantity()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
