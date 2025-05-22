import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';
import 'package:flutter_application_1/widgets/AppBar.dart';
import 'package:flutter_application_1/widgets/OptionCard.dart';
import 'package:flutter_application_1/widgets/AnimalCard.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/FeatureTile.dart';

import 'ScanScreen.dart';
import 'all_animals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    // The actual navigation is now handled by the BottomBar widget
  }

  void _navigateWithAnimation(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildAnimalList(),
                const SizedBox(height: 20),
                _buildFeaturesSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Animaux",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateWithAnimation('/animals'),
          child: Text(
            "Voir Tout →",
            style: TextStyle(color: AppColors.quaternary, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalList() {
    return SizedBox(
      height: 180,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: const [
          AnimalCard(
            imageUrl: "https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            name: "Fennec",
            description: "Lorem ipsum dolor sit amet, consectetur",
          ),
          AnimalCard(
            imageUrl: "https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            name: "Ours",
            description: "Lorem ipsum dolor sit amet, consectetur",
          ),
          AnimalCard(
            imageUrl: "https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            name: "Loup",
            description: "Lorem ipsum dolor sit amet, consectetur",
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reconnaître des animaux",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        OptionCard(
          imageUrl: "https://img.freepik.com/premium-photo/futuristic-digital-paw-print-hightech-animal-symbol-design_1300520-2578.jpg?w=1380",
          title: "Scanner une empreinte",
          subtitle: "Reconnaître une empreinte",
          onTap: () => _navigateWithAnimation('/scan'),
        ),
        OptionCard(
          imageUrl: "https://images.unsplash.com/photo-1641847095771-ffaf2cc68c9c?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          title: "Consulter l'historique",
          subtitle: "Historique des observations",
          onTap: () => _navigateWithAnimation('/animals'),
        ),
      ],
    );
  }
}
