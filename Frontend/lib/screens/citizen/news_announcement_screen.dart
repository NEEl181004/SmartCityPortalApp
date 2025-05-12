import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsAnnouncementScreen extends StatefulWidget {
  const NewsAnnouncementScreen({super.key});

  @override
  _NewsAnnouncementScreenState createState() => _NewsAnnouncementScreenState();
}

class _NewsAnnouncementScreenState extends State<NewsAnnouncementScreen> {
  List<dynamic> newsList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://flutter-login-backend.onrender.com/get_news'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['news'] as List<dynamic>? ?? [];
        setState(() {
          newsList = items;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news (status ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading news';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City News & Announcements"),
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
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index] as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.announcement_outlined, color: Colors.teal),
                title: Text(
                  news['headline'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "📅 ${news['date'] ?? ''} | 🕒 ${news['time'] ?? ''}",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
