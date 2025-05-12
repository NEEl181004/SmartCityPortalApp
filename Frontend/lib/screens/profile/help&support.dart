import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // FAQ Section
            ListTile(
              title: Text("Frequently Asked Questions"),
              subtitle: Text("Get answers to common questions"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigateToFAQ(context);
              },
            ),

            // Contact Support Section
            ListTile(
              title: Text("Contact Support"),
              subtitle: Text("Reach out to our support team"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigateToContactSupport(context);
              },
            ),

            // User Guide Section
            ListTile(
              title: Text("User Guide"),
              subtitle: Text("Read the full user manual"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigateToUserGuide(context);
              },
            ),

            // Report an Issue Section
            ListTile(
              title: Text("Report an Issue"),
              subtitle: Text("Let us know about any issues"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigateToReportIssue(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to the FAQ screen
  void _navigateToFAQ(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FAQScreen()),
    );
  }

  // Navigate to the Contact Support screen
  void _navigateToContactSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactSupportScreen()),
    );
  }

  // Navigate to the User Guide screen
  void _navigateToUserGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserGuideScreen()),
    );
  }

  // Navigate to the Report Issue screen
  void _navigateToReportIssue(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportIssueScreen()),
    );
  }
}

// Sample FAQ Screen
class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ")),
      body: Center(
        child: Text("Frequently Asked Questions will appear here."),
      ),
    );
  }
}

// Sample Contact Support Screen
class ContactSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Support")),
      body: Center(
        child: Text("Here, users can contact support."),
      ),
    );
  }
}

// Sample User Guide Screen
class UserGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Guide")),
      body: Center(
        child: Text("User guide information will be shown here."),
      ),
    );
  }
}

// Sample Report Issue Screen
class ReportIssueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Issue")),
      body: Center(
        child: Text("Here, users can report issues with the app."),
      ),
    );
  }
}
