import 'package:flutter/material.dart';

class FeedbackGrievanceScreen extends StatefulWidget {
  const FeedbackGrievanceScreen({super.key});

  @override
  State<FeedbackGrievanceScreen> createState() => _FeedbackGrievanceScreenState();
}

class _FeedbackGrievanceScreenState extends State<FeedbackGrievanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedType = 'General Feedback';

  final List<String> _types = [
    'General Feedback',
    'Billing Issue',
    'Service Issue',
    'Missed Garbage Pickup',
    'Illegal Dumping Report',
    'Report streetlight Issues'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );
      _descriptionController.clear();
      setState(() => _selectedType = 'General Feedback');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & Grievance')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF), // Light Blue
              Color(0xFF92FE9D), // Light Green
              Color(0xFFFECFEF), // Light Pink
              Color(0xFFFFA69E), // Light Red
            ],
            begin: Alignment.topLeft,  // Gradient starts from the top-left corner
            end: Alignment.bottomRight, // Gradient ends at the bottom-right corner
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) => setState(() => _selectedType = value!),
                    decoration: const InputDecoration(labelText: 'Select Type', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      hintText: 'Enter details here...',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description.' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
