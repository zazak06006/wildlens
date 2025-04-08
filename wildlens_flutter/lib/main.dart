import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_page.dart'; // Import HomePage from another file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstSplashScreen(), // Start with the first splash screen
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
      subtitle: 'Vivez l’aventure avec nous.',
      indicators: [false, false, true],
      nextScreen: HomePage(), // 👈 Navigate to your actual homepage after this
    );
  }
}
