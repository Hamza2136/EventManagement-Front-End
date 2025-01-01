import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  DateTime? _selectedDate;
  String _selectedOption = "Today";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title: const Text("Filter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Time & Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateButton(context, "Today"),
                _buildDateButton(context, "Tomorrow"),
                _buildDateButton(context, "This Week"),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: screenWidth * 0.70,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: HexColor("#4a43ec"),
                  size: 25,
                ),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Choose from calendar",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: HexColor("#4a43ec"),
                      size: 20,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _showDatePicker(context),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedDate != null || _selectedOption.isNotEmpty)
              Text(
                "Selected: ${_getSelectedDateText()}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, String label) {
    bool isSelected = _selectedOption == label;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedOption = label;
          if (label == "Today") {
            _selectedDate = DateTime.now();
          } else if (label == "Tomorrow") {
            _selectedDate = DateTime.now().add(const Duration(days: 1));
          } else if (label == "This Week") {
            _selectedDate = null; // Use null or handle this differently
          }
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? HexColor("#4a43ec") : Colors.grey[300],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now().subtract(const Duration(days: 365));
    DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedOption = "Custom Date";
      });
    }
  }

  String _getSelectedDateText() {
    if (_selectedOption == "This Week") {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      return "This Week: ${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d').format(endOfWeek)}";
    } else if (_selectedDate != null) {
      return DateFormat('EEE, MMM d, yyyy').format(_selectedDate!);
    } else {
      return _selectedOption;
    }
  }
}
