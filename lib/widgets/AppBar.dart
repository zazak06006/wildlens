import 'package:flutter/material.dart';

final AppBar AppBarWidget = AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  automaticallyImplyLeading: false,
  title: Container(
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(12), // Radius pour l'image
    ),
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      'assets/images/logo_vert.png',
      height: 50,
      fit: BoxFit.cover,
    ),
  ),
);
