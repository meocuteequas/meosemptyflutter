import 'package:flutter/material.dart';
import 'package:meosemptyflutter/widgets/hotel/amenity_row.dart';

class HotelAmenitiesSection extends StatelessWidget {
  final Color color;
  final GlobalKey sectionKey;

  const HotelAmenitiesSection({
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
            "Amenities",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          AmenityRow(icon: Icons.wifi, text: "Free WiFi", color: color),
          AmenityRow(icon: Icons.local_parking, text: "Parking Available", color: color),
          AmenityRow(icon: Icons.pool, text: "Swimming Pool", color: color),
          AmenityRow(icon: Icons.restaurant, text: "Restaurant", color: color),
          AmenityRow(icon: Icons.fitness_center, text: "Fitness Center", color: color),
          AmenityRow(icon: Icons.spa, text: "Spa Services", color: color),
          AmenityRow(icon: Icons.business_center, text: "Business Center", color: color),
          AmenityRow(icon: Icons.ac_unit, text: "Air Conditioning", color: color),
        ],
      ),
    );
  }
}
