import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';

class ARViewScreen extends StatefulWidget {
  final String modelName;
  
  const ARViewScreen({
    Key? key,
    required this.modelName,
  }) : super(key: key);

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isInfoVisible = false;
  final double _rotationValue = 0.0;
  final double _zoomValue = 1.0;
  
  // Mockup animal model information
  late Map<String, dynamic> _animalInfo;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    
    // Mock data based on model name
    _initializeAnimalData();
    
    // Configure system UI for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  void _initializeAnimalData() {
    // This would connect to a real AR system in production
    // Using mock data for demonstration
    final animalData = {
      'wolf': {
        'name': 'Loup Gris',
        'scientificName': 'Canis lupus',
        'description': 'Le loup gris est un mammifère carnivore, le plus grand membre sauvage de la famille des canidés. Il vit et chasse en meute, se nourrissant principalement de grands ongulés.',
        'habitat': 'Forêts tempérées, toundra, montagnes, prairies',
        'diet': 'Carnivore',
        'imageUrl': 'https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop',
        'footprintImageUrl': 'https://images.unsplash.com/photo-1586180418055-27664f9c61c6?q=80&w=2670&auto=format&fit=crop',
        'facts': [
          'Peut parcourir jusqu\'à 20 km par jour',
          'Vitesse de pointe de 50-60 km/h',
          'Durée de vie de 6 à 8 ans dans la nature',
          'La meute est dirigée par un couple alpha',
        ],
      },
      'bear': {
        'name': 'Ours Brun',
        'scientificName': 'Ursus arctos',
        'description': 'L\'ours brun est un grand mammifère omnivore caractérisé par sa fourrure brune, sa bosse sur les épaules et ses griffes longues. Il est solitaire et territorial.',
        'habitat': 'Forêts, montagnes, toundra',
        'diet': 'Omnivore',
        'imageUrl': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop',
        'footprintImageUrl': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop',
        'facts': [
          'Peut courir à 50 km/h malgré son poids',
          'Hibernation de 3 à 7 mois',
          'Excellents nageurs et grimpeurs',
          'Odorat 7 fois plus développé que celui d\'un chien',
        ],
      },
      'fox': {
        'name': 'Renard Roux',
        'scientificName': 'Vulpes vulpes',
        'description': 'Le renard roux est un petit canidé rusé et adaptable. Reconnaissable à sa fourrure rousse et sa queue touffue à bout blanc. Principalement nocturne et crépusculaire.',
        'habitat': 'Forêts, prairies, montagnes, zones urbaines',
        'diet': 'Omnivore opportuniste',
        'imageUrl': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
        'footprintImageUrl': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
        'facts': [
          'Peut entendre des rongeurs sous terre',
          'Communique par aboiements et glapissements',
          'Excellente vision nocturne',
          'Stocke la nourriture excédentaire',
        ],
      },
    };
    
    // Default to wolf if model not found
    _animalInfo = animalData[widget.modelName.toLowerCase()] ?? animalData['wolf']!;
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // AR View background (simulated)
          _buildARView(),
          
