import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return FilterPageState();
  }
}

class FilterPageState extends State<FilterPage> {
  String? selectedDate; // Tracks the selected date
  Set<String> selectedCategories = {}; // Tracks selected categories
  RangeValues _priceRange = const RangeValues(0, 1000);
  DateTime? _selectedDate;
  String _selectedOption = "Today";
  String datefieldText = "Choose from Calendar";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.15,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryIcon(Icons.sports_basketball, "Sports"),
                  _buildCategoryIcon(Icons.music_note, "Music"),
                  _buildCategoryIcon(Icons.brush, "Art"),
                  _buildCategoryIcon(Icons.fastfood, "Food"),
                  _buildCategoryIcon(Icons.movie, "Movies"),
                  _buildCategoryIcon(Icons.travel_explore, "Travel"),
                  _buildCategoryIcon(Icons.school, "Education"),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Time & Date Section
            const Text("Time & Date",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateButton(context, "Today"),
                _buildDateButton(context, "Tomorrow"),
                _buildDateButton(context, "This Week"),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
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
                    Text(
                      datefieldText,
                      style: const TextStyle(
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
                onPressed: () {
                  _showDatePicker(context);
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Location Section
            const Text("Location",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: HexColor("#4a43ec")),
                        SizedBox(width: screenWidth * 0.02),
                        const Text(
                          "New York, USA",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: HexColor("#4a43ec"),
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            const Text("Select price range",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.02),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: HexColor("#4a43ec"),
                inactiveTrackColor: Colors.grey[300],
                thumbColor: HexColor("#4a43ec"),
              ),
              child: RangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000,
                divisions: 20,
                labels: RangeLabels(
                  _priceRange.start.toStringAsFixed(0),
                  _priceRange.end.toStringAsFixed(0),
                ),
                onChanged: (values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
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
                        selectedCategories.clear();
                        _priceRange = const RangeValues(0, 1000);
                        datefieldText = "Choose from Calendar";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: HexColor("#4a43ec"),
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("RESET"),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        print("Selected Date: $_selectedDate");
                        print("Selected Categories: $selectedCategories");
                        print("Selected Price Range: $_priceRange");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: HexColor("#4a43ec"),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
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

  Widget _buildCategoryIcon(IconData icon, String label) {
    final isSelected = selectedCategories.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(label);
          } else {
            selectedCategories.add(label);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  isSelected ? HexColor("#4a43ec") : Colors.grey[300],
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
                size: 35,
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
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
            _selectedDate = null;
            datefieldText = _getWeekRange();
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
        datefieldText = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  String _getWeekRange() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    return "${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d').format(endOfWeek)}";
  }
}
