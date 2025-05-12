import 'package:flutter/material.dart';

class PublicTransportInfoPage extends StatelessWidget {
  const PublicTransportInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Transport Info'),
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
        child: DefaultTabController(
          length: 3, // Three tabs: Bus, Train, Metro
          child: Column(
            children: [
              // Tab Bar for Bus, Train, Metro
              const TabBar(
                tabs: [
                  Tab(text: 'Bus'),
                  Tab(text: 'Train'),
                  Tab(text: 'Metro'),
                ],
                indicatorColor: Colors.teal,
              ),
              // Tab View for the content of each transport type
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBusSchedule(),
                    _buildTrainSchedule(),
                    _buildMetroSchedule(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bus schedule widget
  Widget _buildBusSchedule() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTransportCard(
          'Bus 12',
          'Frequency: Every 15 minutes\nOperating Hours: 6:00 AM - 10:00 PM',
          ['Stops: Main St -> Station -> City Center'],
        ),
        _buildTransportCard(
          'Bus 34',
          'Frequency: Every 30 minutes\nOperating Hours: 6:30 AM - 8:30 PM',
          ['Stops: Park Rd -> Downtown -> University'],
        ),
      ],
    );
  }

  // Train schedule widget
  Widget _buildTrainSchedule() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTransportCard(
          'Local Train Line 1',
          'Frequency: Every 10 minutes during peak hours\nOperating Hours: 5:30 AM - 11:00 PM',
          ['Stops: Station A -> Station B -> Station C'],
        ),
        _buildTransportCard(
          'Local Train Line 2',
          'Frequency: Every 15 minutes\nOperating Hours: 6:00 AM - 10:00 PM',
          ['Stops: Station X -> Station Y -> Station Z'],
        ),
      ],
    );
  }

  // Metro schedule widget
  Widget _buildMetroSchedule() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTransportCard(
          'Green Line',
          'Frequency: Every 5 minutes\nOperating Hours: 5:30 AM - 11:00 PM',
          ['Stops: Station 1 -> Station 2 -> Station 3'],
        ),
        _buildTransportCard(
          'Red Line',
          'Frequency: Every 8 minutes\nOperating Hours: 6:00 AM - 10:30 PM',
          ['Stops: Station A -> Station B -> Station C'],
        ),
      ],
    );
  }

  // Helper widget to build individual transport cards
  Widget _buildTransportCard(String title, String subtitle, List<String> details) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(
          title.startsWith('Bus') ? Icons.directions_bus : title.startsWith('Local Train') ? Icons.train : Icons.directions_subway,
          color: Colors.teal,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        children: details
            .map(
              (detail) => ListTile(
            title: Text(detail),
            dense: true,
          ),
        )
            .toList(),
      ),
    );
  }
}
