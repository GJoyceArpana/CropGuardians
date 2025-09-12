import 'package:flutter/material.dart';

class WeatherFeaturesScreen extends StatelessWidget {
  const WeatherFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather-Based Features'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.grain, color: Colors.blue),
              title: Text(
                'Rainfall Pattern Analysis',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Estimate precipitation trends and irrigation needs.'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.thermostat, color: Colors.redAccent),
              title: Text(
                'Temperature Forecasts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Used for yield predictions and stress management.'),
            ),
            // Add charts or offline data indicators here later
          ],
        ),
      ),
    );
  }
}
