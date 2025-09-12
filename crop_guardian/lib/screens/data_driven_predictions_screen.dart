import 'package:flutter/material.dart';

class DataDrivenPredictionsScreen extends StatelessWidget {
  const DataDrivenPredictionsScreen({super.key});

  final List<_FeatureItem> features = const [
    _FeatureItem(
      title: 'Crop Yield Forecasting',
      description:
          'Analyze historical yields, rainfall, temperature, and soil data to predict crop output.',
      icon: Icons.assessment,
    ),
    _FeatureItem(
      title: 'Irrigation Recommendations',
      description:
          'Optimal watering schedules using soil moisture levels and past rainfall patterns.',
      icon: Icons.opacity,
    ),
    _FeatureItem(
      title: 'Fertilization Advice',
      description:
          'Based on soil nutrients, crop type, and growth stages to optimize fertilizer use.',
      icon: Icons.grass,
    ),
    _FeatureItem(
      title: 'Pest and Disease Alerts',
      description:
          'Risk alerts from regional patterns, weather, and crop type to protect crops.',
      icon: Icons.warning_amber_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data-Driven Predictions'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(feature.icon, color: Colors.green[700], size: 36),
              title: Text(
                feature.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(feature.description),
              onTap: () {
                // Expand with detailed page or actions
              },
            ),
          );
        },
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final String description;
  final IconData icon;

  const _FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
