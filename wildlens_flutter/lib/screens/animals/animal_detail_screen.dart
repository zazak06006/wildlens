import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:flutter_application_1/services/api_service.dart';

class AnimalDetailScreen extends StatefulWidget {
  final int animalId;
  final String animalImage;
  
  const AnimalDetailScreen({
    Key? key,
    required this.animalId,
    required this.animalImage,
  }) : super(key: key);

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  
  Map<String, dynamic>? _animalData;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    // Add haptic feedback for a more immersive experience
    HapticFeedback.lightImpact();
    _fetchAnimal();
  }
  
  Future<void> _fetchAnimal() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final animal = await ApiService().getAnimal(widget.animalId);
      setState(() {
        _animalData = animal;
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
              _animalData?['image'] ?? '',
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
        // Removed AR view button
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
                    _animalData?['name'] ?? '',
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _animalData?['scientificName'] ?? '',
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
                color: _getStatusColor(_animalData?['conservationStatus'] ?? '').withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(
                  color: _getStatusColor(_animalData?['conservationStatus'] ?? '').withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                _animalData?['conservationStatus'] ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: _getStatusColor(_animalData?['conservationStatus'] ?? ''),
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
            _animalData?['description'] ?? '',
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
        _buildDetailCard("Habitat", _animalData?['habitat'] ?? '', Icons.terrain),
        _buildDetailCard("Régime alimentaire", _animalData?['diet'] ?? '', Icons.restaurant),
        _buildDetailCard("Durée de vie", _animalData?['lifespan'] ?? '', Icons.access_time),
      ],
    );
  }
  
  // Single detail card
  Widget _buildDetailCard(String title, String content, IconData icon) {
    return FuturisticUI.glassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
                    _animalData?['footprintImageUrl'] ?? '',
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
                      "Les empreintes de ${_animalData?['name']} sont distinctives avec des coussinets "
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
    final facts = _animalData?['facts'] as List<String>? ?? [];
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