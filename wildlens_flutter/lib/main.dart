import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'widgets/app_routes.dart';
import 'splash_screen.dart';
import 'home_page.dart'; // Import HomePage from another file
import 'ScanScreen.dart';
import 'all_animals_page.dart';
import 'animal_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WildLens',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class FirstSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      imagePath: 'assets/images/lot_of_animals.png',
      title: 'WildLens',
      subtitle: 'Explorez la faune qui vous entoure.',
      indicators: [true, false, false],
      nextScreen: SecondSplashScreen(), // 👈 Navigate to the second screen
    );
  }
}

class SecondSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      imagePath: 'assets/images/splash_background2.png',
      title: 'Safari Tour',
      subtitle: 'Découvrez la nature sauvage.',
      indicators: [false, true, false],
      nextScreen: ThirdSplashScreen(), // 👈 Navigate to the third screen
    );
  }
}

class ThirdSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      imagePath: 'assets/images/splash_background3.png',
      title: 'Nature Journey',
      subtitle: "Vivez l'aventure avec nous.",
      indicators: [false, false, true],
      nextScreen: HomePage(), // 👈 Navigate to your actual homepage after this
    );
  }
}
