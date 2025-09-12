import 'package:flutter/material.dart';

class UserAccessibilityScreen extends StatelessWidget {
  const UserAccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accessibility'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'This screen will provide options for regional language interfaces '
            'and other accessibility features.\n\n'
            'All translations and alerts will be stored locally for offline use.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
