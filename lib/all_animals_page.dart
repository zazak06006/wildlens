import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/AppBar.dart';
import 'package:flutter_application_1/widgets/BottomBar.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/animal_page.dart'; // Assuming this is your animal page
import 'package:flutter_application_1/ScanScreen.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  _AnimalsScreenState createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  int _selectedIndex = 2; // Set the index of this screen in the BottomBar

  // Handle BottomBar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected index
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        // Navigate to ScanScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanScreen()),
        );
        break;
      case 2:
        // Stay on the current AnimalsScreen
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> animals = [
      {"name": "Lapin", "image": "https://example.com/lapin.jpg"},
      {"name": "Chat", "image": "https://example.com/chat.jpg"},
      {"name": "Loup", "image": "https://example.com/loup.jpg"},
      {"name": "Fennec", "image": "https://example.com/fennec.jpg"},
      {"name": "Ours", "image": "https://example.com/ours.jpg"},
      {"name": "Canard", "image": "https://example.com/canard.jpg"},
      {"name": "Renard", "image": "https://example.com/renard.jpg"},
      {"name": "Tigre", "image": "https://example.com/tigre.jpg"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Animaux",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: animals.length,
              itemBuilder: (context, index) {
                return AnimalListItem(
                  name: animals[index]["name"]!,
                  imageUrl: animals[index]["image"]!,
                  onTap: () {
                    // Navigate to the Animal Details page (AnimalScreen)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalScreen(animalName: animals[index]["name"]!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,  // Pass selected index to BottomBar
        onItemTapped: _onItemTapped,  // Handle item tapped
      ),
    );
  }
}

class AnimalListItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const AnimalListItem({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 60,
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Vu 16 Fois",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
        onTap: onTap,
      ),
    );
  }
}
