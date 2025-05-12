import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FindParkingScreen extends StatefulWidget {
  final String userEmail;

  const FindParkingScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _FindParkingScreenState createState() => _FindParkingScreenState();
}

class _FindParkingScreenState extends State<FindParkingScreen> {
  final String backendURL = 'https://flutter-login-backend.onrender.com';
  List<Map<String, dynamic>> parkingLocations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  Future<void> fetchParkingData() async {
    setState(() => isLoading = true);

    try {
      final slotsResponse = await http.get(Uri.parse('$backendURL/parking_slots'));
      final slotsJson = json.decode(slotsResponse.body);

      print("Response from /parking_slots: $slotsJson");

      Map<String, dynamic> slotsData;

      if (slotsJson is Map<String, dynamic>) {
        slotsData = slotsJson['slots'];
      } else {
        throw Exception("Expected a Map with 'slots' field.");
      }

      Map<String, Map<String, dynamic>> locationsMap = {};
      slotsData.forEach((location, slotList) {
        int totalSlots = 40;
        locationsMap[location] = {
          'total_slots': totalSlots,
          'booked_slots': 0,
        };
      });

      final ticketsResponse = await http.get(Uri.parse('$backendURL/my_tickets/${widget.userEmail}'));
      if (ticketsResponse.statusCode == 200) {
        final tickets = json.decode(ticketsResponse.body);

        for (var ticket in tickets) {
          final location = ticket['location'];
          final bookedOn = ticket['booked_on'];

          DateTime bookingTime = DateTime.parse(bookedOn);
          DateTime currentTime = DateTime.now();

          if (currentTime.difference(bookingTime).inHours < 1) {
            if (locationsMap.containsKey(location)) {
              locationsMap[location]!['booked_slots'] += 1;
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          parkingLocations = locationsMap.entries.map((entry) {
            String location = entry.key;
            int total = entry.value['total_slots'];
            int booked = entry.value['booked_slots'];
            int available = total - booked;
            double distance = generateRandomDistance();

            return {
              'location': location,
              'availableSlots': available,
              'distance': distance,
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching parking data: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  double generateRandomDistance() {
    return (Random().nextInt(10) + 1).toDouble();
  }

  // Corrected Function to launch Google Maps
  Future<void> _launchMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Parking Space"),
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
            : parkingLocations.isEmpty
            ? const Center(child: Text("No available parking spaces."))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: parkingLocations.length,
            itemBuilder: (context, index) {
              final location = parkingLocations[index];

              // Generate random latitude and longitude within the Mumbai region
              double latitude = generateRandomLatitude();
              double longitude = generateRandomLongitude();

              return _buildParkingCard(
                location['location'],
                location['availableSlots'],
                location['distance'],
                latitude,
                longitude,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildParkingCard(String location, int availableSlots, double distance, double latitude, double longitude) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.local_parking, color: Colors.teal),
        title: Text(location),
        subtitle: Text("Available Slots: $availableSlots\nDistance: ${distance.toStringAsFixed(2)} km"),
        isThreeLine: true,
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: () {
            _launchMaps(latitude, longitude); // Launch Google Maps properly
          },
          child: const Text("Navigate"),
        ),
      ),
    );
  }

  // Function to generate random latitude between 18.9 and 19.4 (for Mumbai)
  double generateRandomLatitude() {
    return 18.9 + Random().nextDouble() * (19.4 - 18.9);
  }

  // Function to generate random longitude between 72.7 and 73.0 (for Mumbai)
  double generateRandomLongitude() {
    return 72.7 + Random().nextDouble() * (73.0 - 72.7);
  }
}
