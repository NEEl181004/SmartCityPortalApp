import 'package:flutter/material.dart';

class SmartHealthcareScreen extends StatelessWidget {
  const SmartHealthcareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Healthcare'),
        backgroundColor: Colors.teal,
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                "Choose a healthcare service:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              _buildServiceTile(
                context,
                icon: Icons.calendar_today,
                title: "Book Appointment",
                route: '/bookAppointment',
              ),

              _buildServiceTile(
                context,
                icon: Icons.medical_services_outlined,
                title: "Order Medicine",
                route: '/orderMedicine',
              ),

              _buildServiceTile(
                context,
                icon: Icons.folder_copy,
                title: "Appointment History",
                route: '/medicalRecords',
              ),

              _buildServiceTile(
                context,
                icon: Icons.phone_in_talk,
                title: "Emergency Contacts",
                route: '/emergencyContacts',
              ),

              _buildServiceTile(
                context,
                icon: Icons.health_and_safety,
                title: "Wellness Tips",
                route: '/wellnessTips',
              ),

              _buildServiceTile(
                context,
                icon: Icons.local_hospital,
                title: "Nearby Hospitals",
                route: '/nearby-hospitals',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context,
      {required IconData icon, required String title, required String route}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