          // Interface overlay
          SafeArea(
            child: Column(
              children: [
                // Top controls
                _buildTopControls(),
                
                const Spacer(),
                
                // Bottom info panel
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isInfoVisible ? 350 : 80,
                  curve: Curves.easeInOut,
                  child: _buildInfoPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Simulated AR view with 3D animal model
  Widget _buildARView() {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF121212),
                Color(0xFF0A1428),
              ],
            ),
          ),
        ),
        
        // Grid floor
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: CustomPaint(
            painter: ARGridPainter(
              animationValue: _animationController.value,
            ),
            child: Container(),
          ),
        ),
        
        // 3D model (simulated with image)
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value * _zoomValue,
                child: Transform.rotate(
                  angle: _rotationValue,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animal image with shadow (simulating 3D)
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(_animalInfo['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      // Scanning effect
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: ARScanPainter(
                                progress: _animationController.value,
                              ),
                              child: Container(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Particle overlay
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ARParticlePainter(
                  animationValue: _animationController.value,
                ),
                child: Container(),
              );
            },
          ),
        ),
        
        // Target indicators on floor (simulating AR placement)
        Positioned(
          bottom: 150,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.5),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Top controls for AR view
  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          
          // AR view title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppRadius.circular),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.view_in_ar,
                  color: AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Mode AR",
                  style: AppTextStyles.mono.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Settings button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
  
  // Bottom info panel with animal details
  Widget _buildInfoPanel() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) {
          setState(() => _isInfoVisible = true);
        } else if (details.delta.dy > 5) {
          setState(() => _isInfoVisible = false);
        }
      },
      onTap: () {
        setState(() => _isInfoVisible = !_isInfoVisible);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Pull handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _animalInfo['name'],
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _animalInfo['scientificName'],
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.circular),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "SCANNÉ",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (_isInfoVisible) ...[
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Text(
                            _animalInfo['description'],
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Data panels
                          Row(
                            children: [
                              Expanded(
                                child: _buildDataItem(
                                  "Habitat",
                                  _animalInfo['habitat'],
                                  Icons.terrain,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDataItem(
                                  "Régime",
                                  _animalInfo['diet'],
                                  Icons.restaurant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Facts title
                          Text(
                            "Faits intéressants",
                            style: AppTextStyles.subheading.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Facts list
                          ...(_animalInfo['facts'] as List).map((fact) => _buildFactItem(fact)),
                          
                          const SizedBox(height: 20),
                          
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  "Capture",
                                  Icons.camera_alt,
                                  AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildActionButton(
                                  "Partager",
                                  Icons.share,
                                  AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDataItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFactItem(String fact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            color: AppColors.quaternary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fact,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for AR grid floor
class ARGridPainter extends CustomPainter {
  final double animationValue;
  
  ARGridPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..strokeWidth = 0.5;
    
    // Draw receding grid effect
    final gridSpacing = 20.0;
    final disappearPoint = size.height / 2;
    
    // Draw horizontal lines
    for (var i = 0; i < 20; i++) {
      final y = i * gridSpacing;
      final t = y / size.height;
      final perspectiveWidth = size.width * (1 - t * 0.8);
      final leftX = (size.width - perspectiveWidth) / 2;
      
      // Make lines pulse with animation
      gridPaint.color = AppColors.accent.withOpacity(
        0.3 * (1 - t) * (0.7 + 0.3 * math.sin((animationValue + t) * math.pi * 2)),
      );
      
      canvas.drawLine(
        Offset(leftX, y),
        Offset(leftX + perspectiveWidth, y),
        gridPaint,
      );
    }
    
    // Draw vertical lines in perspective
    final verticalCount = 30;
    final verticalSpacing = size.width / verticalCount;
    
    for (var i = 0; i <= verticalCount; i++) {
      final normalizedX = i / verticalCount;
      final startX = normalizedX * size.width;
      
      // Create perspective effect
      final endX = size.width / 2 + (normalizedX - 0.5) * size.width * 0.2;
      
      gridPaint.color = AppColors.accent.withOpacity(
        0.3 * (0.7 + 0.3 * math.sin((animationValue + normalizedX) * math.pi * 2)),
      );
      
      canvas.drawLine(
        Offset(startX, 0),
        Offset(endX, disappearPoint),
        gridPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ARGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Custom painter for AR scanning effect
class ARScanPainter extends CustomPainter {
  final double progress;
  
  ARScanPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final scanPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Draw scanning circle
    final scanRadius = radius * (0.2 + 0.8 * progress);
    canvas.drawCircle(center, scanRadius, scanPaint);
    
    // Draw scan lines
    final linePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withOpacity(0.7),
          AppColors.accent.withOpacity(0.0),
        ],
        radius: 0.5,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // Horizontal scan line
    canvas.drawLine(
      Offset(center.dx - radius * 0.8, center.dy),
      Offset(center.dx + radius * 0.8, center.dy),
      linePaint..strokeWidth = 1,
    );
    
    // Vertical scan line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius * 0.8),
      Offset(center.dx, center.dy + radius * 0.8),
      linePaint..strokeWidth = 1,
    );
  }
  
  @override
  bool shouldRepaint(covariant ARScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Custom painter for AR particles
class ARParticlePainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];
  
  ARParticlePainter({required this.animationValue}) {
    // Generate random particles
    if (particles.isEmpty) {
      for (int i = 0; i < 50; i++) {
        particles.add(Particle());
      }
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(
          (0.1 + 0.2 * math.sin((animationValue + particle.seed) * math.pi * 2)) * particle.opacity,
        );
      
      // Update position based on animation
      final x = (particle.x * size.width + 5 * math.sin((animationValue + particle.seed) * math.pi * 2));
      final y = (particle.y * size.height + 5 * math.cos((animationValue + particle.seed) * math.pi * 2));
      
      // Draw the particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size * 0.5,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ARParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Particle class for the AR effect
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
          Colors.white
        ][math.Random().nextInt(3)];
} 