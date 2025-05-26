import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedIndex = 3;
  List<dynamic> _ecosystems = [];
  bool _isLoading = true;
  String? _error;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    HapticFeedback.selectionClick();
    
    // Navigate based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.scan);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.animals);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    _fetchEcosystems();
  }

  Future<void> _fetchEcosystems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final ecosystems = await ApiService().getEcosystems();
      setState(() {
        _ecosystems = ecosystems;
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
          SafeArea(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(),
                
                // Map placeholder
                _buildMapView(),
                
                // Ecosystem list
                Expanded(
                  child: _buildEcosystemsList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  // Top bar with title and actions
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (if needed)
          const SizedBox(width: 40), // Placeholder for alignment
          
          // Title
          Text(
            "Explorer les Écosystèmes",
            style: AppTextStyles.heading.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Filter button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.1),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.accent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
  
  // Map view placeholder
  Widget _buildMapView() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // Map image placeholder
            Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2574&auto=format&fit=crop',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            
            // Overlay with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primaryDark.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
            
            // Map UI elements
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Map controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Icons.zoom_out,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  
                  // Map info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          color: AppColors.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "5 écosystèmes explorables",
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Ecosystems list
  Widget _buildEcosystemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            "Écosystèmes disponibles",
            style: AppTextStyles.subheading,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Text(
                      _error!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _ecosystems.length,
                      itemBuilder: (context, index) {
                        final ecosystem = _ecosystems[index];
                        return _buildEcosystemCard(ecosystem);
                      },
                    ),
        ),
      ],
    );
  }
  
  // Ecosystem card
  Widget _buildEcosystemCard(dynamic ecosystem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: FuturisticUI.glowCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ecosystem image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  ecosystem['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Ecosystem info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ecosystem['name'],
                    style: AppTextStyles.subheading.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ecosystem['location'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ecosystem['description'],
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.quaternary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pets,
                              color: AppColors.quaternary,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${ecosystem['animals']} animaux",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.quaternary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          "Explorer",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Enhanced bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardDark.withOpacity(0.8),
            border: Border(
              top: BorderSide(
                color: AppColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, "Accueil"),
                _buildNavItem(1, Icons.camera_alt, "Scanner"),
                _buildNavItem(2, Icons.pets, "Animaux"),
                _buildNavItem(3, Icons.explore, "Explorer"),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = index == _selectedIndex;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 54,
            height: 42,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? AppColors.accent.withOpacity(0.3) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 