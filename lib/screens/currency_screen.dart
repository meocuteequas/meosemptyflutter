import 'package:flutter/material.dart';

class CurrencyScreen extends StatefulWidget {
  final String selectedCurrency;

  const CurrencyScreen({Key? key, this.selectedCurrency = 'USD'}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late String _selectedCurrency;

  // Currency data with colors
  final List<Map<String, dynamic>> currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$', 'color': Colors.green.shade600},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€', 'color': Colors.blue.shade600},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£', 'color': Colors.purple.shade600},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥', 'color': Colors.red.shade600},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$', 'color': Colors.orange.shade600},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$', 'color': Colors.amber.shade600},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥', 'color': Colors.pink.shade600},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹', 'color': Colors.indigo.shade600},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'symbol': 'S\$', 'color': Colors.teal.shade600},
    {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'Fr', 'color': Colors.deepOrange.shade600},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Select Currency'),
        centerTitle: false,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedCurrency);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            final currency = currencies[index];
            final bool isSelected = currency['code'] == _selectedCurrency;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCurrency = currency['code'] as String;
                });
                // Optionally auto-select and return after a short delay
                // Future.delayed(Duration(milliseconds: 300), () {
                //   Navigator.pop(context, _selectedCurrency);
                // });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: currency['color'].withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                  border: isSelected
                      ? Border.all(color: currency['color'], width: 2)
                      : Border.all(color: Colors.grey.shade200),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: currency['color'].withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                currency['symbol'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: currency['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currency['code'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: currency['color'],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
