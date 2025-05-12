// ignore: file_names
// ignore_for_file: sized_box_for_whitespace, file_names, duplicate_ignore, depend_on_referenced_packages, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/pages/main_screen.dart';
import 'package:smart_event_frontend/models/category_model.dart';
import 'package:smart_event_frontend/url.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddEventState();
  }
}

class AddEventState extends State<AddEvent> {
  List<Category> categories = [];
  Category? selectedCategory;

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
      });
    } else {
      print('Failed to load categories');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  TextStyle fieldStyle = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController maxCapacityController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  DateTime? startDate;
  DateTime? endDate;
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
    if (dateTime == null) return 'Select End Date & Time';
    return DateFormat('dd-MMM-yyyy HH:mm').format(dateTime);
  }

  Future<void> createEvent(
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    String location,
    int eventCategoryId,
    int maxCapacity,
    String imageUrl,
    int cost,
    String tags,
  ) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$url/event/CreateEvent"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'location': location,
        'eventCategoryId': eventCategoryId,
        'maxCapacity': maxCapacity,
        'imageUrl': imageUrl,
        'cost': cost,
        'tags': tags,
      }),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Created Successfully')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Creation Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title:
            const Text("Create Event", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: titleController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Title is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Event Title...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
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
                ),
                SizedBox(height: screenHeight * 0.02),

                // End Date Picker
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
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
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: descriptionController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Description is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Event Description...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: locationController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Location is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Event Location...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    items: categories.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(
                          category.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Montserrat'),
                        ),
                      );
                    }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: imageUrlController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'ImageUrl is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'ImageUrl',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your ImageUrl...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: priceController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Price is Required if Free write 0'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Ticket Price like Between (0-1000)...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: tagsController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Tags are Required atleast 1'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Tags',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Event Related Tags Here...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        if (startDate != null && endDate != null) {
                          try {
                            int maxCapacity =
                                int.tryParse(maxCapacityController.text) ?? 0;
                            int cost = int.tryParse(priceController.text) ?? 0;

                            createEvent(
                              titleController.text,
                              descriptionController.text,
                              startDate!,
                              endDate!,
                              locationController.text,
                              selectedCategory!.id,
                              maxCapacity,
                              imageUrlController.text,
                              cost,
                              tagsController.text,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Start Date and End Date are required!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#5669ff"),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Create Event',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> addnewAddress(BuildContext context, String name, String address,
  //     String Area, int zipCode, int phoneNumber) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse('$url/Address/add'),
  //       body: jsonEncode({
  //         'Name': name,
  //         'UserId': userId,
  //         'CompleteAddress': address,
  //         'Area': Area,
  //         'PostalCode': zipCode,
  //         'PhoneNumber': phoneNumber,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 201) {
  //       debugPrint('Address Added Successfully');
  //       setState(
  //         () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Address(
  //                 userId: userId,
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     } else {
  //       debugPrint('Failed to Add Address: ${response.body}');
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }
}
