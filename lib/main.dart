import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jagamata/pages/PERCOBAAN/COBA.dart';
import 'package:jagamata/pages/artikel/artikel.dart';
import 'package:jagamata/pages/artikel/artikelnew.dart';
import 'package:jagamata/pages/artikel/isiartikel.dart';
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
import 'package:jagamata/pages/rekomendasi/obat.dart';
import 'package:jagamata/pages/rekomendasi/rekomendasi.dart';
import 'package:jagamata/pages/treatment/eye_exercise_page.dart';
import 'package:jagamata/pages/treatment/senam_mata.dart';
import 'package:jagamata/pages/treatment/treatment.dart';
import 'package:jagamata/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('jwt_token');
  if (savedToken != null) {
    ApiService.setToken(savedToken);
  }
  
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
        '/register': (context) => RegisterPage(),
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
        '/senammata': (context) => SenamMata(),
        '/senameyes': (context) => EyeExercisePage(),
        '/obat' : (context) => Obat(),
        '/artikelnew' : (context) => Artikelnew(),
        '/isiartikel' : (context) => Isiartikel(),
      },
    );
  }
}
