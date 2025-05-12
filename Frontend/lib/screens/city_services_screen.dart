import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityServicesScreen extends StatefulWidget {
  const CityServicesScreen({super.key});

  @override
  State<CityServicesScreen> createState() => _CityServicesScreenState();
}

class _CityServicesScreenState extends State<CityServicesScreen> {
  String electricityAlert = "Loading...";
  String municipalAnnouncement = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    try {
      // Send GET request to the backend to fetch alerts
      final response = await http.get(Uri.parse('https://flutter-login-backend.onrender.com/get_alerts'));

      if (response.statusCode == 200) {
        // Decode the response body
        final data = json.decode(response.body);

        // Extract electricity and municipal alerts from the response
        setState(() {
          // Set the electricity and municipal alerts
          electricityAlert = data['electricity'] != null
              ? '${data['electricity']['message']} (Updated: ${data['electricity']['created_at']})'
              : 'No current electricity alert.';

          municipalAnnouncement = data['municipal'] != null
              ? '${data['municipal']['message']} (Updated: ${data['municipal']['created_at']})'
              : 'No current announcements.';
        });
      } else {
        // Handle failed response
        setState(() {
          electricityAlert = 'Failed to load electricity alert.';
          municipalAnnouncement = 'Failed to load municipal announcement.';
        });
      }
    } catch (e) {
      // Handle errors (e.g., network issues, parsing errors)
      setState(() {
        electricityAlert = 'Error loading data.';
        municipalAnnouncement = 'Error loading data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Services'),
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
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildServiceTile(
                icon: Icons.water_drop_outlined,
                title: 'Water Supply Schedule',
                subtitle: 'Check your area\'s supply timings.',
                onTap: () {
                  _showServiceDetails(
                    context,
                    'Water Supply Schedule',
                    'Water will be available from 6 AM to 9 AM. Please store accordingly.',
                  );
                },
              ),
              _buildServiceTile(
                icon: Icons.electrical_services_outlined,
                title: 'Electricity Outage Alerts',
                subtitle: 'Live outage info in your area.',
                onTap: () {
                  _showServiceDetails(context, 'Electricity Outage Alert', electricityAlert);
                },
              ),
              _buildServiceTile(
                icon: Icons.announcement_outlined,
                title: 'Municipal Announcements',
                subtitle: 'Get the latest city updates.',
                onTap: () {
                  _showServiceDetails(context, 'Municipal Announcement', municipalAnnouncement);
                },
              ),
              _buildServiceTile(
                icon: Icons.delete_outline,
                title: 'Garbage Collection Timetable',
                subtitle: 'View your area\'s collection schedule.',
                onTap: () {
                  _showServiceDetails(
                    context,
                    'Garbage Collection',
                    'Garbage collection is scheduled every Monday and Thursday at 8 AM.',
                  );
                },
              ),
              _buildServiceTile(
                icon: Icons.directions_bus_filled_outlined,
                title: 'Public Transport Info',
                subtitle: 'Bus, Train & Metro schedules like M-indicator.',
                onTap: () {
                  Navigator.pushNamed(context, '/transportinfo'); // Make sure this route exists
                },
              ),
              _buildServiceTile(
                icon: Icons.lightbulb_outline,
                title: 'Report Streetlight Issues',
                subtitle: 'Let us know of broken lights.',
                onTap: () {
                  Navigator.pushNamed(context, '/feedback'); // Make sure this route exists
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showServiceDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
