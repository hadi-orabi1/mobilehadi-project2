import 'package:flutter/material.dart';
import '../models/color_model.dart';
import '../widgets/color_card.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color? mixedColor;
  String? mixedName;

  // list available color

  final colors = [
    ColorModel(name: "Red", color: Colors.red),
    ColorModel(name: "Blue", color: Colors.blue),
    ColorModel(name: "Yellow", color: Colors.yellow),
    ColorModel(name: "Green", color: Colors.green),
    ColorModel(name: "Orange", color: Colors.orange),
    ColorModel(name: "Purple", color: Colors.purple),
    ColorModel(name: "Pink", color: Colors.pink),
    ColorModel(name: "Brown", color: Colors.brown),
    ColorModel(name: "Black", color: Colors.black),
    ColorModel(name: "White", color: Colors.white),
    ColorModel(name: "Cyan", color: Colors.cyan),
    ColorModel(name: "Indigo", color: Colors.indigo),
    ColorModel(name: "Grey", color: Colors.grey),
  ];

  ColorModel? firstColor;
  ColorModel? secondColor;
//// Helper function to generate a unique key for a pair of colors
  String _pairKey(String a, String b) {
    final list = [a.trim(), b.trim()]..sort();
    return '${list[0]}|${list[1]}';
  }

  
  final Map<String, ColorModel> mixTable = {
    "Blue|Red": ColorModel(name: "Purple", color: Colors.purple),
    "Red|Yellow": ColorModel(name: "Orange", color: Colors.orange),
    "Blue|Yellow": ColorModel(name: "Green", color: Colors.green),
    "Green|Yellow": ColorModel(name: "Lime", color: Colors.lightGreen),
    "Green|Red": ColorModel(name: "Brown", color: Colors.brown),
    "Blue|Green": ColorModel(name: "Teal", color: Colors.teal),
    "Pink|Purple": ColorModel(name: "Magenta", color: Colors.pinkAccent),
    "Orange|Pink": ColorModel(name: "Coral", color: Colors.deepOrange),
    "Indigo|Purple": ColorModel(name: "Violet", color: Colors.deepPurple),
    "Blue|Cyan": ColorModel(name: "Sky", color: Colors.lightBlue),
    "Cyan|Yellow": ColorModel(name: "Spring Green", color: Colors.lightGreenAccent),
    "Pink|Red": ColorModel(name: "Rose", color: Colors.redAccent),
    "Black|Indigo": ColorModel(name: "Midnight Indigo", color: Colors.indigo.shade900),
    "Grey|Cyan": ColorModel(name: "Steel Cyan", color: Colors.blueGrey),
    "Yellow|Orange": ColorModel(name: "Amber", color: Colors.amber),
    "Green|Orange": ColorModel(name: "Olive Orange", color: Colors.deepOrange.shade300),
    "Green|Purple": ColorModel(name: "Forest Violet", color: Colors.deepPurple.shade400),
    "Purple|Yellow": ColorModel(name: "Golden Violet", color: Colors.deepPurple.shade200),
    "Red|Orange": ColorModel(name: "Vermilion", color: Colors.deepOrange),
    "Red|White": ColorModel(name: "Light Red", color: Colors.red.shade200),
    "Blue|White": ColorModel(name: "Light Blue", color: Colors.blue.shade200),
    "Green|White": ColorModel(name: "Light Green", color: Colors.green.shade200),
    "Yellow|White": ColorModel(name: "Light Yellow", color: Colors.yellow.shade200),
    "Orange|White": ColorModel(name: "Peach", color: Colors.orange.shade200),
    "Purple|White": ColorModel(name: "Lavender", color: Colors.purple.shade200),
    "Pink|White": ColorModel(name: "Baby Pink", color: Colors.pink.shade100),
    "Brown|White": ColorModel(name: "Beige", color: Colors.brown.shade200),
    "Black|White": ColorModel(name: "Grey", color: Colors.grey),
    "Black|Red": ColorModel(name: "Dark Red", color: Colors.red.shade900),
    "Black|Blue": ColorModel(name: "Navy", color: Colors.blue.shade900),
    "Black|Green": ColorModel(name: "Dark Green", color: Colors.green.shade900),
    "Black|Yellow": ColorModel(name: "Olive", color: Colors.green.shade700),
    "Black|Orange": ColorModel(name: "Rust", color: Colors.deepOrange.shade900),
    "Black|Purple": ColorModel(name: "Eggplant", color: Colors.deepPurple.shade900),
    "Black|Pink": ColorModel(name: "Dark Pink", color: Colors.pink.shade900),
    "Black|Brown": ColorModel(name: "Chocolate", color: Colors.brown.shade900),
  };

  void selectColor(ColorModel color) {
    setState(() {
      if (firstColor == null) {
        firstColor = color;
      } else {
        secondColor = color;
        mixColors();
      }
    });
  }

  void mixColors() {
    if (firstColor != null && secondColor != null) {
      final key = _pairKey(firstColor!.name, secondColor!.name);
      final result = mixTable[key];

      if (result != null) {
        mixedColor = result.color;
        mixedName = result.name;
      } else {
        
        mixedColor = Color.lerp(firstColor!.color, secondColor!.color, 0.5);
        mixedName = "${firstColor!.name} + ${secondColor!.name}";
      }

      firstColor = null;
      secondColor = null;
    }
  }

  void resetMix() {
    setState(() {
      mixedColor = null;
      mixedName = null;
      firstColor = null;
      secondColor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Color Theory")),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: colors.map((c) {
                final isSelected = (firstColor == c || secondColor == c);
                return ColorCard(
                  colorModel: c,
                  onTap: () => selectColor(c),
                  isSelected: isSelected,
                );
              }).toList(),
            ),
          ),
          if (mixedColor != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: mixedColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Result: $mixedName",
                  style: TextStyle(
                    fontSize: 24,
                    color: mixedColor!.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (mixedColor != null)
            ElevatedButton.icon(
              onPressed: resetMix,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
