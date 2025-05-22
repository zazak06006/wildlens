import 'package:flutter/material.dart';
import '../../widgets/app_routes.dart';
import '../../widgets/config.dart';

class ScanListScreen extends StatelessWidget {
  const ScanListScreen({Key? key}) : super(key: key);

  // Use the same mock data as the home page
  List<Map<String, dynamic>> get recentScans => [
    {
      'name': 'Empreinte de Cerf',
      'date': 'Il y a 2 jours',
      'location': 'Forêt de Fontainebleau',
      'image': 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=2787&auto=format&fit=crop',
      'accuracy': '95%',
      'animalDetails': 'Cervus elaphus',
    },
    {
      'name': 'Trace de Renard',
      'date': 'Il y a 1 semaine',
      'location': 'Parc Naturel Régional',
      'image': 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?q=80&w=2787&auto=format&fit=crop',
      'accuracy': '87%',
      'animalDetails': 'Vulpes vulpes',
    },
    {
      'name': 'Empreinte de Loup',
      'date': 'Il y a 2 semaines',
      'location': 'Massif des Vosges',
      'image': 'https://images.unsplash.com/photo-1586180418055-27664f9c61c6?q=80&w=2670&auto=format&fit=crop',
      'accuracy': '92%',
      'animalDetails': 'Canis lupus',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scans = recentScans;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des scans'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scans.length,
        itemBuilder: (context, index) {
          final scan = scans[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(scan['image'], width: 50, height: 50, fit: BoxFit.cover),
              ),
              title: Text(scan['name'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text(scan['date'], style: AppTextStyles.caption),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.scanDetail, arguments: scan);
              },
            ),
          );
        },
      ),
    );
  }
} 