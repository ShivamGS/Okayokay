import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.info, color: Colors.white), // Custom icon
          SizedBox(width: 8), // Add spacing
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.blue, // Background color
      duration: Duration(
          seconds: 3), // Duration for how long the snack bar is displayed
      action: SnackBarAction(
        label: 'Close', // Custom action label
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
