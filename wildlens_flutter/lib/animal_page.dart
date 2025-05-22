import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/InfoCard.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/ScanScreen.dart';
import 'package:flutter_application_1/all_animals_page.dart';

class AnimalScreen extends StatefulWidget {
  final String animalName;

  const AnimalScreen({Key? key, required this.animalName}) : super(key: key);

  @override
  _AnimalScreenState createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 1.0;
  bool _isScrolled = false;

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

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Control visibility of header only, not the image
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _headerOpacity = 0.0;
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _headerOpacity = 1.0;
        _isScrolled = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image - now always visible
          _buildHeroImage(),
          
          // Content area (scrollable)
          SafeArea(
            child: Column(
              children: [
                // Space for the header area
                SizedBox(height: 370), 
                
                // Content - now in Expanded to prevent overflow
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: _buildScrollableContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Blurred header (stays on top)
          _buildBlurredHeader(),
          
          // Back button
          _buildBackButton(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          // No need to handle navigation here as it's now handled in BottomBar widget
        },
      ),
    );
  }

  Widget _buildHeroImage() {
    return Hero(
      tag: 'animal_${widget.animalName}',
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBlurredHeader() {
    return Positioned(
      left: 24,
      right: 24,
      top: 320,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _headerOpacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.animalName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Aperçu 15 fois aujourd'hui",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutSection(),
              const SizedBox(height: 20),
              _buildInfoCards(),
              const SizedBox(height: 20),
              _buildDescription(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(
            Icons.pets,
            size: 24,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            "À propos",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoCard(
            title: "Poids",
            value: "5,5 kg",
            icon: Icons.monitor_weight_outlined,
          ),
          InfoCard(
            title: "Taille",
            value: "42 cm",
            icon: Icons.height,
          ),
          InfoCard(
            title: "Type",
            value: "Domestique",
            icon: Icons.category_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Les ${widget.animalName}, compagnons fidèles, laissent des empreintes uniques "
            "qui racontent leurs aventures et leur présence dans la nature. "
            "Leurs caractéristiques distinctives et leur comportement fascinant "
            "en font des sujets d'étude captivants pour les amoureux de la nature. "
            "\n\nCes animaux fascinants ont développé des adaptations uniques pour survivre "
            "dans leur environnement naturel. Leur présence est souvent un indicateur "
            "de la santé de l'écosystème et leur protection est essentielle pour "
            "maintenir la biodiversité.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
