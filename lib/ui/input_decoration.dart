import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    required Color color,
    IconData? prefixIcon,
    Color? borderColor,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: borderColor != null
            ? BorderSide(color: borderColor, width: 2.0)
            : BorderSide(color: Colors.lightBlue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      labelText: labelText,
      labelStyle: TextStyle(color: color),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: color,
            )
          : null,
    );
  }
}
