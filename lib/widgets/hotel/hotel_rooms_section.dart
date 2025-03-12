import 'package:flutter/material.dart';
import 'package:meosemptyflutter/widgets/hotel/room_card.dart';

class HotelRoomsSection extends StatelessWidget {
  final Color color;
  final GlobalKey sectionKey;

  const HotelRoomsSection({
    super.key,
    required this.color,
    required this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rooms",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          RoomCard(
            roomType: "Standard Room",
            description: "1 king bed or 2 single beds",
            price: "From \$120/night",
            color: color.withOpacity(0.7),
          ),
          RoomCard(
            roomType: "Deluxe Room",
            description: "1 king bed with city view",
            price: "From \$160/night",
            color: color.withOpacity(0.8),
          ),
          RoomCard(
            roomType: "Executive Suite",
            description: "Separate living area and bedroom",
            price: "From \$220/night",
            color: color.withOpacity(0.9),
          ),
          RoomCard(
            roomType: "Presidential Suite",
            description: "Luxurious suite with panoramic views",
            price: "From \$350/night",
            color: color,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking feature coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
