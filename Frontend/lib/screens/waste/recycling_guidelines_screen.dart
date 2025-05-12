import 'package:flutter/material.dart';

class RecyclingGuidelinesScreen extends StatelessWidget {
  const RecyclingGuidelinesScreen({super.key});

  final List<Map<String, String>> guidelines = const [
    {
      'title': 'Plastic',
      'description':
      'Rinse bottles and containers. Remove caps and labels. Avoid black plastics and plastic bags.'
    },
    {
      'title': 'Glass',
      'description':
      'Recycle clear, green, and brown glass. Rinse before recycling. Do not include ceramics or mirrors.'
    },
    {
      'title': 'Paper',
      'description':
      'Recycle newspapers, magazines, and office paper. Avoid food-stained or wax-coated paper.'
    },
    {
      'title': 'Metal',
      'description':
      'Recycle aluminum cans, tins, and foil. Rinse to remove food. No paint cans or aerosol cans.'
    },
    {
      'title': 'Electronics',
      'description':
      'Drop off at e-waste centers. Remove batteries. Backup and erase data on devices.'
    },
    {
      'title': 'Organic Waste',
      'description':
      'Use for composting. Includes fruit peels, vegetables, tea bags. Avoid dairy, meat, or oil.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recycling Guidelines"),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guidelines.length,
          itemBuilder: (context, index) {
            final item = guidelines[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.recycling, color: Colors.green),
                title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['description']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
