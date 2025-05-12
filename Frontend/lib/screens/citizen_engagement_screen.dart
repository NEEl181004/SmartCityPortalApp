import 'package:flutter/material.dart';

class CitizenEngagementScreen extends StatelessWidget {
  const CitizenEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Engagement'),
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("📞 Contact City Administration"),
            _buildCard(
              context,
              title: "Reach City Officials",
              description: "Get in touch for queries, complaints or feedback.",
              icon: Icons.phone_in_talk,
              route: '/contactCityAdmin',
            ),

            const SizedBox(height: 16),
            _buildSectionTitle("📊 Participate in Polls or Surveys"),
            _buildCard(
              context,
              title: "Your Opinion Matters!",
              description: "Vote on city plans, surveys, and more.",
              icon: Icons.poll,
              route: '/pollSurvey',
            ),

            const SizedBox(height: 16),
            _buildSectionTitle("🎉 Community Events"),
            _buildCard(
              context,
              title: "Upcoming City Activities",
              description: "Volunteer or attend local events.",
              icon: Icons.event_available,
              route: '/communityEvents',
            ),

            const SizedBox(height: 16),
            _buildSectionTitle("📰 City Announcements / News"),
            _buildCard(
              context,
              title: "Latest Updates",
              description: "Stay informed on what’s happening around you.",
              icon: Icons.announcement,
              route: '/newsAnnouncements',
            ),

            const SizedBox(height: 16),
            _buildSectionTitle("🤝 Join Community Groups / Volunteering"),
            _buildCard(
              context,
              title: "Get Involved!",
              description: "Become part of local initiatives and teams.",
              icon: Icons.volunteer_activism,
              route: '/communityGroups',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
        required String description,
        required IconData icon,
        required String route}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
