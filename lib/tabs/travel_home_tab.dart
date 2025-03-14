import 'package:flutter/material.dart';
import 'package:meosemptyflutter/screens/hotel_search_screen.dart';
import '../screens/hotel_list_screen.dart';
import '../screens/flight_list_screen.dart';

class TravelHomeTab extends StatelessWidget {
  final ScrollController scrollController;

  const TravelHomeTab({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // App Bar
        SliverAppBar(
          title: const Text('Travel App'),
          pinned: true,
          floating: true,
          centerTitle: true,
        ),
        
        // Content
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon
                const Icon(
                  Icons.travel_explore,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 40),
                
                // Welcome text
                const Text(
                  'Where would you like to go?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Hotel button
                _buildNavigationButton(
                  context,
                  'Hotels',
                  Icons.hotel,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HotelSearchScreen(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Flight button
                _buildNavigationButton(
                  context,
                  'Flights',
                  Icons.flight,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlightListScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNavigationButton(
    BuildContext context, 
    String text, 
    IconData icon, 
    Color color, 
    VoidCallback onPressed
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
