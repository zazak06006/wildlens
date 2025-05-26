import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'widgets/app_routes.dart';
import 'services/service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await ServiceProvider.initialize();
  
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
