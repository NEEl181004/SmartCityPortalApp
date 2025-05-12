import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:upi_pay/upi_pay.dart';

class ParkingSlotBooking extends StatefulWidget {
  final String userEmail;

  const ParkingSlotBooking({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ParkingSlotBookingState createState() => _ParkingSlotBookingState();
}

class _ParkingSlotBookingState extends State<ParkingSlotBooking> {
  final String backendURL = 'https://flutter-login-backend.onrender.com';

  List<String> locations = [];
  String? selectedLocation;
  List<String> displayedSlots = List.generate(40, (index) => (index + 1).toString());
  List<String> occupiedSlots = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isLoading = false;

  List<ApplicationMeta> apps = [];

  @override
  void initState() {
    super.initState();
    fetchLocations();
    _fetchUpiApps();
  }

  // Fetch installed UPI apps
  Future<void> _fetchUpiApps() async {
    final upiPay = UpiPay();
    final upiApps = await upiPay.getInstalledUpiApplications(
      statusType: UpiApplicationDiscoveryAppStatusType.all,
    );
    if (!mounted) return;
    setState(() {
      apps = upiApps;
    });
  }

  // Fetch available locations
  Future<void> fetchLocations() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendURL/parking_slots'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final slots = data['slots'] as Map<String, dynamic>;

        if (slots.isNotEmpty) {
          final firstLoc = slots.keys.first;

          setState(() {
            locations = slots.keys.toList();
            selectedLocation = firstLoc;
            displayedSlots = List.generate(40, (index) => (index + 1).toString());
          });

          await fetchOccupiedSlots();
        } else {
          setState(() {
            locations = [];
            selectedLocation = null;
            displayedSlots = [];
            occupiedSlots = [];
          });
        }
      } else {
        print("Failed to load locations");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
    setState(() => isLoading = false);
  }

  // Fetch occupied slots for the selected location and date
  Future<void> fetchOccupiedSlots() async {
    if (selectedLocation == null) return;
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('$backendURL/occupied_slots'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'location': selectedLocation,
        'date': selectedDate.toIso8601String().split('T')[0],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        occupiedSlots = List<int>.from(data['slots'][selectedLocation] ?? [])
            .map((e) => e.toString())
            .toList();
      });
    } else {
      print("Failed to fetch occupied slots");
    }

    setState(() => isLoading = false);
  }

  // Book parking slot
  Future<void> bookSlot(String slot) async {
    final response = await http.post(
      Uri.parse('$backendURL/book_parking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': widget.userEmail,
        'location': selectedLocation,
        'date': selectedDate.toIso8601String().split('T')[0],
        'time': selectedTime.format(context),
        'slot': slot,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Slot $slot booked successfully!')),
      );
      fetchOccupiedSlots();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book slot')),
      );
    }
  }

  // Show booking dialog with UPI payment options
  void showBookingDialog(String slot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Book slot $slot at ₹50 using UPI?"),
            SizedBox(height: 10),
            if (apps.isEmpty) Text("No UPI apps found"),
            Wrap(
              spacing: 10,
              children: apps.map((app) {
                return GestureDetector(
                  onTap: () => initiateTransaction(slot, app),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Placeholder for the app's icon (no icon handling here)
                      Icon(Icons.account_balance_wallet, size: 40),
                      Text(app.packageName, style: TextStyle(fontSize: 12)), // Use packageName instead of appName
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Initiate UPI payment
  void initiateTransaction(String slot, ApplicationMeta app) async {
    Navigator.pop(context);
    final txnRef = DateTime.now().millisecondsSinceEpoch.toString();

    final upiPay = UpiPay();  // Creating instance of UpiPay to access initiateTransaction

    final result = await upiPay.initiateTransaction(
      amount: '50',
      app: app.upiApplication,
      receiverUpiAddress: 'harshbdabhi@oksbi', // Replace with real UPI ID
      receiverName: 'Parking Provider',
      transactionRef: txnRef,
      transactionNote: 'Parking Slot $slot',
    );

    if (result.status == UpiTransactionStatus.success) {
      await bookSlot(slot);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed or cancelled.")),
      );
    }
  }

  // Show date and time picker for slot selection
  void showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime =
      await showTimePicker(context: context, initialTime: selectedTime);
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
        fetchOccupiedSlots();
      }
    }
  }

  // Build the parking slot grid
  Widget buildSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: displayedSlots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        String slot = displayedSlots[index];
        bool isOccupied = occupiedSlots.contains(slot);

        return GestureDetector(
          onTap: isOccupied ? null : () => showBookingDialog(slot),
          child: Container(
            decoration: BoxDecoration(
              color: isOccupied ? Colors.grey : Colors.green,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            alignment: Alignment.center,
            child: Text(
              'Slot $slot',
              style: TextStyle(
                color: isOccupied ? Colors.black54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parking Slot Booking")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF), // Light Blue
              Color(0xFF92FE9D), // Light Green
              Color(0xFFFECFEF), // Light Pink
              Color(0xFFFFA69E), // Light Red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : selectedLocation == null
            ? Center(child: Text("No locations found."))
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton<String>(
                hint: Text("Select Location"),
                value: selectedLocation,
                isExpanded: true,
                items: locations.map((loc) {
                  return DropdownMenuItem(value: loc, child: Text(loc));
                }).toList(),
                onChanged: (loc) {
                  setState(() {
                    selectedLocation = loc;
                  });
                  fetchOccupiedSlots();
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text("${selectedDate.toLocal()}".split(' ')[0]),
                    onPressed: showDateTimePicker,
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.access_time),
                    label: Text(selectedTime.format(context)),
                    onPressed: showDateTimePicker,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(child: buildSlotGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
