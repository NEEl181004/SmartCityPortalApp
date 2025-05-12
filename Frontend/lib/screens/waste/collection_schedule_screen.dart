import 'package:flutter/material.dart';

class CollectionScheduleScreen extends StatefulWidget {
  const CollectionScheduleScreen({super.key});

  @override
  State<CollectionScheduleScreen> createState() => _CollectionScheduleScreenState();
}

class _CollectionScheduleScreenState extends State<CollectionScheduleScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? selectedCity;
  bool showSchedule = false;

  final Map<String, Map<String, String>> citySchedules = {
    'delhi': {
      'Monday': 'Organic Waste',
      'Tuesday': 'Plastic',
      'Wednesday': 'Paper',
      'Thursday': 'E-waste',
      'Friday': 'General Waste',
    },
    'mumbai': {
      'Monday': 'Plastic',
      'Tuesday': 'Paper',
      'Wednesday': 'Glass',
      'Thursday': 'Organic Waste',
      'Friday': 'General Waste',
    },
    'bangalore': {
      'Monday': 'General Waste',
      'Tuesday': 'Plastic',
      'Wednesday': 'Paper',
      'Thursday': 'E-waste',
      'Friday': 'Organic Waste',
    },
  };

  void _checkSchedule() {
    final city = _cityController.text.trim().toLowerCase();
    if (citySchedules.containsKey(city)) {
      setState(() {
        selectedCity = city;
        showSchedule = true;
      });
    } else {
      setState(() {
        selectedCity = null;
        showSchedule = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = selectedCity != null ? citySchedules[selectedCity]! : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Garbage Collection Schedule"),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Enter your city to check the schedule:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: "City Name",
                  hintText: "e.g. Delhi, Mumbai, Bangalore",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _checkSchedule,
                icon: const Icon(Icons.search),
                label: const Text("Check Schedule"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 20),

              if (showSchedule && schedule != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      final day = schedule.keys.elementAt(index);
                      final wasteType = schedule[day];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.green),
                          title: Text(day),
                          subtitle: Text(wasteType!),
                        ),
                      );
                    },
                  ),
                ),

              if (showSchedule && schedule == null)
                const Text(
                  "Sorry, no schedule found for this city.",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
