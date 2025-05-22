import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _backgroundController;
  late final AnimationController _splashController;
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bienvenue sur WildLens',
      description: 'Explorez la faune qui vous entoure avec notre technologie de reconnaissance d\'empreintes.',
      backgroundImage: 'assets/images/splash_background2.png',
    ),
    OnboardingPage(
      title: 'Découverte Intelligente',
      description: 'Identifiez les animaux à partir de leurs traces et découvrez leur habitat et comportement.',
      backgroundImage: 'assets/images/splash_background3.png',
    ),
    OnboardingPage(
      title: 'Explorez en Réalité Augmentée',
      description: 'Visualisez les animaux en 3D et explorez leur environnement naturel en RA.',
      backgroundImage: 'assets/images/lot_of_animals.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Show splash then start onboarding
    _showSplashScreen();
  }
  
  void _showSplashScreen() {
    // Show splash animation for 3 seconds
    _splashController.forward().then((_) {
      // After splash animation completes, start onboarding
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _splashController.reset();
        });
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _splashController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _backgroundController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // If showing splash screen
    if (_splashController.status == AnimationStatus.forward) {
      return _buildSplashScreen();
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_pages[_currentPage].backgroundImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Particle overlay effect
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accent.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(index);
            },
          ),
          
          // Progress indicators and buttons
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip button
                      _currentPage < _pages.length - 1
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                              },
                              child: Text(
                                'Passer',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),
                      
                      // Next/Start button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Suivant' : 'Commencer',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.primaryDark,
                          ),
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
    );
  }
  
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _splashController,
          builder: (context, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo WildLens
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.futuristicGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo-wildlens.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'WildLens',
                          style: AppTextStyles.displayLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explorer • Découvrir • Protéger',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final page = _pages[index];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Plus d'animation ici
          const Spacer(),
          // Glass card for text
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      page.title,
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.description,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isCurrentPage = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: isCurrentPage ? 30 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isCurrentPage ? AppColors.accent : AppColors.accent.withOpacity(0.3),
        boxShadow: isCurrentPage
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String backgroundImage;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.backgroundImage,
  });
} 