import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final TextEditingController consumerNumberController = TextEditingController();
  final TextEditingController billTitleController = TextEditingController();
  final TextEditingController billAmountController = TextEditingController();

  // Function to add new bill
  Future<void> addNewBill(String consumerNumber, String title, int amount) async {
    final response = await http.post(
      Uri.parse('https://flutter-login-backend.onrender.com/add-bill'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'consumer_number': consumerNumber,
        'title': title,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill added successfully')),
      );
      // Clear fields after successful submission
      consumerNumberController.clear();
      billTitleController.clear();
      billAmountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add new bill')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Bill'), backgroundColor: Colors.teal),
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
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter Bill Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: consumerNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Consumer Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: billTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Bill Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: billAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Bill Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        String consumerNumber = consumerNumberController.text;
                        String title = billTitleController.text;
                        int amount = int.tryParse(billAmountController.text) ?? 0;
                        if (consumerNumber.isNotEmpty && title.isNotEmpty && amount > 0) {
                          addNewBill(consumerNumber, title, amount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields correctly')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                      ),
                      child: const Text('Add Bill', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
