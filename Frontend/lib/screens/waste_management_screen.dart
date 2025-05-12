import 'package:flutter/material.dart';

class WasteManagementScreen extends StatelessWidget {
  const WasteManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTile(
              context,
              icon: Icons.calendar_today,
              title: "View garbage collection schedule",
              onTap: () => Navigator.pushNamed(context, '/collectionSchedule'),
            ),
            _buildTile(
              context,
              icon: Icons.recycling,
              title: "Recycling guidelines",
              onTap: () => Navigator.pushNamed(context, '/recyclingGuidelines'),
            ),
            _buildTile(
              context,
              icon: Icons.report_problem,
              title: "Report missed pickups",
              onTap: () => Navigator.pushNamed(context, '/missed-pickup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
