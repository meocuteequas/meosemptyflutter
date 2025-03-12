import 'package:flutter/material.dart';

class HotelOverviewSection extends StatelessWidget {
  final String hotelName;
  final int index;
  final GlobalKey sectionKey;

  const HotelOverviewSection({
    super.key,
    required this.hotelName,
    required this.index,
    required this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hotelName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(
                    " ${4.0 + (index % 10) / 10}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Hotel ${index + 1} Location",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "About this hotel",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This is a beautiful hotel located in the heart of the city. "
            "It offers comfortable rooms, excellent service, and a variety of amenities. "
            "Perfect for both business trips and vacations. "
            "Stay at Hotel ${index + 1} for an unforgettable experience.\n\n"
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, "
            "nisl nec ultricies lacinia, nisl nisl aliquet nisl, nec ultricies nisl "
            "nisl nec ultricies lacinia, nisl nisl aliquet nisl, nec ultricies nisl.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
