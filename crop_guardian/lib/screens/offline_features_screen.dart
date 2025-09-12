import 'package:flutter/material.dart';

class OfflineFeaturesScreen extends StatelessWidget {
  const OfflineFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline-First Features'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.storage, color: Colors.grey),
            title: Text(
              'Local Data Storage',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Store crop yields, soil data, and preferences locally.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.cloud_off, color: Colors.grey),
            title: Text(
              'Cached Weather Forecasts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle:
                Text('Access last known weather forecasts even when offline.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.computer, color: Colors.grey),
            title: Text(
              'On-device Model Inference',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
                'Compute predictions using pre-trained models without internet.'),
          ),
        ],
      ),
    );
  }
}
