import 'package:flutter/material.dart';

class SoilFieldInsightsScreen extends StatelessWidget {
  const SoilFieldInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example soil data — replace with real data fetching later
    final soilMetrics = {
      'pH Level': '6.5 (Optimal)',
      'Nitrogen (N)': '45 mg/kg',
      'Phosphorus (P)': '30 mg/kg',
      'Potassium (K)': '25 mg/kg',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil & Field Insights'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Soil Health Analysis',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...soilMetrics.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text('${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 16)),
                )),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.timeline, color: Colors.green),
                title: const Text('Field Condition Tracking'),
                subtitle:
                    const Text('View historical trends of soil fertility over time.'),
                onTap: () {
                  // TBD: navigate to trends screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
