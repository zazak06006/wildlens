import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/InfoCard.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';

class AnimalScreen extends StatelessWidget {
  final String animalName;

  const AnimalScreen({super.key, required this.animalName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🟢 Full-Screen Animal Image (Height Set to 400)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400, // Image Height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🟢 Animal Name Floating Blur Box (Now with Blur = 55)
          Positioned(
            left: 24,
            right: 24,
            top: 340, // Adjusted for perfect placement
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // 🔥 Stronger Blur Effect
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4), // 🔥 Softer Glass Effect
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)), // Light Border
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.001),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animalName, // Dynamic Title
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black Text
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Aperçu 15 fois aujourd’hui",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🟢 Page Content (Scrollable)
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 420), // Adjusted padding for smooth scrolling
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // 🟢 "À propos" Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Icon(Icons.pets, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "À propos",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 🟢 Info Cards (Poids, Taille, Type)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoCard(title: "Poids", value: "5,5 kg"),
                      InfoCard(title: "Taille", value: "42 cm"),
                      InfoCard(title: "Type", value: "Domestique"),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 🟢 Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Les $animalName, compagnons fidèles, laissent des empreintes uniques "
                    "qui racontent leurs aventures et leur présence dans la nature.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),

      // 🟢 Bottom Navigation Bar
      bottomNavigationBar: BottomBar(
        selectedIndex: 2, // Set the selected index (change this to whatever you want)
        onItemTapped: (index) {
          // Handle item tapped action
          // You can add the navigation logic here if needed
        },
      ),
    );
  }
}
