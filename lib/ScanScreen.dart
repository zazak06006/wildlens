import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/AppBar.dart';
import 'package:flutter_application_1/widgets/OptionCard.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';



class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟢 Stylish Image Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://img.freepik.com/premium-photo/futuristic-digital-paw-print-hightech-animal-symbol-design_1300520-2578.jpg?w=1380",
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // 🟢 Title & Description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Analyser une empreinte",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Prenez une photo d’une empreinte ou importez une image pour analyser et identifier l’animal. "
                "Obtenez des informations détaillées sur l’espèce et son habitat.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // 🟢 Action Buttons with Beautiful Cards
              OptionCard(
                imageUrl:
                    "https://images.unsplash.com/photo-1699694927472-46a4fcf68973?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                title: "Prendre une photo",
                subtitle: "Prenez une photo en direct",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()), // <-- Open AnalysePage
                  );
                },
              ),
              SizedBox(height: 12),
              OptionCard(
                imageUrl:
                    "https://images.unsplash.com/photo-1641847095771-ffaf2cc68c9c?q=80&w=3135&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                title: "Charger une photo",
                subtitle: "Charger une photo déjà prise",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()), // <-- Open AnalysePage
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
