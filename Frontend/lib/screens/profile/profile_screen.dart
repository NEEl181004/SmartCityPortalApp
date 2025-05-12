import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'), // You can replace this with NetworkImage if needed
            ),
            const SizedBox(height: 10),
            const Text(
              'Guest User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'guest@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                // Add your edit profile action here
              },
            ),
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                // Add your settings action here
              },
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // Add help navigation here
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
