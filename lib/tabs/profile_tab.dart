import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Tab',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
