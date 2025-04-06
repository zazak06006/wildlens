import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/FeatureTile.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';
import 'package:flutter_application_1/widgets/AppBar.dart';
import 'package:flutter_application_1/widgets/OptionCard.dart';
import 'package:flutter_application_1/widgets/AnimalCard.dart';


import 'ScanScreen.dart'; 
import 'all_animals_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Animaux", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                Text("Voir Tout →", style: TextStyle(color: greenColor, fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AnimalCard(imageUrl: "https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", name: "Fennec", description: "Lorem ipsum dolor sit amet, consectetur"),
                  AnimalCard(imageUrl: "https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", name: "Ours", description: "Lorem ipsum dolor sit amet, consectetur"),
                  AnimalCard(imageUrl: "https://images.unsplash.com/photo-1583589261738-c7eac1b20537?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", name: "Loup", description: "Lorem ipsum dolor sit amet, consectetur"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Reconnaître des animaux", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 10),
            OptionCard(
              imageUrl: "https://img.freepik.com/premium-photo/futuristic-digital-paw-print-hightech-animal-symbol-design_1300520-2578.jpg?w=1380",
              title: "Scanner une empreinte",
              subtitle: "Reconnaître une empreinte",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()), // <-- Open AnalysePage
                );
              },
            ),
            OptionCard(
              imageUrl: "https://images.unsplash.com/photo-1641847095771-ffaf2cc68c9c?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 
              title: "Consulter l'historique", 
              subtitle: "Historique des observations",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimalsScreen()), // <-- Open AnalysePage
                );
              },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

