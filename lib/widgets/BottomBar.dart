import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped, // Updates selected index
      items: [
        BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: ""),
        BottomNavigationBarItem(icon: Icon(Iconsax.image), label: ""),
        BottomNavigationBarItem(icon: Icon(Iconsax.location), label: ""),
        BottomNavigationBarItem(icon: Icon(Iconsax.clock), label: ""),
      ],
    );
  }
}
