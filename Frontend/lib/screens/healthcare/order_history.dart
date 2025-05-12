import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<dynamic> orderHistory = [];

  Future<void> _fetchOrders() async {
    const String username = "your_username"; // TODO: Replace with logged-in username dynamically
    final Uri url = Uri.parse('https://flutter-login-backend.onrender.com/order_history/$username');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          orderHistory = responseData['orders'] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch order history.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Updated parseItems function to handle the string format properly
  List<String> parseItems(String raw) {
    if (raw.isEmpty) return [];

    // Remove curly braces and quotes, then split by commas
    raw = raw.replaceAll(RegExp(r'[{}"]'), ''); // Remove curly braces and quotes
    return raw.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: orderHistory.isEmpty
            ? const Center(child: Text("No orders yet."))
            : ListView.builder(
          itemCount: orderHistory.length,
          itemBuilder: (context, index) {
            final order = orderHistory[index];
            final rawItems = order['items']?.toString() ?? '';
            final medicines = parseItems(rawItems);
            final date = order['timestamp']?.toString().split('T')[0] ?? '';

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text("Items: ${medicines.join(', ')}"),
                subtitle: Text("Total: ₹${order['total_price']}"),
                trailing: Text(date),
              ),
            );
          },
        ),
      ),
    );
  }
}
