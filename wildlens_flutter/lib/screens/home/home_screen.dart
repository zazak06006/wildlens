import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  
  // Enhanced data models with more details
  final List<Map<String, dynamic>> _featuredAnimals = [
    {
      'name': 'Loup Gris',
      'species': 'Canis lupus',
      'image': 'https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop',
      'tags': ['Prédateur', 'Forêt', 'Mammifère'],
      'conservationStatus': 'Vulnérable',
      'habitat': 'Forêts tempérées et boréales',
      'footprintType': 'Digitigrade',
    },
    {
      'name': 'Fennec',
      'species': 'Vulpes zerda',
      'image': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
      'tags': ['Désert', 'Nocturne', 'Mammifère'],
      'conservationStatus': 'Préoccupation mineure',
      'habitat': 'Déserts nord-africains',
      'footprintType': 'Digitigrade',
    },
    {
      'name': 'Ours Brun',
      'species': 'Ursus arctos',
      'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop',
      'tags': ['Prédateur', 'Forêt', 'Mammifère'],
      'conservationStatus': 'Préoccupation mineure',
      'habitat': 'Forêts, montagnes et toundra',
      'footprintType': 'Plantigrade',
    },
    {
      'name': 'Tigre',
      'species': 'Panthera tigris',
      'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?q=80&w=2670&auto=format&fit=crop',
      'tags': ['Prédateur', 'Jungle', 'Mammifère'],
      'conservationStatus': 'En danger',
      'habitat': 'Forêts tropicales et de mangrove',
      'footprintType': 'Digitigrade',
    },
  ];
  
  final List<Map<String, dynamic>> _recentScans = [
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
  
  // Data for ecosystem section
  final List<Map<String, dynamic>> _ecosystems = [
    {
      'name': 'Forêt Tempérée',
      'animals': 42,
      'location': 'Europe',
      'image': 'https://images.unsplash.com/photo-1473773508845-188df298d2d1?q=80&w=2374&auto=format&fit=crop',
    },
    {
      'name': 'Savane Africaine',
      'animals': 56,
      'location': 'Afrique',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?q=80&w=2371&auto=format&fit=crop',
    },
    {
      'name': 'Forêt Amazonienne',
      'animals': 78,
      'location': 'Amérique du Sud',
      'image': 'https://images.unsplash.com/photo-1511497584788-876760111969?q=80&w=2371&auto=format&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    
    // Add haptic feedback on init for futuristic feel
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    // Add haptic feedback for interaction
    HapticFeedback.mediumImpact();
    
    setState(() => _selectedIndex = index);
    
    // For demo we only handle navigation to these screens
    switch (index) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.scan);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.animals);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.explore);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Animated background with particles effect
            _buildAnimatedBackground(),
            
            // Main content
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 80,
                      maxHeight: 80,
                      child: _buildAppBar(),
                    ),
                  ),
                  
                  // Welcome Message with time-based greeting
                  SliverToBoxAdapter(
                    child: _buildWelcomeMessage(),
                  ),
                  
                  // Content sections
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildActionButtons(),
                          const SizedBox(height: 30),
                          _buildSectionTitle("Animaux en Vedette", icon: Icons.star, onSeeAll: () {
                            Navigator.pushNamed(context, AppRoutes.animals);
                          }),
                          const SizedBox(height: 16),
                          _buildFeaturedAnimals(),
                          const SizedBox(height: 30),
                          _buildSectionTitle("Écosystèmes", icon: Icons.eco, onSeeAll: () {
                            Navigator.pushNamed(context, AppRoutes.explore);
                          }),
                          const SizedBox(height: 16),
                          _buildEcosystems(),
                          const SizedBox(height: 30),
                          _buildSectionTitle("Scans Récents", icon: Icons.history, onSeeAll: () {
                            Navigator.pushNamed(context, AppRoutes.scanList);
                          }),
                          const SizedBox(height: 16),
                          _buildRecentScans(),
                          const SizedBox(height: 30),
                          _buildVirtualGuideCard(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Floating quick scan button
            Positioned(
              right: 20,
              bottom: 90,
              child: _buildQuickScanButton(),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Build an enhanced app bar with glass effect
  Widget _buildAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: AppColors.primaryDark.withOpacity(0.7),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and title with animated glow
              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.cyberpunkGradient,
                            boxShadow: AppShadows.neonShadow,
                          ),
                          child: const Icon(
                            Icons.camera_enhance,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.accent,
                        AppColors.accentLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'WildLens',
                      style: AppTextStyles.heading.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Action buttons
              Row(
                children: [
                  _buildActionIconButton(
                    icon: Icons.notifications_outlined,
                    color: AppColors.accent,
                    onTap: () {
                      // Show notifications
                    },
                    hasNotification: true,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.glassGradient,
                        boxShadow: [AppShadows.small],
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.chatbot);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.glassGradient,
                        boxShadow: [AppShadows.small],
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.chat,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tertiary.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Build action buttons section with Scanner and secondary options
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main action button with scanning animation
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(context, AppRoutes.scan);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: AppGradients.cardGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: AppColors.accent.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Subtle scanning animation in background
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: _buildScanningAnimation(),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.accentGradient,
                          boxShadow: AppShadows.neonShadow,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Scanner une empreinte",
                              style: AppTextStyles.subheading,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Identifiez les animaux à partir de leurs traces",
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      // Arrow
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Secondary action buttons
        Row(
          children: [
            // Animals catalog
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, AppRoutes.animals);
                },
                child: FuturisticUI.holographicCard(
                  child: SizedBox(
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Catalogue",
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_featuredAnimals.length} espèces",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Explore map
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, AppRoutes.explore);
                },
                child: FuturisticUI.neonContainer(
                  neonColor: AppColors.quaternary,
                  child: SizedBox(
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          color: AppColors.quaternary,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Explorer",
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_ecosystems.length} écosystèmes",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Scanning animation overlay for the main scanner button
  Widget _buildScanningAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 4),
      curve: Curves.linear,
      builder: (context, value, child) {
        return CustomPaint(
          painter: ScanLinePainter(progress: value),
          child: Container(),
        );
      },
    );
  }

  // Build section title with icon and "see all" button
  Widget _buildSectionTitle(String title, {IconData? icon, required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppGradients.glassGradient,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: AppTextStyles.subheading,
            ),
          ],
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.circular),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              "Voir tout",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Enhanced featured animals carousel with parallax effect
  Widget _buildFeaturedAnimals() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _featuredAnimals.length,
        itemBuilder: (context, index) {
          final animal = _featuredAnimals[index];
          return _buildEnhancedAnimalCard(animal, index);
        },
      ),
    );
  }

  Widget _buildEnhancedAnimalCard(Map<String, dynamic> animal, int index) {
    final isFirst = index == 0;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(
          context,
          AppRoutes.animalDetails,
          arguments: {
            'animalName': animal['name'],
            'animalImage': animal['image'],
          },
        );
      },
      child: Container(
        width: 220,
        margin: EdgeInsets.only(
          right: 16,
          left: isFirst ? 4 : 0,
        ),
        decoration: BoxDecoration(
          gradient: AppGradients.cardGradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with parallax effect
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ).createShader(rect),
                  blendMode: BlendMode.darken,
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
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conservation status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getStatusColor(animal['conservationStatus']),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      animal['conservationStatus'],
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name and species
                  Text(
                    animal['name'],
                    style: AppTextStyles.subheading.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    animal['species'],
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // Habitat info
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.terrain,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          animal['habitat'],
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Add more info or subtle effects here for enhancement
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to get color based on conservation status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en danger critique':
        return AppColors.error;
      case 'en danger':
        return AppColors.tertiary;
      case 'vulnérable':
        return AppColors.warning;
      case 'préoccupation mineure':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }
  
  // Build ecosystems section
  Widget _buildEcosystems() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _ecosystems.length,
        itemBuilder: (context, index) {
          final ecosystem = _ecosystems[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ecosystemDetail, arguments: ecosystem);
            },
            child: Container(
              width: 220,
              margin: EdgeInsets.only(right: 16, left: index == 0 ? 4 : 0),
              child: _buildEcosystemCard(ecosystem),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEcosystemCard(Map<String, dynamic> ecosystem) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        image: DecorationImage(
          image: NetworkImage(ecosystem['image']),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
          child: Container(
            decoration: BoxDecoration(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  ecosystem['name'],
                  style: AppTextStyles.subheading.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Location and animal count
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ecosystem['location'],
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.pets,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${ecosystem['animals']} espèces",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Explore button
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Explorer",
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Recent scans list with enhanced UI
  Widget _buildRecentScans() {
    if (_recentScans.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun scan récent",
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentScans.length,
      itemBuilder: (context, index) {
        final scan = _recentScans[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.scanDetail, arguments: scan);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: FuturisticUI.glassContainer(
              blurAmount: 5,
              opacity: 0.05,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image with border
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [AppShadows.small],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      child: Image.network(
                        scan['image'],
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
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              scan['name'],
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                              ),
                              child: Text(
                                scan['accuracy'],
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scan['animalDetails'],
                          style: AppTextStyles.caption.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  scan['date'],
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      scan['location'],
                                      style: AppTextStyles.caption,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Options button
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      onPressed: () {
                        // Show options
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Virtual Guide feature card
  Widget _buildVirtualGuideCard() {
    return FuturisticUI.holographicCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.quaternary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.quaternary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.assistant,
                    color: AppColors.quaternary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guide Virtuel",
                        style: AppTextStyles.subheading.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Votre assistant personnel d'exploration",
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.quaternary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Besoin d'aide pour identifier une empreinte ? Posez une question au guide virtuel pour des informations détaillées sur les animaux et leurs habitats.",
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.quaternary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Posez votre question...",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.neonGradient,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16,
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
  
  // Quick scan floating button
  Widget _buildQuickScanButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.cyberpunkGradient,
              boxShadow: AppShadows.neonShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pushNamed(context, AppRoutes.scan);
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Enhanced bottom navigation bar with glass effect
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

  // Create an animated background with particle effect
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.backgroundGradient,
          ),
        ),
        
        // Particle overlay
        CustomPaint(
          painter: ParticlesPainter(
            animationValue: _animationController.value,
          ),
          child: Container(),
        ),
        
        // Grid lines overlay
        CustomPaint(
          painter: GridPainter(
            animationValue: _animationController.value,
          ),
          child: Container(),
        ),
        
        // Dark overlay from top to bottom
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDark.withOpacity(0.8),
                AppColors.primaryDark.withOpacity(0.0),
              ],
              stops: const [0.0, 0.3],
            ),
          ),
        ),
      ],
    );
  }
  
  // Build a welcome message with time-based greeting
  Widget _buildWelcomeMessage() {
    final hour = DateTime.now().hour;
    String greeting;
    IconData weatherIcon;
    
    if (hour < 12) {
      greeting = "Bonjour";
      weatherIcon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = "Bon après-midi";
      weatherIcon = Icons.wb_cloudy;
    } else {
      greeting = "Bonsoir";
      weatherIcon = Icons.nightlight_round;
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$greeting,",
                style: AppTextStyles.heading,
              ),
              const SizedBox(width: 8),
              Icon(
                weatherIcon,
                color: AppColors.energy,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Prêt à explorer la faune aujourd'hui ?",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
          ),
          
          // Stats summary for today
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("12", "Espèces\nidentifiées", Icons.pets),
                _buildDivider(),
                _buildStatItem("3", "Scans\naujourd'hui", Icons.camera_alt),
                _buildDivider(),
                _buildStatItem("86%", "Précision\nmoyenne", Icons.trending_up),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.accent,
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.subheading.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.accent.withOpacity(0.2),
    );
  }
}

// Custom painter for the scan line animation
class ScanLinePainter extends CustomPainter {
  final double progress;
  
  ScanLinePainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.accent.withOpacity(0.0),
          AppColors.accent.withOpacity(0.8),
          AppColors.accent.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Calculate scan line position
    final scanLineY = size.height * progress;
    
    // Draw the scan line
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      paint..strokeWidth = 2,
    );
    
    // Draw the glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withOpacity(0.3),
          AppColors.accent.withOpacity(0.0),
        ],
        radius: 0.5,
      ).createShader(Rect.fromLTWH(0, scanLineY - 20, size.width, 40));
    
    canvas.drawRect(
      Rect.fromLTWH(0, scanLineY - 20, size.width, 40),
      glowPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Custom painter for particle effects
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];
  
  ParticlesPainter({required this.animationValue}) {
    // Generate random particles
    if (particles.isEmpty) {
      for (int i = 0; i < 30; i++) {
        particles.add(Particle());
      }
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(
          (0.2 + 0.8 * math.sin((animationValue + particle.seed) * math.pi * 2)) * particle.opacity,
        );
      
      // Update position based on animation
      final x = (particle.x * size.width + 10 * math.sin((animationValue + particle.seed) * math.pi * 2));
      final y = (particle.y * size.height + 10 * math.cos((animationValue + particle.seed) * math.pi * 2));
      
      // Draw the particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Particle class for the background effect
class Particle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;
  final double seed;
  
  Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = 1 + math.Random().nextDouble() * 2,
        opacity = 0.1 + math.Random().nextDouble() * 0.4,
        seed = math.Random().nextDouble(),
        color = [
          AppColors.accent, 
          AppColors.secondary, 
          AppColors.quaternary
        ][math.Random().nextInt(3)];
}

// Custom painter for grid lines
class GridPainter extends CustomPainter {
  final double animationValue;
  
  GridPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.05)
      ..strokeWidth = 0.5;
    
    // Draw vertical lines
    final verticalLineCount = 20;
    final verticalLineSpacing = size.width / verticalLineCount;
    
    for (var i = 0; i < verticalLineCount; i++) {
      final x = i * verticalLineSpacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
    
    // Draw horizontal lines
    final horizontalLineCount = 30;
    final horizontalLineSpacing = size.height / horizontalLineCount;
    
    for (var i = 0; i < horizontalLineCount; i++) {
      final y = i * horizontalLineSpacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Draw glowing intersection points
    final pointPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.2 + 0.1 * math.sin(animationValue * math.pi));
    
    for (var i = 0; i < verticalLineCount; i++) {
      for (var j = 0; j < horizontalLineCount; j++) {
        final x = i * verticalLineSpacing;
        final y = j * horizontalLineSpacing;
        
        // Only draw some points for better performance
        if ((i + j) % 3 == 0) {
          canvas.drawCircle(
            Offset(x, y),
            1.0,
            pointPaint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Sliver app bar delegate for the persistent header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
} 