import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _doctorNameController = TextEditingController();
  final _specializationController = TextEditingController();
  String? selectedHospital;
  final _formKey = GlobalKey<FormState>();

  List<String> hospitals = [];

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  Future<void> _fetchHospitals() async {
    try {
      final response = await http.get(
        Uri.parse('https://flutter-login-backend.onrender.com/get_hospitals'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          hospitals = List<String>.from(data.map((hospital) => hospital['name']));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load hospitals')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred. Try again later')),
      );
    }
  }

  Future<void> _addDoctor() async {
    final doctorName = _doctorNameController.text;
    final specialization = _specializationController.text;

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('https://flutter-login-backend.onrender.com/add_doctor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'hospital_name': selectedHospital,
            'name': doctorName,
            'specialization': specialization,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor added successfully')),
          );
          _doctorNameController.clear();
          _specializationController.clear();
          setState(() => selectedHospital = null);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred. Try again later')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor'), backgroundColor: Colors.teal),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF),
              Color(0xFF92FE9D),
              Color(0xFFFECFEF),
              Color(0xFFFFA69E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Doctor Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Hospital',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedHospital,
                        items: hospitals.map((hospital) {
                          return DropdownMenuItem(
                            value: hospital,
                            child: Text(hospital),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedHospital = value),
                        validator: (value) =>
                        value == null ? 'Please select a hospital' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _doctorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Doctor Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter doctor\'s name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _specializationController,
                        decoration: const InputDecoration(
                          labelText: 'Specialization',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter specialization'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addDoctor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 6,
                        ),
                        child: const Text('Add Doctor', style: TextStyle(fontSize: 16)),
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
