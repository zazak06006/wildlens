import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  late AnimationController _animationController;
  File? _selectedImage;
  bool _isAnalyzing = false;
  bool _showResult = false;
  bool _isCameraMode = true;
  String _scanMode = "empreinte"; // Options: "empreinte", "animal"
  final ImagePicker _picker = ImagePicker();
  
  Map<String, dynamic>? _analysisResult;
  String? _error;

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
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.animals);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.explore);
        break;
    }
  }

  Future<void> _takePicture() async {
    HapticFeedback.mediumImpact();
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isAnalyzing = true;
          _showResult = false;
          _analysisResult = null;
          _error = null;
        });
        await _analyzeImage(image.path);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la prise de photo: $e';
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    HapticFeedback.mediumImpact();
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isAnalyzing = true;
          _showResult = false;
          _analysisResult = null;
          _error = null;
        });
        await _analyzeImage(image.path);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la sélection d\'image: $e';
        _isAnalyzing = false;
      });
    }
  }
  
  Future<void> _analyzeImage(String path) async {
    try {
      final result = await ApiService().analyzeFootprint(path);
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
        _analysisResult = result;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _showResult = false;
        _error = 'Erreur lors de l\'analyse: $e';
      });
    }
  }
  
  void _toggleScanMode() {
    HapticFeedback.selectionClick();
    setState(() {
      _scanMode = _scanMode == "empreinte" ? "animal" : "empreinte";
    });
  }

  // Getter for possible matches from analysis result
  List<Map<String, dynamic>> get _possibleMatches {
    if (_analysisResult == null) return [];
    if (_analysisResult!['possible_matches'] is List) {
      return List<Map<String, dynamic>>.from(_analysisResult!['possible_matches']);
    }
    // Fallback: treat the main result as the only match
    return [_analysisResult!];
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
                
                // Main content area
                Expanded(
                  child: _isCameraMode
                      ? _buildCameraInterface()
                      : _buildResultsInterface(),
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
              painter: ScanParticlePainter(
                animationValue: _animationController.value,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
  
  // Top bar with title and options
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
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
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
                Icons.arrow_back,
                color: AppColors.accent,
                size: 20,
              ),
            ),
          ),
          
          // Title
          Column(
            children: [
              // Main title
              Text(
                "Scanner",
                style: AppTextStyles.heading.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Scan mode toggle
              GestureDetector(
                onTap: _toggleScanMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _scanMode == "empreinte" ? "Mode Empreinte" : "Mode Animal",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _scanMode == "empreinte" ? Icons.pets : Icons.photo_camera,
                        color: AppColors.accent,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Gallery button
          GestureDetector(
            onTap: _pickImageFromGallery,
            child: Container(
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
                Icons.photo_library,
                color: AppColors.accent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Camera interface with scanning overlay
  Widget _buildCameraInterface() {
    return Stack(
      children: [
        // Camera preview (simulated)
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
              children: [
                // Simulated camera view
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white.withOpacity(0.3),
                            size: 80,
                          ),
                        ),
                      ),
                
                // Scanning overlay
                if (!_isAnalyzing && !_showResult)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ScanOverlayPainter(
                          animationValue: _animationController.value,
                          scanMode: _scanMode,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                
                // Analysis overlay
                if (_isAnalyzing)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated analysis indicator
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.linear,
                                  builder: (context, value, child) {
                                    return CircularProgressIndicator(
                                      value: null,
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.accent,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Analyse en cours...",
                                style: AppTextStyles.subheading.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _scanMode == "empreinte"
                                    ? "Identification de l'empreinte"
                                    : "Identification de l'animal",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildAnalysisProgress(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                // Results overlay
                if (_showResult)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCameraMode = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppRadius.circular),
                                ),
                                child: Text(
                                  "Correspondance trouvée !",
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _analysisResult?['name'] ?? "Animal inconnu",
                                style: AppTextStyles.heading.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _analysisResult?['scientific'] ?? "",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FuturisticUI.techButton(
                                    label: "VOIR DÉTAILS",
                                    onPressed: () {
                                      setState(() {
                                        _isCameraMode = false;
                                      });
                                    },
                                    icon: Icons.search,
                                    color: AppColors.accent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // Camera controls
        if (!_isAnalyzing && !_showResult)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _buildCameraControls(),
          ),
        
        // Help tips
        if (!_isAnalyzing && !_showResult)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _scanMode == "empreinte"
                          ? "Centrez l'empreinte dans le cadre"
                          : "Centrez l'animal dans le cadre",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  // Placeholder for the analysis progress
  Widget _buildAnalysisProgress() {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.circular),
            child: LinearProgressIndicator(
              value: null,
              backgroundColor: AppColors.cardLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.memory,
              color: AppColors.quaternary,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              "IA WildLens en action",
              style: AppTextStyles.mono.copyWith(
                color: AppColors.quaternary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Camera control buttons
  Widget _buildCameraControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Capture button
        GestureDetector(
          onTap: _takePicture,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Results interface after scanning
  Widget _buildResultsInterface() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back to camera button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCameraMode = true;
                  _showResult = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Retour à la caméra",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Scanned image with result overlay
            if (_selectedImage != null) ...[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    // Analysis overlay
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.primaryDark.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.quaternary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              _scanMode == "empreinte" ? "EMPREINTE" : "ANIMAL",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.quaternary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _analysisResult?['match'] != null
                                ? "${_analysisResult?['match']}% de correspondance"
                                : "Analyse complète",
                            style: AppTextStyles.subheading.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Basé sur le modèle IA WildLens",
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Primary match result
            if (_analysisResult != null) ...[
              Text(
                "Meilleur résultat",
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 16),
              _buildPrimaryMatchCard(_analysisResult!),
              const SizedBox(height: 32),
            ],
            
            // Other possible matches
            Text(
              "Autres correspondances possibles",
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              _possibleMatches.length - 1,
              (index) => _buildSecondaryMatchCard(_possibleMatches[index + 1]),
            ),
            
            const SizedBox(height: 32),
            
            // Additional information
            Text(
              "À propos de cette analyse",
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 16),
            FuturisticUI.glassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.quaternary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.quaternary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Comment fonctionne l'analyse ?",
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Notre intelligence artificielle analyse les caractéristiques de l'empreinte ou de l'animal, puis la compare à notre base de données de plus de 1000 espèces sauvages. La précision dépend de la qualité de l'image et de l'angle de la photo.",
                              style: AppTextStyles.caption.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FuturisticUI.techButton(
                    label: "AMÉLIORER LA PRÉCISION",
                    onPressed: () {
                      // Show tips for better scanning
                    },
                    icon: Icons.tips_and_updates,
                    color: AppColors.quaternary,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
  
  // Primary match card with detailed info
  Widget _buildPrimaryMatchCard(Map<String, dynamic> match) {
    return FuturisticUI.neonContainer(
      neonColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and basic info
          Row(
            children: [
              // Animal image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    match['image'],
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
              
              // Basic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match['name'],
                      style: AppTextStyles.subheading.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      match['scientific'],
                      style: AppTextStyles.caption.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Match accuracy
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getMatchColor(match['match']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: _getMatchColor(match['match']),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${match['match']}% de correspondance",
                            style: AppTextStyles.caption.copyWith(
                              color: _getMatchColor(match['match']),
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
          
          const SizedBox(height: 16),
          const Divider(
            color: AppColors.cardLight,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: FuturisticUI.techButton(
                  label: "VOIR DÉTAILS",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.animalDetails,
                      arguments: {
                        'animalName': match['name'],
                        'animalImage': match['image'],
                      },
                    );
                  },
                  icon: Icons.visibility,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Secondary match card with less detail
  Widget _buildSecondaryMatchCard(Map<String, dynamic> match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: FuturisticUI.glassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Animal image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.network(
                  match['image'],
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
            const SizedBox(width: 12),
            
            // Basic info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match['name'],
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    match['scientific'],
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Match accuracy
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getMatchColor(match['match']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                "${match['match']}%",
                style: AppTextStyles.caption.copyWith(
                  color: _getMatchColor(match['match']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // View details button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppColors.accent,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.animalDetails,
                    arguments: {
                      'animalName': match['name'],
                      'animalImage': match['image'],
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Get color based on match percentage
  Color _getMatchColor(int matchPercentage) {
    if (matchPercentage >= 90) {
      return AppColors.success;
    } else if (matchPercentage >= 70) {
      return AppColors.info;
    } else if (matchPercentage >= 50) {
      return AppColors.warning;
    } else {
      return AppColors.tertiary;
    }
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

// Custom painter for scan overlay effects
class ScanOverlayPainter extends CustomPainter {
  final double animationValue;
  final String scanMode;
  
  ScanOverlayPainter({
    required this.animationValue,
    required this.scanMode,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw different overlays based on scan mode
    if (scanMode == "empreinte") {
      // Footprint scan overlay - rectangular with corner markers
      final scanWidth = size.width * 0.8;
      final scanHeight = size.height * 0.4;
      final left = centerX - scanWidth / 2;
      final top = centerY - scanHeight / 2;
      final right = centerX + scanWidth / 2;
      final bottom = centerY + scanHeight / 2;
      
      // Draw scan rectangle
      final scanRectPaint = Paint()
        ..color = AppColors.accent.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      final scanRect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(scanRect, scanRectPaint);
      
      // Draw corner markers
      final cornerPaint = Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      final cornerLength = 20.0;
      
      // Top left corner
      canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
      canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), cornerPaint);
      
      // Top right corner
      canvas.drawLine(Offset(right, top), Offset(right - cornerLength, top), cornerPaint);
      canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), cornerPaint);
      
      // Bottom left corner
      canvas.drawLine(Offset(left, bottom), Offset(left + cornerLength, bottom), cornerPaint);
      canvas.drawLine(Offset(left, bottom), Offset(left, bottom - cornerLength), cornerPaint);
      
      // Bottom right corner
      canvas.drawLine(Offset(right, bottom), Offset(right - cornerLength, bottom), cornerPaint);
      canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), cornerPaint);
      
      // Scanning line animation
      final scanLinePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.0),
            AppColors.accent.withOpacity(0.8),
            AppColors.accent.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(left, 0, scanWidth, 1));
      
      final scanLineY = top + (scanHeight * (0.5 + 0.5 * math.sin(animationValue * math.pi * 2)));
      canvas.drawLine(
        Offset(left, scanLineY),
        Offset(right, scanLineY),
        scanLinePaint..strokeWidth = 2,
      );
    } else {
      // Animal scan overlay - circular target
      final maxRadius = math.min(size.width, size.height) * 0.4;
      
      // Outer circle
      final outerCirclePaint = Paint()
        ..color = AppColors.accent.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(
        Offset(centerX, centerY),
        maxRadius,
        outerCirclePaint,
      );
      
      // Inner circle
      final innerCirclePaint = Paint()
        ..color = AppColors.accent.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      canvas.drawCircle(
        Offset(centerX, centerY),
        maxRadius * 0.7,
        innerCirclePaint,
      );
      
      // Center circle
      final centerCirclePaint = Paint()
        ..color = AppColors.accent.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(centerX, centerY),
        maxRadius * 0.1,
        centerCirclePaint,
      );
      
      // Pulsing circle animation
      final pulsingCirclePaint = Paint()
        ..color = AppColors.accent.withOpacity(0.3 * (1 - (0.5 + 0.5 * math.sin(animationValue * math.pi * 2))))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      final pulseRadius = maxRadius * (0.7 + 0.3 * math.sin(animationValue * math.pi * 2));
      canvas.drawCircle(
        Offset(centerX, centerY),
        pulseRadius,
        pulsingCirclePaint,
      );
      
      // Crosshair
      final crosshairPaint = Paint()
        ..color = AppColors.accent.withOpacity(0.7)
        ..strokeWidth = 1;
      
      // Horizontal line
      canvas.drawLine(
        Offset(centerX - maxRadius * 0.2, centerY),
        Offset(centerX + maxRadius * 0.2, centerY),
        crosshairPaint,
      );
      
      // Vertical line
      canvas.drawLine(
        Offset(centerX, centerY - maxRadius * 0.2),
        Offset(centerX, centerY + maxRadius * 0.2),
        crosshairPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ScanOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.scanMode != scanMode;
  }
}

// Custom painter for particle effects
class ScanParticlePainter extends CustomPainter {
  final double animationValue;
  final List<ScanParticle> particles = [];
  
  ScanParticlePainter({required this.animationValue}) {
    // Generate random particles
    if (particles.isEmpty) {
      for (int i = 0; i < 30; i++) {
        particles.add(ScanParticle());
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
  bool shouldRepaint(covariant ScanParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Particle class for the scan effects
class ScanParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;
  final double seed;
  
  ScanParticle()
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