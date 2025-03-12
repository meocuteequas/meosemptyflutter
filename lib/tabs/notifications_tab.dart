import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Notifications Tab',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
