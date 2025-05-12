import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillsPaymentScreen extends StatefulWidget {
  const BillsPaymentScreen({super.key});

  @override
  State<BillsPaymentScreen> createState() => _BillsPaymentScreenState();
}

class _BillsPaymentScreenState extends State<BillsPaymentScreen> {
  String? consumerNumber;
  List<Map<String, dynamic>> pendingBills = [];
  List<Map<String, dynamic>> paymentHistory = [];
  List<ApplicationMeta>? apps;

  final String baseUrl = 'https://flutter-login-backend.onrender.com';

  @override
  void initState() {
    super.initState();
    _loadConsumerNumber();
    _fetchUpiApps();
  }

  Future<void> _fetchUpiApps() async {
    try {
      final upiPay = UpiPay();  // Instantiate the UpiPay object
      final availableApps = await upiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all,
      );
      setState(() {
        apps = availableApps;
      });
    } catch (e) {
      debugPrint("UPI Error: $e");
    }
  }

  Future<void> _loadConsumerNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('consumerNumber');

    if (stored != null) {
      setState(() {
        consumerNumber = stored;
      });
      _fetchBills();
      _fetchHistory();
    } else {
      _askConsumerNumber();
    }
  }

  Future<void> _askConsumerNumber() async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Enter Consumer Number"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "e.g., 123456"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final input = controller.text.trim();
              if (input.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('consumerNumber', input);
                setState(() {
                  consumerNumber = input;
                });
                _fetchBills();
                _fetchHistory();
                Navigator.pop(context);
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchBills() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/bills/$consumerNumber'));
      if (res.statusCode == 200) {
        setState(() {
          pendingBills = List<Map<String, dynamic>>.from(json.decode(res.body));
        });
      } else {
        debugPrint('Failed to load bills: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching bills: $e');
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/payment_history/$consumerNumber'));
      if (res.statusCode == 200) {
        setState(() {
          paymentHistory = List<Map<String, dynamic>>.from(json.decode(res.body));
        });
      } else {
        debugPrint('Failed to load history: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
  }

  Future<void> _submitPaymentToBackend(Map<String, dynamic> bill) async {
    final payload = {
      'consumer_number': consumerNumber,
      'title': bill['title'],
      'amount': bill['amount'],
      'date': DateTime.now().toString().split(' ')[0],
    };

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/pay'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (res.statusCode == 200) {
        _fetchBills();
        _fetchHistory();
      } else {
        debugPrint("Backend payment store failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint('Payment POST error: $e');
    }
  }

  Future<void> _payWithUpiApp(int index, ApplicationMeta app) async {
    final bill = pendingBills[index];
    final amount = double.parse(bill['amount'].toString());

    try {
      final transactionRef = "Bill${DateTime.now().millisecondsSinceEpoch}";

      final upiPay = UpiPay();  // Create an instance of UpiPay

      final result = await upiPay.initiateTransaction(
        app: app.upiApplication,  // Pass the UPI application
        receiverUpiAddress: 'harshbdabhi@oksbi',
        receiverName: 'City Municipality',
        transactionRef: transactionRef,
        transactionNote: bill['title'],
        amount: amount.toStringAsFixed(2),
      );

      if (result.status == UpiTransactionStatus.success) {
        await _submitPaymentToBackend(bill);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Payment Successful"),
            content: const Text("Your bill has been paid. Thank you!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed or cancelled")),
        );
      }
    } catch (e) {
      debugPrint("Payment error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong during payment")),
      );
    }
  }

  void _chooseUpiApp(int index) {
    if (apps == null || apps!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No UPI apps found.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: apps!.map((app) {
          return ListTile(
            leading: const Icon(Icons.payment), // Using a default icon
            title: Text(app.upiApplication.getAppName()),
            onTap: () {
              Navigator.pop(context);
              _payWithUpiApp(index, app);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bills & UPI Payments"),
        backgroundColor: Colors.teal,
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
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (consumerNumber != null)
                Text("Consumer No: $consumerNumber", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              const Text("Pending Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (pendingBills.isEmpty)
                const Text("No pending bills.", style: TextStyle(color: Colors.grey)),
              ...pendingBills.asMap().entries.map((entry) {
                int index = entry.key;
                var bill = entry.value;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.red),
                    title: Text(bill['title']),
                    subtitle: Text("Amount: ₹${bill['amount']}"),
                    trailing: ElevatedButton(
                      onPressed: () => _chooseUpiApp(index),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text("Pay via UPI"),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),
              const Divider(thickness: 2),
              const SizedBox(height: 10),

              const Text("Payment History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (paymentHistory.isEmpty)
                const Text("No payments yet.", style: TextStyle(color: Colors.grey)),
              ...paymentHistory.map((payment) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(payment['title']),
                    subtitle: Text("Paid ₹${payment['amount']} on ${payment['date']}"),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
