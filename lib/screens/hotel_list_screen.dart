import 'package:flutter/material.dart';
import 'hotel_screen.dart';
import 'dart:async';
import 'currency_screen.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  bool _isLoading = true;
  late List<Map<String, dynamic>> hotels;
  String currentCurrency = 'USD';

  // Default search parameters
  String destination = 'New York';
  String checkInDate = 'Oct 12';
  String checkOutDate = 'Oct 15';
  int guestCount = 2;

  @override
  void initState() {
    super.initState();
    // Simulate API request with a 3-second delay
    loadHotels();
  }

  Future<void> loadHotels() async {
    // Sample hotel data
    hotels = [
      {'name': 'Grand Hotel', 'color': Colors.blue, 'rating': 4.5},
      {'name': 'Ocean View Resort', 'color': Colors.green, 'rating': 4.8},
      {'name': 'Mountain Retreat', 'color': Colors.purple, 'rating': 4.2},
      {'name': 'City Center Hotel', 'color': Colors.orange, 'rating': 4.0},
      {'name': 'Riverside Inn', 'color': Colors.teal, 'rating': 4.6},
    ];

    // Wait for 3 seconds to simulate network request
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
        centerTitle: false, // Set this to false to align title to start
        title: Align(
          alignment: Alignment.centerLeft, // Explicitly align the content to the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              InkWell(
                onTap: () {
                  // Handle search tap
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Use minimal space needed
                  children: [
                    Text(
                      destination,
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
                '$checkInDate - $checkOutDate · $guestCount guests',
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
                    child: const CircularProgressIndicator(strokeWidth: 2,),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Searching for hotels...',
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
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelScreen(
                            hotelName: hotel['name'],
                            color: hotel['color'],
                            index: index,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: hotel['color'],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.hotel,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${hotel['rating']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
