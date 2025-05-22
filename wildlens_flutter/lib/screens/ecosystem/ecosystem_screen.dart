import 'package:flutter/material.dart';

class EcosystemScreen extends StatelessWidget {
  const EcosystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écosystèmes'),
      ),
      body: const Center(
        child: Text('Page des écosystèmes'),
      ),
    );
  }
} 