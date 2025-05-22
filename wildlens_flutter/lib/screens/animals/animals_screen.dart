import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({Key? key}) : super(key: key);

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late AnimationController _animationController;
  String _selectedCategory = "Tous";
  final List<String> _categories = ["Tous", "Mammifères", "Oiseaux", "Reptiles", "Amphibiens"];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for animals
  final List<Map<String, dynamic>> _animalsList = [
    {
      'name': 'Loup Gris',
      'scientific': 'Canis lupus',
      'category': 'Mammifères',
      'image': 'https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop',
      'endangered': true,
    },
    {
      'name': 'Ours Brun',
      'scientific': 'Ursus arctos',
      'category': 'Mammifères',
      'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop',
      'endangered': false,
    },
    {
      'name': 'Renard Roux',
      'scientific': 'Vulpes vulpes',
      'category': 'Mammifères',
      'image': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
      'endangered': false,
    },
    {
      'name': 'Lynx Boréal',
      'scientific': 'Lynx lynx',
      'category': 'Mammifères',
      'image': 'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=2574&auto=format&fit=crop',
      'endangered': true,
    },
    {
      'name': 'Aigle Royal',
      'scientific': 'Aquila chrysaetos',
      'category': 'Oiseaux',
      'image': 'https://images.unsplash.com/photo-1611689342806-0863700ce1e4?q=80&w=2651&auto=format&fit=crop',
      'endangered': false,
    },
    {
      'name': 'Vipère Aspic',
      'scientific': 'Vipera aspis',
      'category': 'Reptiles',
      'image': 'https://images.unsplash.com/photo-1581879003843-bfc3f6f38f2d?q=80&w=2574&auto=format&fit=crop',
      'endangered': false,
    },
  ];

  // Filtered animals based on category and search
  List<Map<String, dynamic>> get _filteredAnimals {
    return _animalsList.where((animal) {
      // Filter by category
      final categoryMatch = _selectedCategory == "Tous" || animal['category'] == _selectedCategory;
      
      // Filter by search text
      final searchMatch = _searchController.text.isEmpty || 
          animal['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          animal['scientific'].toLowerCase().contains(_searchController.text.toLowerCase());
      
      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animationController.forward(from: 0.0);
    
    // Add haptic feedback for a more immersive experience
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
    
    // Navigate based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.scan);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.explore);
        break;
    }
  }

  void _selectCategory(String category) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategory = category;
    });
  }

  void _toggleSearch() {
    HapticFeedback.selectionClick();
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background with particle effect
          _buildBackgroundEffect(),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(),
                
                // Category tabs
                _buildCategoryTabs(),
                
                // Main content area
                Expanded(
                  child: _buildAnimalsList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  // Animated background with particle effect
  Widget _buildBackgroundEffect() {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.backgroundGradient,
          ),
        ),
        
        // Animated particle overlay
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AnimalsParticlePainter(
                animationValue: _animationController.value,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
  
  // Top bar with title and search
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button (if needed)
              const SizedBox(width: 40), // Placeholder for alignment
              
              // Title
              Text(
                "Catalogue Animalier",
                style: AppTextStyles.heading.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Search button
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSearching ? AppColors.accent.withOpacity(0.2) : AppColors.accent.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          // Search bar (animated)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearching ? 50 : 0,
            curve: Curves.easeInOut,
            child: _isSearching ? _buildSearchBar() : null,
          ),
        ],
      ),
    );
  }
  
  // Search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FuturisticUI.glassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _searchController,
          style: AppTextStyles.body.copyWith(color: Colors.white),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: "Rechercher un animal...",
            hintStyle: AppTextStyles.body.copyWith(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: AppColors.accent),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.accent),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
  
  // Category tabs
  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () => _selectCategory(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent.withOpacity(0.2) : AppColors.cardDark.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.accent : Colors.white.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Animals grid
  Widget _buildAnimalsList() {
    final animals = _filteredAnimals;
    
    if (animals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: Colors.white.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun animal trouvé",
              style: AppTextStyles.subheading.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Essayez une autre recherche ou catégorie",
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return _buildAnimalCard(animal);
      },
    );
  }
  
  // Animal card
  Widget _buildAnimalCard(Map<String, dynamic> animal) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.pushNamed(
          context,
          AppRoutes.animalDetails,
          arguments: {
            'animalName': animal['name'],
            'animalImage': animal['image'],
          },
        );
      },
      child: FuturisticUI.holographicCard(
        child: Stack(
          children: [
            // Animal image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.network(
                  animal['image'],
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
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            
            // Animal info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal['name'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      animal['scientific'],
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Category tag
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: AppColors.quaternary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  animal['category'],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.quaternary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            
            // Endangered status
            if (animal['endangered'] == true)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Menacé",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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

// Custom painter for particle effects
class AnimalsParticlePainter extends CustomPainter {
  final double animationValue;
  final List<AnimalsParticle> particles = [];
  
  AnimalsParticlePainter({required this.animationValue}) {
    // Generate random particles
    if (particles.isEmpty) {
      for (int i = 0; i < 30; i++) {
        particles.add(AnimalsParticle());
      }
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(
          (0.2 + 0.3 * math.sin((animationValue + particle.seed) * math.pi * 2)) * particle.opacity,
        );
      
      // Update position based on animation
      final x = (particle.x * size.width + 5 * math.sin((animationValue + particle.seed) * math.pi * 2));
      final y = (particle.y * size.height + 5 * math.cos((animationValue + particle.seed) * math.pi * 2));
      
      // Draw the particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size * 0.7,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant AnimalsParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Particle class for the animal screen
class AnimalsParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;
  final double seed;
  
  AnimalsParticle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = 1 + math.Random().nextDouble() * 2,
        opacity = 0.1 + math.Random().nextDouble() * 0.3,
        seed = math.Random().nextDouble(),
        color = [
          AppColors.accent, 
          AppColors.secondary, 
          AppColors.quaternary
        ][math.Random().nextInt(3)];
} 