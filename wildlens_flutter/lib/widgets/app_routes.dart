import 'package:flutter/material.dart';
import '../screens/splash/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/animals/animals_screen.dart';
import '../screens/animals/animal_detail_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/ecosystem/ecosystem_screen.dart';
import '../screens/scan/scan_list_screen.dart';
import '../screens/ecosystem/ecosystem_detail_screen.dart';
import '../screens/scan/scan_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/complete_profile_screen.dart';

class AppRoutes {
  // Route names
  static const String splashScreen = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String animals = '/animals';
  static const String animalDetails = '/animal-details';
  static const String explore = '/explore';
  static const String profile = '/profile';
  static const String ecosystem = '/ecosystem';
  static const String scanList = '/scan-list';
  static const String ecosystemDetail = '/ecosystem-detail';
  static const String scanDetail = '/scan-detail';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String chatbot = '/chatbot';
  static const String editProfile = '/edit-profile';
  static const String completeProfile = '/complete-profile';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 800),
        );
      
      case home:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 500),
        );
      
      case scan:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ScanScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case animals:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AnimalsScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case animalDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AnimalDetailScreen(
            animalId: args['animalId'],
            animalImage: args['animalImage'] ?? '',
          ),
          transitionsBuilder: _zoomTransition,
          transitionDuration: const Duration(milliseconds: 600),
        );
        
      case explore:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ExploreScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case profile:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ProfileScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case ecosystem:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const EcosystemScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case scanList:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ScanListScreen(),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case ecosystemDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => EcosystemDetailScreen(ecosystem: args),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case scanDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ScanDetailScreen(scan: args),
          transitionsBuilder: _slideTransition,
          transitionDuration: const Duration(milliseconds: 400),
        );
      
      case login:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 500),
        );
      
      case signup:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SignUpScreen(),
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 500),
        );
      
      case chatbot:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ChatbotScreen(),
          transitionsBuilder: _fadeTransition,
          transitionDuration: const Duration(milliseconds: 500),
        );
      
      case editProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(userData: args ?? {}),
        );
      
      case completeProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            name: args?['name'] ?? '',
            email: args?['email'] ?? '',
            password: args?['password'] ?? '',
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Custom transitions
  static Widget _fadeTransition(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
  
  static Widget _slideTransition(_, Animation<double> animation, __, Widget child) {
    var begin = const Offset(1.0, 0.0);
    var end = Offset.zero;
    var curve = Curves.easeInOutCubic;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }
  
  static Widget _zoomTransition(_, Animation<double> animation, __, Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
} 