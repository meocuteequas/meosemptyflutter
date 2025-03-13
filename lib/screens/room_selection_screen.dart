import 'package:flutter/material.dart';
import '../models/room.dart';
import 'guest_details_screen.dart';

class RoomSelectionScreen extends StatefulWidget {
  final String hotelName;
  final Color color;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String roomName;
  final double price;

  const RoomSelectionScreen({
    Key? key,
    required this.hotelName,
    required this.color,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomName,
    required this.price,
  }) : super(key: key);

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  int _numberOfRooms = 1;

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.price * _numberOfRooms;
    final stepColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Room Selection'),
        backgroundColor: stepColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel_outlined,
              size: 80,
              color: stepColor,
            ),
            const SizedBox(height: 20),
            Text(
              widget.roomName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${widget.price.toInt()} per night',
              style: TextStyle(
                fontSize: 18,
                color: stepColor,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Number of Rooms:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: stepColor,
                  onPressed: _numberOfRooms > 1 ? () => setState(() => _numberOfRooms--) : null,
                ),
                Text(
                  _numberOfRooms.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: stepColor,
                  onPressed: () => setState(() => _numberOfRooms++),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Total: \$${(totalPrice).toInt()}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: stepColor,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final selectedRoom = Room(
                  name: widget.roomName,
                  price: widget.price,
                );
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestDetailsScreen(
                      hotelName: widget.hotelName,
                      color: widget.color,
                      checkInDate: widget.checkInDate,
                      checkOutDate: widget.checkOutDate,
                      selectedRoom: selectedRoom,
                      numberOfRooms: _numberOfRooms,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: stepColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
