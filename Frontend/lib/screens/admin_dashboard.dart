import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF),  // Light Blue
              Color(0xFF92FE9D),  // Light Green
              Color(0xFFFECFEF),  // Light Pink
              Color(0xFFFFA69E),  // Light Peach
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),

                    sectionTitle('City Services'),
                    gridButtons(context, [
                      ButtonInfo('Electricity Alert', '/electricityalert'),
                      ButtonInfo('Municipal Announcement', '/announcement'),
                    ]),

                    sectionTitle('Citizen Engagement'),
                    gridButtons(context, [
                      ButtonInfo('Add Poll', '/addpoll'),
                      ButtonInfo('Add Event', '/events'),
                    ]),

                    sectionTitle('News Management'),
                    gridButtons(context, [
                      ButtonInfo('Add News', '/addnews'),
                    ]),

                    sectionTitle('Hospital & Doctor'),
                    gridButtons(context, [
                      ButtonInfo('Add Hospital', '/addhospital'),
                      ButtonInfo('Add Doctor', '/adddoctor'),
                    ]),

                    sectionTitle('Billing'),
                    gridButtons(context, [
                      ButtonInfo('Add Bill', '/add_bills'),
                    ]),

                    sectionTitle('Smart Parking'),
                    gridButtons(context, [
                      ButtonInfo('Add Parking Space', '/add_parking'),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget gridButtons(BuildContext context, List<ButtonInfo> buttons) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),  // Disable scrolling of the grid itself
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // 2 buttons per row
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3, // Adjust button height and width ratio
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return themedButton(context, buttons[index].label, buttons[index].route);
      },
    );
  }

  Widget themedButton(BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),  // Reduced vertical padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}

class ButtonInfo {
  final String label;
  final String route;

  ButtonInfo(this.label, this.route);
}
