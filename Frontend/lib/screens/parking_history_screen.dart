import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParkingHistoryScreen extends StatefulWidget {
  final String userEmail;

  const ParkingHistoryScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ParkingHistoryScreenState createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  final String backendURL = 'https://flutter-login-backend.onrender.com'; // Replace with your backend URL
  bool isLoading = true;
  List<Map<String, String>> parkingHistory = [];

  @override
  void initState() {
    super.initState();
    fetchParkingHistory();
  }

  // Fetch parking history from the backend
  Future<void> fetchParkingHistory() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$backendURL/my_tickets/${widget.userEmail}'), // Replace with your actual backend endpoint
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, String>> history = [];

        for (var ticket in data) {
          DateTime bookingTime = DateTime.parse(ticket['booked_on']);
          DateTime currentTime = DateTime.now();
          Duration diff = currentTime.difference(bookingTime);

          // Only add tickets that are not older than 1 hour
          if (diff.inHours < 1) {
            history.add({
              'location': ticket['location'],
              'date': ticket['date'],
              'time': ticket['time'],
              'slot': ticket['slot'],
              'payment_status': ticket['payment_status'],
            });
          }
        }

        setState(() {
          parkingHistory = history;
        });
      } else {
        print("Failed to fetch parking history.");
      }
    } catch (e) {
      print("Error fetching parking history: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Parking History"),
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : parkingHistory.isEmpty
            ? const Center(
          child: Text(
            "No recent parking history available.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: parkingHistory.length,
          itemBuilder: (context, index) {
            final record = parkingHistory[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.teal),
                title: Text(record['location']!),
                subtitle: Text(
                    "Date: ${record['date']} • Time: ${record['time']}"),
                trailing: Text(record['payment_status'] ?? 'Pending'),
              ),
            );
          },
        ),
      ),
    );
  }
}
