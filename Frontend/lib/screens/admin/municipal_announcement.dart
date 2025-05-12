import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMunicipalAnnouncementPage extends StatefulWidget {
  const AddMunicipalAnnouncementPage({super.key});

  @override
  _AddMunicipalAnnouncementPageState createState() =>
      _AddMunicipalAnnouncementPageState();
}

class _AddMunicipalAnnouncementPageState extends State<AddMunicipalAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  Future<void> _submitAnnouncement() async {
    // Make the API call to update the announcement in the backend
    final response = await http.post(
      Uri.parse('https://flutter-login-backend.onrender.com/update_alert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': 'municipal',
        'message': _messageController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Municipal announcement updated successfully!')),
      );
      // Optionally navigate back to the dashboard or another page
      Navigator.pop(context);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update municipal announcement.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Municipal Announcement')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF),  // Light Blue
              Color(0xFF92FE9D),  // Light Green
              Color(0xFFFECFEF),  // Light Pink
              Color(0xFFFFA69E),  // Light Peach
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
                        'Enter Municipal Announcement Message',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Announcement Message',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        maxLines: 4, // Allow for multiline input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an announcement message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitAnnouncement();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 6,
                        ),
                        child: const Text('Submit', style: TextStyle(fontSize: 16)),
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
}
