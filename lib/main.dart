import 'package:flutter/material.dart';
import 'package:jagamata/pages/homepage.dart';

void main() {
  runApp(JagaMata());
}

class JagaMata extends StatelessWidget {
  const JagaMata({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homopage(),
      routes: {
        
      },
    );
  }
}