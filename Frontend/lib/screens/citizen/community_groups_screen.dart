import 'package:flutter/material.dart';

class CommunityGroupsScreen extends StatelessWidget {
  const CommunityGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      {"name": "Youth for Clean City", "desc": "Join clean-up and awareness drives"},
      {"name": "Green Warriors", "desc": "Tree plantation & recycling programs"},
      {"name": "Women’s Safety Cell", "desc": "Collaborate on safety policies"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Groups & Volunteering"),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return Card(
              child: ListTile(
                title: Text(group['name']!),
                subtitle: Text(group['desc']!),
                trailing: const Icon(Icons.group_add),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Request sent to join ${group['name']}")),
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
