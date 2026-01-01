// Import Flutter Material library (provides widgets, colors, themes, etc.)
import 'package:flutter/material.dart';

// Import your custom ColorModel class (represents a color with name + Color object)
import '../models/color_model.dart';

// Define a stateless widget called ColorCard (no internal state needed)
class ColorCard extends StatelessWidget {
  // The ColorModel object that holds the color and its name
  final ColorModel colorModel;

  // Callback function triggered when the card is tapped
  final VoidCallback onTap;

  // Boolean to check if this card is currently selected
  final bool isSelected;

  // Constructor with required parameters
  const ColorCard({
    super.key,
    required this.colorModel,
    required this.onTap,
    this.isSelected = false, // default value is false
  });

  // Build method: describes how the UI of the card looks
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect taps on the card and call the onTap function
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10), // space outside the card
        padding: const EdgeInsets.all(20), // space inside the card
        decoration: BoxDecoration(
          color: colorModel.color, // background color from ColorModel
          borderRadius: BorderRadius.circular(16), // rounded corners
          border: isSelected
              ? Border.all(color: Colors.black, width: 3) // highlight if selected
              : null, // no border if not selected
        ),
        child: Center(
          // Display the color name in the center
          child: Text(
            colorModel.name, // text from ColorModel
            style: const TextStyle(
              fontSize: 22, // font size
              color: Colors.white, // text color
              fontWeight: FontWeight.bold, // bold text
            ),
          ),
        ),
      ),
    );
  }
}
