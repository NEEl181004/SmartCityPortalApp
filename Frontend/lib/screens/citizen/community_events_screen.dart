import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityEventsScreen extends StatefulWidget {
  const CommunityEventsScreen({super.key});

  @override
  _CommunityEventsScreenState createState() => _CommunityEventsScreenState();
}

class _CommunityEventsScreenState extends State<CommunityEventsScreen> {
  List<dynamic> events = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    const apiUrl = 'https://flutter-login-backend.onrender.com/get_events';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('events')) {
          final eventList = decoded['events'];
          if (eventList is List) {
            setState(() {
              events = eventList;
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = 'Invalid format: "events" is not a list';
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = 'Invalid response format: "events" key missing';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load events (status: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Events"),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : events.isEmpty
            ? const Center(child: Text("No events available."))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(event['title'] ?? 'Untitled'),
                subtitle: Text(
                  "📅 ${event['date'] ?? 'Unknown'} | 🕒 ${event['time'] ?? 'Unknown'} | 📍 ${event['location'] ?? 'Not specified'}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
