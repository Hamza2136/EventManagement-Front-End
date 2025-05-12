// ignore_for_file: sized_box_for_whitespace, depend_on_referenced_packages, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/pages/main_screen.dart';
import 'package:smart_event_frontend/models/category_model.dart';
import 'package:smart_event_frontend/url.dart';

class UpdateEvent extends StatefulWidget {
  final EventModel event;

  const UpdateEvent({super.key, required this.event});

  @override
  State<StatefulWidget> createState() {
    return UpdateEventState();
  }
}

class UpdateEventState extends State<UpdateEvent> {
  List<Category> categories = [];
  Category? selectedCategory;

  TextStyle fieldStyle = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  final _formkey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController maxCapacityController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _initializeFields();
  }

  void _initializeFields() {
    final data = widget.event;
    titleController.text = data.title;
    descriptionController.text = data.description;
    locationController.text = data.location;
    maxCapacityController.text = data.maxCapacity.toString();
    imageUrlController.text = data.imageUrl;
    priceController.text = data.cost.toString();
    tagsController.text = data.tags ?? '';
    startDate = DateTime.tryParse(data.date ?? '');
    endDate = DateTime.tryParse(data.endDate ?? '');
  }

  Future<void> _fetchCategories() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$url/eventcategory/GetAllCategories"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories =
            data.map((category) => Category.fromJson(category)).toList();
        selectedCategory = categories.firstWhere(
          (c) => c.id == widget.event.eventCategoryId,
          orElse: () => categories.first,
        );
      });
    } else {
      print('Failed to load categories');
    }
  }

  void _selectDateTime(
      {required BuildContext context, required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          DateTime fullDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          if (isStartDate) {
            startDate = fullDate;
          } else {
            endDate = fullDate;
          }
        });
      }
    }
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Select Date & Time';
    return DateFormat('dd-MMM-yyyy HH:mm').format(dateTime);
  }

  Future<void> updateEvent() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.put(
      Uri.parse("$url/event/UpdateEvent${widget.event.id}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'location': locationController.text,
        'eventCategoryId': selectedCategory?.id,
        'maxCapacity': int.tryParse(maxCapacityController.text) ?? 0,
        'imageUrl': imageUrlController.text,
        'cost': int.tryParse(priceController.text) ?? 0,
        'tags': tagsController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Updated Successfully')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Update Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title:
            const Text("Update Event", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: fieldStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                style: fieldStyle,
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () =>
                    _selectDateTime(context: context, isStartDate: true),
                 style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#5669ff"),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      startDate == null
                          ? 'Select Start Date & Time'
                          : 'Start Date: ${formatDate(startDate)}',
                      style: fieldStyle,
                    ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () =>
                    _selectDateTime(context: context, isStartDate: false),
                 style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#5669ff"),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      endDate == null
                          ? 'Select End Date & Time'
                          : 'End Date: ${formatDate(endDate)}',
                      style: fieldStyle,
                    ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: fieldStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                style: fieldStyle,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: fieldStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                style: fieldStyle,
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Montserrat'),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: maxCapacityController,
                decoration: InputDecoration(
                  labelText: 'Max Capacity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Cost',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: updateEvent,
                style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#5669ff"),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Update Event',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
