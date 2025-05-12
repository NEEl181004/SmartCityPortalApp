import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  List<Map<String, String>> _hospitals = [];
  final List<String> _sampleAddresses = [
    "123 MG Road, Downtown",
    "22 Park Avenue, Sector 5",
    "Near Civic Center, Block C",
    "Phase 2, TechPark Zone",
    "45 Hilltop Lane",
    "7th Cross, Green Street",
    "101 Riverwalk Blvd",
    "Royal Street, Newtown",
  ];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchHospitalsFromBackend();
  }

  Future<void> _fetchHospitalsFromBackend() async {
    final url = Uri.parse('https://flutter-login-backend.onrender.com/get_hospitals');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _hospitals = data.map<Map<String, String>>((hospital) {
            return {
              "name": hospital["name"],
              "address": _sampleAddresses[_random.nextInt(_sampleAddresses.length)],
              "phone": "011-${_random.nextInt(90000000) + 10000000}"
            };
          }).toList();
        });
      } else {
        _showError("Failed to load hospitals from server.");
      }
    } catch (e) {
      _showError("Error fetching hospitals.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _simulateNavigation(BuildContext context, String placeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening directions to $placeName...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals & Clinics"),
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
        child: _hospitals.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _hospitals.length,
          itemBuilder: (context, index) {
            final hospital = _hospitals[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.local_hospital, color: Colors.redAccent),
                title: Text(hospital["name"]!),
                subtitle: Text("${hospital["address"]}\nPhone: ${hospital["phone"]}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.directions, color: Colors.blue),
                  onPressed: () => _simulateNavigation(context, hospital["name"]!),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Calling ${hospital["phone"]}...")),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
