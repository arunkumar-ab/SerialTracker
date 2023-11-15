import 'package:count_app/screens/add_record_screen.dart';
import 'package:count_app/screens/deletescreen.dart';
import 'package:count_app/screens/records_for_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  // Index for the selected tab
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Count App'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const AddRecordScreen(),
          RecordsForDateScreen(
              DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()),
          DeleteRecordScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
