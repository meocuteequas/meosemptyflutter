import 'package:flutter/material.dart';
import '../models/room.dart';
import 'payment_screen.dart';

class GuestDetailsScreen extends StatefulWidget {
  final String hotelName;
  final Color color;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final Room selectedRoom;
  final int numberOfRooms;

  const GuestDetailsScreen({
    Key? key,
    required this.hotelName,
    required this.color,
    required this.checkInDate,
    required this.checkOutDate,
    required this.selectedRoom,
    required this.numberOfRooms,
  }) : super(key: key);

  @override
  State<GuestDetailsScreen> createState() => _GuestDetailsScreenState();
}

class _GuestDetailsScreenState extends State<GuestDetailsScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepColor = Colors.green;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Guest Details'),
        backgroundColor: stepColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: stepColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Booking for ${widget.hotelName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.numberOfRooms} ${widget.selectedRoom.name}',
              style: TextStyle(
                fontSize: 16,
                color: stepColor,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final guestInfo = {
                  'name': nameController.text.isEmpty ? 'Guest' : nameController.text,
                  'email': emailController.text.isEmpty ? 'guest@example.com' : emailController.text,
                };
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      hotelName: widget.hotelName,
                      color: widget.color,
                      checkInDate: widget.checkInDate,
                      checkOutDate: widget.checkOutDate,
                      selectedRoom: widget.selectedRoom,
                      numberOfRooms: widget.numberOfRooms,
                      guestInfo: guestInfo,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: stepColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Continue to Payment',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
