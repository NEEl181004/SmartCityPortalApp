import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentScreen> {
  List<dynamic> hospitals = [];
  List<dynamic> doctors = [];

  String? selectedHospital;
  String? selectedDoctor;
  int? selectedDoctorId;

  String patientName = "";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final String backendUrl = "https://flutter-login-backend.onrender.com";

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  Future<void> fetchHospitals() async {
    final response = await http.get(Uri.parse("$backendUrl/get_hospitals"));
    if (response.statusCode == 200) {
      setState(() {
        hospitals = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchDoctors(String hospitalName) async {
    final response = await http.get(Uri.parse("$backendUrl/get_doctors/$hospitalName"));
    if (response.statusCode == 200) {
      setState(() {
        doctors = jsonDecode(response.body);
      });
    }
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  Future<void> bookAppointment() async {
    if (selectedHospital == null || selectedDoctorId == null || selectedDate == null || selectedTime == null || patientName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("UPI Payment"),
        content: const Text("Pay ₹200 to confirm your appointment"),
        actions: [
          TextButton(
            child: const Text("Pay"),
            onPressed: () async {
              Navigator.pop(context);
              final response = await http.post(
                Uri.parse("$backendUrl/book_appointment"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "patient_name": patientName,
                  "hospital_name": selectedHospital,
                  "doctor_id": selectedDoctorId,
                  "date": selectedDate!.toIso8601String().split('T')[0],
                  "time": selectedTime!.format(context)
                }),
              );
              if (response.statusCode == 200) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Appointment Booked"),
                    content: Text("Your appointment with $selectedDoctor at $selectedHospital is confirmed."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment"), backgroundColor: Colors.teal),
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Patient Name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => patientName = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Hospital",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedHospital,
                      items: hospitals.map<DropdownMenuItem<String>>((h) {
                        return DropdownMenuItem<String>(
                          value: h['name'],
                          child: Text(h['name']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedHospital = val;
                          selectedDoctor = null;
                          doctors.clear();
                        });
                        fetchDoctors(val!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Doctor",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedDoctor,
                      items: doctors.map<DropdownMenuItem<String>>((d) {
                        return DropdownMenuItem<String>(
                          value: d['name'],
                          child: Text(d['name']),
                          onTap: () => selectedDoctorId = d['id'],
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => selectedDoctor = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: Colors.white70,
                      leading: const Icon(Icons.calendar_today),
                      title: Text(selectedDate == null ? "Pick Date" : "${selectedDate!.toLocal()}".split(" ")[0]),
                      onTap: _pickDate,
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: Colors.white70,
                      leading: const Icon(Icons.access_time),
                      title: Text(selectedTime == null ? "Pick Time" : selectedTime!.format(context)),
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: bookAppointment,
                      child: const Text("Book Appointment"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
