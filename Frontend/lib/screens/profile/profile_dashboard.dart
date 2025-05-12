import 'package:flutter/material.dart';

class ProfileDashboard extends StatelessWidget {
  final String username;
  final String email;

  const ProfileDashboard({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart City Portal"),
        backgroundColor: Colors.teal,
        actions: [
          // Circular profile icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile'); // 👈 navigate to profile page
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.teal),
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, $username 👋",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Email: $email",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildOptionTile(context, Icons.receipt_long, "Bills & Payments", () {
                      Navigator.pushNamed(context, '/bills');
                    }),
                    _buildOptionTile(context, Icons.miscellaneous_services, "City Services", () {
                      Navigator.pushNamed(context, '/services');
                    }),
                    _buildOptionTile(context, Icons.feedback, "Feedback & Grievance", () {
                      Navigator.pushNamed(context, '/feedback');
                    }),
                    _buildOptionTile(context, Icons.local_parking, "Smart Parking", () {
                      Navigator.pushNamed(context, '/parking');
                    }),
                    _buildOptionTile(context, Icons.people, "Citizen Engagement", () {
                      Navigator.pushNamed(context, '/citizenEngagement');
                    }),
                    _buildOptionTile(context, Icons.local_hospital, "Smart Healthcare", () {
                      Navigator.pushNamed(context, '/smartHealthcare');
                    }),
                    _buildOptionTile(context, Icons.delete, "Waste Management", () {
                      Navigator.pushNamed(context, '/wasteManagement');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
