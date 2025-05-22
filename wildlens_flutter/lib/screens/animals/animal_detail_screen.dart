import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';

class AnimalDetailScreen extends StatefulWidget {
  final String animalName;
  final String animalImage;
  
  const AnimalDetailScreen({
    Key? key,
    required this.animalName,
    required this.animalImage,
  }) : super(key: key);

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Mock data for the selected animal
  late Map<String, dynamic> _animalData;
  
  @override
  void initState() {
    super.initState();
    // Add haptic feedback for a more immersive experience
    HapticFeedback.lightImpact();
    _initializeAnimalData();
  }
  
  void _initializeAnimalData() {
    // In a real app, this would fetch data from an API or database
    _animalData = {
      'name': widget.animalName,
      'image': widget.animalImage,
      'scientificName': _getScientificName(widget.animalName),
      'description': _getDescription(widget.animalName),
      'habitat': _getHabitat(widget.animalName),
      'diet': _getDiet(widget.animalName),
      'lifespan': _getLifespan(widget.animalName),
      'conservationStatus': _getConservationStatus(widget.animalName),
      'footprintImageUrl': 'https://images.unsplash.com/photo-1586180418055-27664f9c61c6?q=80&w=2670&auto=format&fit=crop',
      'facts': _getFacts(widget.animalName),
    };
  }
  
  String _getScientificName(String name) {
    // Mock data
    final mapping = {
      'Loup Gris': 'Canis lupus',
      'Ours Brun': 'Ursus arctos',
      'Renard Roux': 'Vulpes vulpes',
      'Lynx Boréal': 'Lynx lynx',
      'Aigle Royal': 'Aquila chrysaetos',
      'Vipère Aspic': 'Vipera aspis',
    };
    return mapping[name] ?? 'Scientificus unknownus';
  }
  
  String _getDescription(String name) {
    if (name.contains('Loup')) {
      return 'Le loup gris est un mammifère carnivore, le plus grand membre sauvage de la famille des canidés. Il vit et chasse en meute, se nourrissant principalement de grands ongulés. Son pelage est généralement gris mélangé à du fauve, mais peut varier considérablement.';
    } else if (name.contains('Ours')) {
      return 'L\'ours brun est un grand mammifère omnivore caractérisé par sa fourrure brune, sa bosse sur les épaules et ses griffes longues. Il est solitaire et territorial. Ses sens de l\'odorat et de l\'ouïe sont très développés.';
    } else if (name.contains('Renard')) {
      return 'Le renard roux est un petit canidé rusé et adaptable. Reconnaissable à sa fourrure rousse et sa queue touffue à bout blanc. Principalement nocturne et crépusculaire, c\'est un chasseur opportuniste qui s\'adapte facilement à de nombreux environnements.';
    } else {
      return 'Ce magnifique animal sauvage possède des caractéristiques uniques et fascinantes. Son adaptation à son environnement en fait un élément essentiel de l\'écosystème local.';
    }
  }
  
  String _getHabitat(String name) {
    if (name.contains('Loup')) {
      return 'Forêts tempérées, toundra, montagnes, prairies';
    } else if (name.contains('Ours')) {
      return 'Forêts, montagnes, toundra';
    } else if (name.contains('Renard')) {
      return 'Forêts, prairies, montagnes, zones urbaines';
    } else {
      return 'Écosystèmes variés';
    }
  }
  
  String _getDiet(String name) {
    if (name.contains('Loup')) {
      return 'Carnivore (cerfs, élans, castors, lièvres)';
    } else if (name.contains('Ours')) {
      return 'Omnivore (baies, noix, poissons, miel, petits mammifères)';
    } else if (name.contains('Renard')) {
      return 'Omnivore opportuniste (rongeurs, oiseaux, insectes, fruits)';
    } else {
      return 'Régime alimentaire varié';
    }
  }
  
  String _getLifespan(String name) {
    if (name.contains('Loup')) {
      return '6-8 ans (sauvage), jusqu\'à 15 ans (captivité)';
    } else if (name.contains('Ours')) {
      return '20-30 ans (sauvage et captivité)';
    } else if (name.contains('Renard')) {
      return '3-4 ans (sauvage), jusqu\'à 14 ans (captivité)';
    } else {
      return '10-15 ans en moyenne';
    }
  }
  
  String _getConservationStatus(String name) {
    if (name.contains('Loup')) {
      return 'Préoccupation mineure (LC)';
    } else if (name.contains('Lynx')) {
      return 'En danger (EN)';
    } else {
      return 'Préoccupation mineure (LC)';
    }
  }
  
