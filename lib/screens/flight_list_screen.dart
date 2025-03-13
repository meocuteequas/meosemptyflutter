import 'package:flutter/material.dart';
import 'dart:async';
import 'currency_screen.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({super.key});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  bool _isLoading = true;
  late List<Map<String, dynamic>> flights;
  String currentCurrency = 'USD';

  // Default search parameters
  String origin = 'New York';
  String destination = 'London';
  String departureDate = 'Oct 12';
  String returnDate = 'Oct 15';
  int passengerCount = 1;

  @override
  void initState() {
    super.initState();
    // Simulate API request with a 2-second delay
    loadFlights();
  }

  Future<void> loadFlights() async {
    // Sample flight data
    flights = [
      {
        'airline': 'Sky Airlines',
        'departure': '08:30',
        'arrival': '14:45',
        'price': 350,
        'duration': '6h 15m',
        'color': Colors.blue,
      },
      {
        'airline': 'Global Airways',
        'departure': '10:15',
        'arrival': '16:20',
        'price': 320,
        'duration': '6h 05m',
        'color': Colors.green,
      },
      {
        'airline': 'Air Express',
        'departure': '13:40',
        'arrival': '19:55',
        'price': 290,
        'duration': '6h 15m',
        'color': Colors.purple,
      },
      {
        'airline': 'Fast Jet',
        'departure': '16:00',
        'arrival': '22:10',
        'price': 310,
        'duration': '6h 10m',
        'color': Colors.orange,
      },
      {
        'airline': 'Silver Air',
        'departure': '19:30',
        'arrival': '01:45',
        'price': 280,
        'duration': '6h 15m',
        'color': Colors.teal,
      },
    ];

    // Wait for 2 seconds to simulate network request
    await Future.delayed(const Duration(seconds: 2));

    // Check if widget is still mounted before updating state
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openCurrencySelector() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyScreen(
          selectedCurrency: currentCurrency,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        currentCurrency = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Handle search tap
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$origin to $destination',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$departureDate - $returnDate · $passengerCount passenger',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Row(
              children: [
                Text(
                  currentCurrency,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.currency_exchange, size: 16),
              ],
            ),
            onPressed: _openCurrencySelector,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Searching for flights...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait for a moment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to flight detail page
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: flight['color'],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.flight,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight['airline'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Duration: ${flight['duration']}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${flight['price']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flight['departure'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    origin,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      Icon(
                                        Icons.flight,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    flight['arrival'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    destination,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
