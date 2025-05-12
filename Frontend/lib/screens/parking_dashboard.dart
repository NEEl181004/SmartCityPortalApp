import 'package:flutter/material.dart';

class ParkingDashboard extends StatelessWidget {
  const ParkingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parking"),
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
            begin: Alignment.topLeft,  // Gradient starts from the top-left corner
            end: Alignment.bottomRight, // Gradient ends at the bottom-right corner
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildOptionTile(
                context,
                icon: Icons.search,
                title: "Find Parking Space",
                route: '/findParking',
              ),
              _buildOptionTile(
                context,
                icon: Icons.report_problem,
                title: "Report a Parking Issue",
                route: '/reportParkingIssue',
              ),
              _buildOptionTile(
                context,
                icon: Icons.calendar_today,
                title: "Book a Parking Spot",
                route: '/bookParking',
              ),
              _buildOptionTile(
                context,
                icon: Icons.history,
                title: "My Parking History",
                route: '/parkingHistory',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required IconData icon,
        required String title,
        required String route}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
