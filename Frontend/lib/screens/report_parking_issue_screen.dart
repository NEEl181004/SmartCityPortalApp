import 'package:flutter/material.dart';

class ReportParkingIssueScreen extends StatefulWidget {
  const ReportParkingIssueScreen({super.key});

  @override
  State<ReportParkingIssueScreen> createState() => _ReportParkingIssueScreenState();
}

class _ReportParkingIssueScreenState extends State<ReportParkingIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueController = TextEditingController();
  String? selectedIssueType;

  final List<String> issueTypes = [
    'Blocked Parking Spot',
    'Wrong Vehicle Parked',
    'Payment Issue',
    'App Booking Error',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report a Parking Issue"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF), // Light Blue
              Color(0xFF92FE9D), // Light Green
              Color(0xFFFECFEF), // Light Pink
              Color(0xFFFFA69E), // Light Red
            ],
            begin: Alignment.topLeft, // Gradient starts from the top-left corner
            end: Alignment.bottomRight, // Gradient ends at the bottom-right corner
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Issue Type',
                  border: OutlineInputBorder(),
                ),
                value: selectedIssueType,
                items: issueTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedIssueType = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select an issue type' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Describe your issue',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter details' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: _submitReport,
                child: const Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Normally, send data to backend or save it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue reported successfully!")),
      );
      _formKey.currentState!.reset();
      _issueController.clear();
      setState(() {
        selectedIssueType = null;
      });
    }
  }
}
