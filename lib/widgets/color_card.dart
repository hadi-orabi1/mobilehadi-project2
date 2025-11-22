import 'package:flutter/material.dart';
import '../models/color_model.dart';

class ColorCard extends StatelessWidget {
  final ColorModel colorModel;
  final VoidCallback onTap;
  final bool isSelected;

  const ColorCard({
    super.key,
    required this.colorModel,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorModel.color,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.black, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            colorModel.name,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
