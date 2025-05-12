import 'package:flutter/material.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<Map<String, String>> emergencyServices = [
    {"name": "Ambulance", "phone": "102"},
    {"name": "Police", "phone": "100"},
    {"name": "Fire Department", "phone": "101"},
    {"name": "Disaster Management", "phone": "108"},
  ];

  final List<Map<String, String>> userContacts = [];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _addUserContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      setState(() {
        userContacts.add({
          "name": _nameController.text,
          "phone": _phoneController.text,
        });
        _nameController.clear();
        _phoneController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: _addUserContact, child: const Text("Add")),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, String phone, {bool isUser = false}) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.call, color: isUser ? Colors.blueAccent : Colors.red),
        title: Text(title),
        subtitle: Text(phone),
        trailing: IconButton(
          icon: const Icon(Icons.phone_forwarded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Calling $title at $phone...")),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Add Contact",
            onPressed: _showAddContactDialog,
          )
        ],
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
          child: ListView(
            children: [
              const Text("Emergency Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...emergencyServices.map((c) => _buildContactCard(c["name"]!, c["phone"]!)),
              const SizedBox(height: 24),
              const Text("Your Emergency Contacts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              userContacts.isEmpty
                  ? const Text("No personal emergency contacts added yet.")
                  : Column(
                children: userContacts
                    .map((c) => _buildContactCard(c["name"]!, c["phone"]!, isUser: true))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
