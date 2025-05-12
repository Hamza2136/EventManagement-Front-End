// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  final Map<String, dynamic> selectedFilters;
  const FilterPage({super.key, required this.selectedFilters});

  @override
  State<StatefulWidget> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  String? selectedDate;
  DateTime? _selectedDate;
  String _selectedOption = "Today";
  String datefieldText = "Choose from Calendar";
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.selectedFilters);

    if (_filters.containsKey('startDate')) {
      _selectedDate = DateTime.tryParse(_filters['startDate']);
      if (_selectedDate != null) {
        datefieldText = DateFormat('dd-MM-yyyy').format(_selectedDate!);
        _selectedOption = "Custom Date";
      }
    }

    if (_filters.containsKey('maxCost')) {
      priceController.text = _filters['maxCost'];
    }

    if (_filters.containsKey('location')) {
      locationController.text = _filters['location'];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Filter",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Time & Date", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateButton(context, "Today"),
                _buildDateButton(context, "Tomorrow"),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              width: screenWidth * 0.70,
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_month_outlined, color: HexColor("#4a43ec"), size: 25),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      datefieldText,
                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w300, fontSize: 15),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, color: HexColor("#4a43ec"), size: 20),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showDatePicker(context),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Enter location",
                prefixIcon: Icon(Icons.location_on, color: HexColor("#4a43ec")),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            const Text("Enter price", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Type your price here",
                prefixIcon: Icon(Icons.attach_money, color: HexColor("#4a43ec")),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        _selectedOption = "Today";
                        datefieldText = "Choose from Calendar";
                        priceController.clear();
                        locationController.clear();
                        _filters.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: HexColor("#4a43ec"),
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("RESET"),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _filters.clear();

                      if (_selectedDate != null) {
                        _filters['startDate'] = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                      }

                      if (priceController.text.isNotEmpty) {
                        _filters['maxCost'] = priceController.text;
                      }

                      if (locationController.text.isNotEmpty) {
                        _filters['location'] = locationController.text;
                      }

                      Navigator.pop(context, _filters);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: HexColor("#4a43ec"),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("APPLY"),
                  ),
                ),
              ],
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
          _selectedDate = label == "Today"
              ? DateTime.now()
              : DateTime.now().add(const Duration(days: 1));

          datefieldText = DateFormat('dd-MM-yyyy').format(_selectedDate!);
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? HexColor("#4a43ec") : Colors.grey[300],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedOption = "Custom Date";
        datefieldText = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }
}
