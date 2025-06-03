import 'package:flutter/material.dart';
import '../../widgets/app_routes.dart';
import '../../widgets/config.dart';

class ScanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> scan;
  const ScanDetailScreen({Key? key, required this.scan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scan['name'] ?? 'Scan'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (scan['image'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(scan['image'], height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 16),
                Text(scan['name'] ?? '', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                Text('Date : ${scan['date'] ?? ''}', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text('Lieu : ${scan['location'] ?? ''}', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text('Précision : ${scan['accuracy'] ?? ''}', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text('Détails animal : ${scan['animalDetails'] ?? ''}', style: AppTextStyles.body),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    icon: const Icon(Icons.pets, color: Colors.white),
                    label: Text('Voir la fiche animal', style: AppTextStyles.button.copyWith(color: Colors.white)),
                    onPressed: () {
                      final animalIdRaw = scan['animal_id'] ?? scan['id'];
                      final int? animalId = (animalIdRaw is int)
                          ? animalIdRaw
                          : (animalIdRaw is String ? int.tryParse(animalIdRaw) : null);
                      if (animalId != null) {
                        Navigator.pushNamed(context, AppRoutes.animalDetails, arguments: {
                          'animalId': animalId,
                          'animalImage': scan['image'],
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aucun identifiant animal valide pour la fiche détaillée.')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 