// Import the Flutter Material library, which provides UI components and the Color class
import 'package:flutter/material.dart';

// Define a class called ColorModel to represent a color with its name
class ColorModel {
  // Declare a field to store the name of the color (immutable because of 'final')
  final String name;

  // Declare a field to store the actual Color object (immutable because of 'final')
  final Color color;

  // Constructor for the class with named parameters
  // 'required' ensures that both name and color must be provided when creating an object
  ColorModel({required this.name, required this.color});
}
