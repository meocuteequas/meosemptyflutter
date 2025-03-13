import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room.dart';
import 'dart:math';
import 'order_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String hotelName;
  final Color color;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final Room selectedRoom;
  final int numberOfRooms;
  final Map<String, String> guestInfo;

  const PaymentScreen({
    Key? key,
    required this.hotelName,
    required this.color,
    required this.checkInDate,
    required this.checkOutDate,
    required this.selectedRoom,
    required this.numberOfRooms,
    required this.guestInfo,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  bool _paymentComplete = false;
  String _bookingReference = '';
  // Add payment method selection
  String _selectedPaymentMethod = 'credit_card';

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _paymentComplete = true;
          // Generate random booking reference
          final random = Random();
          _bookingReference = 'BK${random.nextInt(10000).toString().padLeft(4, '0')}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepColor = Colors.purple;
    final totalPrice = widget.selectedRoom.price * widget.numberOfRooms;

    // If payment is complete, show success message
    if (_paymentComplete) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Confirmed'),
          backgroundColor: stepColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Booking Reference: $_bookingReference',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Payment Method: ${_selectedPaymentMethod == 'credit_card' ? 'Credit Card' : 'Cryptocurrency'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(
                        hotelName: widget.hotelName,
                        bookingReference: _bookingReference,
                        checkInDate: widget.checkInDate,
                        checkOutDate: widget.checkOutDate,
                        roomDetails: widget.selectedRoom,
                        numberOfRooms: widget.numberOfRooms,
                        guestInfo: widget.guestInfo,
                        paymentMethod: _selectedPaymentMethod,
                        color: widget.color,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: stepColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'View Order Details',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Payment'),
        backgroundColor: stepColor,
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Processing Payment...',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      size: 80,
                      color: stepColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.hotelName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${widget.numberOfRooms} × ${widget.selectedRoom.name}',
                      style: TextStyle(
                        fontSize: 18,
                        color: stepColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Payment method selection
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Credit Card option
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Card(
                        elevation: _selectedPaymentMethod == 'credit_card' ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _selectedPaymentMethod == 'credit_card' 
                                ? stepColor 
                                : Colors.grey.shade300,
                            width: _selectedPaymentMethod == 'credit_card' ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => setState(() => _selectedPaymentMethod = 'credit_card'),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(Icons.credit_card, 
                                  color: _selectedPaymentMethod == 'credit_card' ? stepColor : Colors.grey,
                                  size: 32,
                                ),
                                const SizedBox(width: 15),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Credit Card',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Pay with Visa, Mastercard, or Amex',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedPaymentMethod == 'credit_card')
                                  Icon(Icons.check_circle, color: stepColor)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Cryptocurrency option
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Card(
                        elevation: _selectedPaymentMethod == 'crypto' ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _selectedPaymentMethod == 'crypto' 
                                ? stepColor 
                                : Colors.grey.shade300,
                            width: _selectedPaymentMethod == 'crypto' ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => setState(() => _selectedPaymentMethod = 'crypto'),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(Icons.currency_bitcoin, 
                                  color: _selectedPaymentMethod == 'crypto' ? stepColor : Colors.grey,
                                  size: 32,
                                ),
                                const SizedBox(width: 15),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cryptocurrency',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Pay with Bitcoin, Ethereum, or USDC',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedPaymentMethod == 'crypto')
                                  Icon(Icons.check_circle, color: stepColor)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Show payment details based on selected method
                    _buildPaymentDetails(stepColor, totalPrice),
                    
                    const SizedBox(height: 40),
                    
                    // Pay button
                    ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: stepColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        _selectedPaymentMethod == 'credit_card' ? 'Pay Now' : 'Pay with Crypto',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPaymentDetails(Color stepColor, double totalPrice) {
    if (_selectedPaymentMethod == 'credit_card') {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card),
                  SizedBox(width: 10),
                  Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Room Price:', style: TextStyle(fontSize: 16)),
                  Text('\$${totalPrice.toInt()}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Taxes & Fees:', style: TextStyle(fontSize: 16)),
                  Text('\$${(totalPrice * 0.1).toInt()}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '\$${(totalPrice * 1.1).toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: stepColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.currency_bitcoin),
                  SizedBox(width: 10),
                  Text(
                    'Crypto Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Room Price:', style: TextStyle(fontSize: 16)),
                  Text('\$${totalPrice.toInt()}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Crypto Discount:', style: TextStyle(fontSize: 16, color: Colors.green)),
                  Text('-\$${(totalPrice * 0.05).toInt()}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '\$${(totalPrice * 0.95).toInt()} (≈ 0.0${(totalPrice * 0.95 / 29000).toStringAsFixed(4)} BTC)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: stepColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Center(
                child: Column(
                  children: [
                    Text('Scan QR code to pay', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                    Icon(Icons.qr_code, size: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
