import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == selectedIndex) return;
        
        onItemTapped(index);
        
        // Navigate using named routes for more reliable navigation
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home', 
              (route) => false
            );
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/scan', 
              (route) => false
            );
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/animals', 
              (route) => false
            );
            break;
          case 3:
            // Handle history tab if needed
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Iconsax.image), label: "Scan"),
        BottomNavigationBarItem(icon: Icon(Iconsax.location), label: "Animals"),
        BottomNavigationBarItem(icon: Icon(Iconsax.clock), label: "History"),
      ],
    );
  }
}
