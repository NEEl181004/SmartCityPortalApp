import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  List<dynamic> _appointments = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _fetchAppointments(String patientName) async {
    final url = Uri.parse("https://flutter-login-backend.onrender.com/appointments/$patientName");

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _appointments = data["appointments"];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load appointments.";
          _appointments = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: ${e.toString()}";
        _appointments = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment History"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Patient Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final patientName = _patientNameController.text.trim();
                  if (patientName.isNotEmpty) {
                    _fetchAppointments(patientName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a patient's name")),
                    );
                  }
                },
                child: const Text('Fetch Appointment History'),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : _appointments.isEmpty
                  ? const Center(child: Text("No appointments found."))
                  : Expanded(
                child: ListView.builder(
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final appt = _appointments[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.local_hospital, color: Colors.teal),
                        title: Text(appt["hospital"] ?? "Hospital"),
                        subtitle: Text(
                          "Doctor: ${appt["doctor"] ?? "-"}\nDate: ${appt["date"] ?? "-"}\nTime: ${appt["time"] ?? "-"}",
                          style: const TextStyle(height: 1.5),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
