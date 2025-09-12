import 'package:flutter/material.dart';

class ActionableRecommendationsScreen extends StatelessWidget {
  const ActionableRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actionable Recommendations'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.agriculture, color: Colors.orange),
            title: Text(
              'Crop-Specific Advisory',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Guidelines depending on crop type and growth stage.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_pin, color: Colors.teal),
            title: Text(
              'Regional Adaptation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Recommendations tailored to local climate and soil conditions.'),
          ),
        ],
      ),
    );
  }
}
