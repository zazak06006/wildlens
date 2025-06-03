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
  String? _ecosystemName;
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
      String? ecosystemName;
      if (animal['ecosystem_id'] != null) {
        final eco = await ApiService().getEcosystem(animal['ecosystem_id']);
        ecosystemName = eco['name'] ?? null;
      }
      setState(() {
        _animalData = animal;
        _ecosystemName = ecosystemName;
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
                      _buildDetailsGrid(),
                      const SizedBox(height: 36),
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
                    _animalData?['scientific_name'] ?? '',
                    style: AppTextStyles.body.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if ((_animalData?['category'] ?? '').toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.category, size: 16, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            _animalData?['category'] ?? '',
                            style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),
                  if ((_animalData?['endangered'] ?? false) == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text(
                            'Espèce menacée',
                            style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Conservation status
            if ((_animalData?['conservation_status'] ?? '').toString().isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(_animalData?['conservation_status'] ?? '').withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: _getStatusColor(_animalData?['conservation_status'] ?? '').withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _animalData?['conservation_status'] ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: _getStatusColor(_animalData?['conservation_status'] ?? ''),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        if (_animalData?['tags'] != null && (_animalData?['tags'] as List).isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              children: (_animalData?['tags'] as List)
                  .map<Widget>((tag) => Chip(
                        label: Text(tag.toString()),
                        backgroundColor: AppColors.accent.withOpacity(0.15),
                        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.accent),
                      ))
                  .toList(),
            ),
          ),
        if (_animalData?['ecosystem_id'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(Icons.public, size: 16, color: AppColors.quaternary),
                const SizedBox(width: 4),
                Text(
                  _ecosystemName != null
                      ? 'Écosystème : \\$_ecosystemName'
                      : 'Écosystème inconnu',
                  style: AppTextStyles.caption.copyWith(color: AppColors.quaternary),
                ),
              ],
            ),
          ),
      ],
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
        _buildDetailCard("Empreinte", _animalData?['footprint_type'] ?? '', Icons.pets),
        if ((_animalData?['category'] ?? '').toString().isNotEmpty)
          _buildDetailCard("Catégorie", _animalData?['category'] ?? '', Icons.category),
        if ((_animalData?['conservation_status'] ?? '').toString().isNotEmpty)
          _buildDetailCard("Statut", _animalData?['conservation_status'] ?? '', Icons.shield),
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
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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