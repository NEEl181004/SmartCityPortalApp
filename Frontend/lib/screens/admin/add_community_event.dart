import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCommunityEventScreen extends StatefulWidget {
  const AddCommunityEventScreen({super.key});

  @override
  _AddCommunityEventScreenState createState() =>
      _AddCommunityEventScreenState();
}

class _AddCommunityEventScreenState extends State<AddCommunityEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _date = '';
  String _time = '';
  String _location = '';
  bool _isLoading = false;

  // Function to send the event data to the backend
  Future<void> _addEvent() async {
    setState(() {
      _isLoading = true; // Start loading spinner
    });

    final url = Uri.parse('https://flutter-login-backend.onrender.com/add_event');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': _title,
        'date': _date,
        'time': _time,
        'location': _location,
      }),
    );

    final responseData = json.decode(response.body);

    setState(() {
      _isLoading = false; // Stop loading spinner
    });

    if (response.statusCode == 201) {
      // Successfully added event
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      Navigator.pop(context);  // Navigate back to the previous screen
    } else {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Community Event'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF), // Light Blue
              Color(0xFF92FE9D), // Light Green
              Color(0xFFFECFEF), // Light Pink
              Color(0xFFFFA69E), // Light Peach
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Keeps form from stretching too much
                    children: [
                      const Text(
                        'Enter Community Event Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Event Title Section
                      _buildInputCard(
                        'Event Title',
                        'Enter the event title',
                        TextInputType.text,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event title';
                          }
                          return null;
                        },
                            (value) => _title = value!,
                      ),
                      const SizedBox(height: 15),

                      // Event Date Section
                      _buildInputCard(
                        'Event Date',
                        'Enter the event date',
                        TextInputType.datetime,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event date';
                          }
                          return null;
                        },
                            (value) => _date = value!,
                      ),
                      const SizedBox(height: 15),

                      // Event Time Section
                      _buildInputCard(
                        'Event Time',
                        'Enter the event time',
                        TextInputType.datetime,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event time';
                          }
                          return null;
                        },
                            (value) => _time = value!,
                      ),
                      const SizedBox(height: 15),

                      // Event Location Section
                      _buildInputCard(
                        'Event Location',
                        'Enter the event location',
                        TextInputType.text,
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event location';
                          }
                          return null;
                        },
                            (value) => _location = value!,
                      ),
                      const SizedBox(height: 30),

                      // Add Event Button
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _addEvent();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Correct parameter here
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Add Event',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create input cards for each form field
  Widget _buildInputCard(String label, String hint, TextInputType keyboardType,
      String? Function(String?) validator, Function(String?) onSaved) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
