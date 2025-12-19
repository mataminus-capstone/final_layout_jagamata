import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:jagamata/pages/PERCOBAAN/COBA.dart';
import 'package:jagamata/pages/artikel/artikel.dart';
import 'package:jagamata/pages/chatbot/chatbot.dart';
import 'package:jagamata/pages/deteksi/deteksi.dart';
import 'package:jagamata/pages/homepage.dart';
import 'package:jagamata/pages/loginpage.dart';
import 'package:jagamata/pages/profil/profil1.dart';
import 'package:jagamata/pages/profil/profile.dart';
import 'package:jagamata/pages/profil/setting.dart';
import 'package:jagamata/pages/registerpage.dart';
import 'package:jagamata/pages/notifikasi.dart';
import 'package:jagamata/pages/rekomendasi/klinik.dart';
import 'package:jagamata/pages/rekomendasi/rekomendasi.dart';
import 'package:jagamata/pages/treatment/treatment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JagaMata());
}

class JagaMata extends StatelessWidget {
  const JagaMata({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => Homopage(),
        '/notif': (context) => Notifikasi(),
        '/profil': (context) => Profil(),
        '/deteksi': (context) => Deteksi(),
        '/treatment': (context) => TreatmentPage(),
        '/chatbot': (context) => Chatbot(),
        '/rekomendasi': (context) => Rekomendasi(),
        '/klinik': (context) => KlinikMata(),
        '/setting': (context) => Setting(),
        '/artikel': (context) => Artikel(),
        '/eyeExercise': (context) => Coba(),
        '/profil1': (context) => Profil1(),
      },
    );
  }
}
