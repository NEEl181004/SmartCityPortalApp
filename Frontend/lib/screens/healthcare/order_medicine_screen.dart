import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderMedicineScreen extends StatefulWidget {
  const OrderMedicineScreen({super.key});

  @override
  State<OrderMedicineScreen> createState() => _OrderMedicineScreenState();
}

class _OrderMedicineScreenState extends State<OrderMedicineScreen> {
  final List<Map<String, dynamic>> medicines = [
    {"name": "Paracetamol", "price": 10},
    {"name": "Cough Syrup", "price": 50},
    {"name": "Vitamin C", "price": 25},
    {"name": "Pain Relief Spray", "price": 40},
    {"name": "Antibiotic Cream", "price": 30},
    {"name": "Allergy Tablets", "price": 20},
  ];

  final List<Map<String, dynamic>> cart = [];
  final TextEditingController _patientNameController = TextEditingController();

  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + (item['price'] as num));

  void _toggleCart(Map<String, dynamic> medicine) {
    setState(() {
      if (cart.contains(medicine)) {
        cart.remove(medicine);
      } else {
        cart.add(medicine);
      }
    });
  }

  Future<void> _placeOrder() async {
    final String patientName = _patientNameController.text.trim();

    if (patientName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name.")),
      );
      return;
    }

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one medicine.")),
      );
      return;
    }

    // Payment screen simulation
    final bool paymentSuccess = await _showPaymentDialog();
    if (!paymentSuccess) return;

    final orderData = {
      "username": patientName,
      "items": cart.map((item) => item['name']).toList(),
      "total_price": totalPrice,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://flutter-login-backend.onrender.com/order_medicine'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final orderId = responseData['order_id'];

        setState(() {
          cart.clear();
        });

        _showOrderSuccessDialog(orderData, orderId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order failed. Status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    }
  }

  Future<bool> _showPaymentDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Pay ₹$totalPrice using UPI?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Pay Now"),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showOrderSuccessDialog(Map<String, dynamic> order, int orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Order Placed"),
        content: Text("Order ID: $orderId\n\n"
            "You have successfully placed an order:\n\n"
            "${order['items'].join(', ')}\nTotal: ₹${order['total_price']}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _viewOrderHistory() async {
    final String patientName = _patientNameController.text.trim();

    if (patientName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name to view history.")),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://flutter-login-backend.onrender.com/order_history/$patientName'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['orders'].isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderHistoryScreen(orders: data['orders'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No orders found.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch order history. Status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Medicine"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _viewOrderHistory,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  hintText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Select medicines to order:", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    final isSelected = cart.contains(medicine);
                    return Card(
                      child: ListTile(
                        title: Text("${medicine['name']} - ₹${medicine['price']}"),
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.add_circle_outline,
                          color: isSelected ? Colors.green : null,
                        ),
                        onTap: () => _toggleCart(medicine),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping),
                label: Text("Place Order (₹$totalPrice)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _placeOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  final List orders;

  const OrderHistoryScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                title: Text("Order: ${order['items'].join(', ')}"),
                subtitle: Text("Total: ₹${order['total_price']}"),
                trailing: Text(order['timestamp']),
              ),
            );
          },
        ),
      ),
    );
  }
}
