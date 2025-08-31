import 'package:flutter/material.dart';

/// Utility class for safe color parsing and manipulation
class ColorUtils {
  /// Safely parses a hex color string to a Color object
  /// Returns a default color if parsing fails
  static Color parseHexColor(String? colorString, {Color defaultColor = Colors.grey}) {
    if (colorString == null || colorString.isEmpty) {
      return defaultColor;
    }
    
    try {
      String colorStr = colorString;
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.replaceFirst('#', '0xFF');
      }
      return Color(int.parse(colorStr));
    } catch (e) {
      // Return default color if parsing fails
      return defaultColor;
    }
  }

  /// Safely parses a hex color string with a specific default color
  static Color parseHexColorWithDefault(String? colorString, Color defaultColor) {
    return parseHexColor(colorString, defaultColor: defaultColor);
  }
}
