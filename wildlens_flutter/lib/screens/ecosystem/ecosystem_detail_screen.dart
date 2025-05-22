import 'package:flutter/material.dart';
import '../animals/animal_detail_screen.dart';
import '../animals/animals_screen.dart';
import '../../widgets/app_routes.dart';
import '../../widgets/config.dart';

class EcosystemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ecosystem;
  const EcosystemDetailScreen({Key? key, required this.ecosystem}) : super(key: key);

  // Mock animal data for demonstration
  List<Map<String, dynamic>> getAnimalsForEcosystem(String ecosystemName) {
    // In a real app, filter from a global animal list by ecosystem
    final allAnimals = [
      {
        'name': 'Loup Gris',
        'species': 'Canis lupus',
        'image': 'https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop',
        'ecosystem': 'Forêt Tempérée',
      },
      {
        'name': 'Fennec',
        'species': 'Vulpes zerda',
        'image': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
        'ecosystem': 'Savane Africaine',
      },
      {
        'name': 'Ours Brun',
        'species': 'Ursus arctos',
        'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop',
        'ecosystem': 'Forêt Tempérée',
      },
      {
        'name': 'Tigre',
        'species': 'Panthera tigris',
        'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?q=80&w=2670&auto=format&fit=crop',
        'ecosystem': 'Forêt Amazonienne',
      },
    ];
    return allAnimals.where((a) => a['ecosystem'] == ecosystemName).toList();
  }

  @override
  Widget build(BuildContext context) {
    final animals = getAnimalsForEcosystem(ecosystem['name'] ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(ecosystem['name'] ?? 'Écosystème'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (ecosystem['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(ecosystem['image'], height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text('Région : ${ecosystem['location'] ?? ''}', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          Text('Nombre d\'espèces : ${ecosystem['animals'] ?? ''}', style: AppTextStyles.body),
          const SizedBox(height: 24),
          Text('Animaux de cet écosystème', style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          ...animals.map((animal) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(animal['image'], width: 50, height: 50, fit: BoxFit.cover),
              ),
              title: Text(animal['name'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text(animal['species'], style: AppTextStyles.caption),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.animalDetails, arguments: {
                  'animalName': animal['name'],
                  'animalImage': animal['image'],
                });
              },
            ),
          )),
        ],
      ),
    );
  }
} 