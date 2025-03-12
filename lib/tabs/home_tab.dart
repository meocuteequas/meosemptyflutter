import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final ScrollController scrollController;
  const HomeTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    // List of different colors for containers
    final List<Color> colors = [
      Colors.blue.shade300,
      Colors.red.shade300,
      Colors.green.shade300,
      Colors.amber.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
      Colors.indigo.shade300,
      Colors.orange.shade300,
    ];

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return Container(
          height: 600,
          color: colors[index],
          alignment: Alignment.center,
          child: Text(
            'Container ${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
