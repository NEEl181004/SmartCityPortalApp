import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // For theme mode (Light/Dark)
  bool _isDarkMode = false;

  // For notification setting
  bool _notificationsEnabled = true;

  // Language selection (can be extended to actual language switching)
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme setting
            SwitchListTile(
              title: Text("Dark Mode"),
              subtitle: Text("Enable or disable dark mode"),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),

            // Notification setting
            SwitchListTile(
              title: Text("Notifications"),
              subtitle: Text("Enable or disable notifications"),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            // Language selection
            ListTile(
              title: Text("Language"),
              subtitle: Text(_selectedLanguage),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLanguageDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog for language selection
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("English"),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Spanish"),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Spanish';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("French"),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'French';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
