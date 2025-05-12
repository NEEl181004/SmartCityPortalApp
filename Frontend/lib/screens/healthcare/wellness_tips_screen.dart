import 'package:flutter/material.dart';

class WellnessTipsScreen extends StatelessWidget {
  const WellnessTipsScreen({super.key});

  final List<Map<String, String>> tips = const [
    {
      "title": "Stay Hydrated",
      "desc": "Drink at least 8 glasses of water a day to maintain hydration and support body functions.",
    },
    {
      "title": "Exercise Regularly",
      "desc": "Engage in at least 30 minutes of physical activity most days of the week.",
    },
    {
      "title": "Get Enough Sleep",
      "desc": "Aim for 7–9 hours of quality sleep every night to keep your mind and body rested.",
    },
    {
      "title": "Eat Balanced Meals",
      "desc": "Include fruits, vegetables, protein, and whole grains in your daily meals.",
    },
    {
      "title": "Take Breaks from Screens",
      "desc": "Use the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds.",
    },
    {
      "title": "Practice Mindfulness",
      "desc": "Spend 10 minutes a day in meditation or quiet reflection to reduce stress.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wellness Tips"),
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
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(tip["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(tip["desc"]!),
              ),
            );
          },
        ),
      ),
    );
  }
}
