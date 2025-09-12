import 'package:flutter/material.dart';

class AlertsNotificationsScreen extends StatelessWidget {
  const AlertsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.redAccent),
            title: const Text(
              'Pest Alerts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: const Text(
                'Receive pest alerts updated online and accessible offline.'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.water_drop, color: Colors.blueAccent),
            title: const Text(
              'Fertilization & Irrigation Alerts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: const Text(
                'Scheduled alerts based on soil and weather data, tailored for your crops.'),
          ),
        ],
      ),
    );
  }
}
