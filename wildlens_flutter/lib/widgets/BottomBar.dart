import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Iconsax.image), label: "Scan"),
        BottomNavigationBarItem(icon: Icon(Iconsax.location), label: "Animals"),
        BottomNavigationBarItem(icon: Icon(Iconsax.clock), label: "History"),
      ],
    );
  }
}