  List<String> _getFacts(String name) {
    if (name.contains('Loup')) {
      return [
        'Peut parcourir jusqu\'à 20 km par jour',
        'Vitesse de pointe de 50-60 km/h',
        'La meute est dirigée par un couple alpha',
        'Communication complexe par vocalisations et langage corporel',
        'Territoire pouvant atteindre 1000 km²'
      ];
    } else if (name.contains('Ours')) {
      return [
        'Peut courir à 50 km/h malgré son poids',
        'Hibernation de 3 à 7 mois',
        'Excellents nageurs et grimpeurs',
        'Odorat 7 fois plus développé que celui d\'un chien',
        'Peut vivre jusqu\'à 30 ans dans la nature'
      ];
    } else if (name.contains('Renard')) {
      return [
        'Peut entendre des rongeurs sous terre',
        'Communique par aboiements et glapissements',
        'Excellente vision nocturne',
        'Stocke la nourriture excédentaire',
        'Monogame durant la saison de reproduction'
      ];
    } else {
      return [
        'Fait intéressant #1 sur cet animal',
        'Fait intéressant #2 sur cet animal',
        'Fait intéressant #3 sur cet animal'
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.backgroundGradient,
            ),
          ),
          
          // Main content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App bar with animal image
              _buildSliverAppBar(),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimalHeader(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                      const SizedBox(height: 24),
                      _buildDetailsGrid(),
                      const SizedBox(height: 24),
                      _buildFootprintSection(),
                      const SizedBox(height: 24),
                      _buildFactsSection(),
                      const SizedBox(height: 36),
                      _buildActionButtons(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // App bar with parallax image effect
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Animal image with gradient overlay
            Image.network(
              _animalData['image'],
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.cardDark,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                );
              },
            ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.5),
                    AppColors.background.withOpacity(0.9),
                    AppColors.background,
                  ],
                  stops: const [0.5, 0.75, 0.9, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        // AR view button
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(
              context,
              AppRoutes.arView,
              arguments: {
                'modelName': _animalData['name'].toString().toLowerCase().contains('loup') ? 'wolf' : 
                             _animalData['name'].toString().toLowerCase().contains('ours') ? 'bear' : 'fox',
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.view_in_ar,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
  
  // Animal name and scientific name
  Widget _buildAnimalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Name and scientific name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _animalData['name'],
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _animalData['scientificName'],
                    style: AppTextStyles.body.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conservation status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(_animalData['conservationStatus']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(
                  color: _getStatusColor(_animalData['conservationStatus']).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                _animalData['conservationStatus'],
                style: AppTextStyles.caption.copyWith(
                  color: _getStatusColor(_animalData['conservationStatus']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Description section
  Widget _buildDescriptionSection() {
    return FuturisticUI.glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: AppTextStyles.subheading.copyWith(
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _animalData['description'],
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
  
  // Details grid with habitat, diet, etc.
  Widget _buildDetailsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDetailCard("Habitat", _animalData['habitat'], Icons.terrain),
        _buildDetailCard("Régime alimentaire", _animalData['diet'], Icons.restaurant),
        _buildDetailCard("Durée de vie", _animalData['lifespan'], Icons.access_time),
        _buildDetailCard("Voir en 3D", "Réalité augmentée", Icons.view_in_ar, isActionCard: true),
      ],
    );
  }
  
  // Single detail card
  Widget _buildDetailCard(String title, String content, IconData icon, {bool isActionCard = false}) {
    return GestureDetector(
      onTap: isActionCard ? () {
        HapticFeedback.mediumImpact();
        Navigator.pushNamed(
          context,
          AppRoutes.arView,
          arguments: {
            'modelName': _animalData['name'].toString().toLowerCase().contains('loup') ? 'wolf' : 
                         _animalData['name'].toString().toLowerCase().contains('ours') ? 'bear' : 'fox',
          },
        );
      } : null,
      child: FuturisticUI.glassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isActionCard ? AppColors.secondary : AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: isActionCard ? AppColors.secondary : AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActionCard ? AppColors.secondary : Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  // Footprint section
  Widget _buildFootprintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Empreinte",
          style: AppTextStyles.subheading,
        ),
        const SizedBox(height: 16),
        FuturisticUI.neonContainer(
          neonColor: AppColors.accent,
          child: Row(
            children: [
              // Footprint image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    _animalData['footprintImageUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.cardDark,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Footprint info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Caractéristiques de l'empreinte",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Les empreintes de ${_animalData['name']} sont distinctives avec des coussinets "
                      "et griffes visibles. Généralement disposées en ligne droite lors "
                      "de la marche.",
                      style: AppTextStyles.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Facts section
  Widget _buildFactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Faits intéressants",
          style: AppTextStyles.subheading,
        ),
        const SizedBox(height: 16),
        ..._buildFactsList(),
      ],
    );
  }
  
  List<Widget> _buildFactsList() {
    final facts = _animalData['facts'] as List<String>;
    return facts.map((fact) => _buildFactItem(fact)).toList();
  }
  
  Widget _buildFactItem(String fact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.quaternary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.star,
                color: AppColors.quaternary,
                size: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
  
  // Action buttons at the bottom
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: FuturisticUI.techButton(
            label: "EXPLORER EN 3D",
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(
                context,
                AppRoutes.arView,
                arguments: {
                  'modelName': _animalData['name'].toString().toLowerCase().contains('loup') ? 'wolf' : 
                               _animalData['name'].toString().toLowerCase().contains('ours') ? 'bear' : 'fox',
                },
              );
            },
            icon: Icons.view_in_ar,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FuturisticUI.techButton(
            label: "PARTAGER",
            onPressed: () {
              HapticFeedback.mediumImpact();
              // Share functionality would go here
            },
            icon: Icons.share,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
  
  // Helper method to get color based on conservation status
  Color _getStatusColor(String status) {
    if (status.contains('En danger critique')) {
      return AppColors.error;
    } else if (status.contains('En danger')) {
      return AppColors.tertiary;
    } else if (status.contains('Vulnérable')) {
      return AppColors.warning;
    } else if (status.contains('Préoccupation mineure')) {
      return AppColors.success;
    } else {
      return AppColors.info;
    }
  }
} 