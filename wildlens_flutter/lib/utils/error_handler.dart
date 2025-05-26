import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${error.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static Widget buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
