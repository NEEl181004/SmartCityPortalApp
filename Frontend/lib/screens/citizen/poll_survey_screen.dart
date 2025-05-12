import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PollSurveyScreen extends StatefulWidget {
  const PollSurveyScreen({super.key});

  @override
  _PollsScreenState createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollSurveyScreen> {
  List<dynamic> polls = [];
  Map<int, String> selectedOptions = {};
  Map<int, bool> isSubmitted = {};

  @override
  void initState() {
    super.initState();
    _fetchPolls();
  }

  Future<void> _fetchPolls() async {
    final url = Uri.parse('https://flutter-login-backend.onrender.com/get_polls');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        polls = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load polls')),
      );
    }
  }

  void _submitPollLocally(int pollId, String selectedOption) {
    setState(() {
      isSubmitted[pollId] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your response has been submitted locally!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls'),
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
        child: polls.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: polls.length,
          itemBuilder: (context, index) {
            final poll = polls[index];
            return _buildPollCard(poll);
          },
        ),
      ),
    );
  }

  Widget _buildPollCard(Map<String, dynamic> poll) {
    final pollId = poll['id'];
    final currentSelection = selectedOptions[pollId];
    final submitted = isSubmitted[pollId] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll['question'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...poll['options'].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: currentSelection,
                onChanged: submitted
                    ? null
                    : (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedOptions[pollId] = value;
                    });
                  }
                },
              );
            }).toList(),
            if (!submitted && currentSelection != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    _submitPollLocally(pollId, currentSelection);
                  },
                  child: const Text('Submit'),
                ),
              ),
            if (submitted)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Response submitted.",
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
