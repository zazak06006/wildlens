import 'package:flutter/material.dart';
import '../animals/animal_detail_screen.dart';
import '../animals/animals_screen.dart';
import '../../widgets/app_routes.dart';
import '../../widgets/config.dart';
import '../../services/api_service.dart';

class EcosystemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ecosystem;
  const EcosystemDetailScreen({Key? key, required this.ecosystem}) : super(key: key);
  @override
  State<EcosystemDetailScreen> createState() => _EcosystemDetailScreenState();
}

class _EcosystemDetailScreenState extends State<EcosystemDetailScreen> {
  List<dynamic> _animals = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  Future<void> _fetchAnimals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final animals = await ApiService().getAnimals();
      setState(() {
        _animals = animals.where((a) => a['ecosystem'] == widget.ecosystem['name']).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ecosystem['name'] ?? 'Écosystème'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    if (widget.ecosystem['image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(widget.ecosystem['image'], height: 200, width: double.infinity, fit: BoxFit.cover),
                      ),
                    const SizedBox(height: 16),
                    Text('Région : ${widget.ecosystem['location'] ?? ''}', style: AppTextStyles.heading),
                    const SizedBox(height: 8),
                    Text('Nombre d\'espèces : ${widget.ecosystem['animals'] ?? ''}', style: AppTextStyles.body),
                    const SizedBox(height: 24),
                    Text('Animaux de cet écosystème', style: AppTextStyles.subheading),
                    const SizedBox(height: 12),
                    ..._animals.map((animal) => Card(
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