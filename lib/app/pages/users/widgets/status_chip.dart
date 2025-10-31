import 'package:flutter/material.dart';

class TDStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const TDStatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}


