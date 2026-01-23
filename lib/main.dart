import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import Wajib untuk Kamera
import 'package:shared_preferences/shared_preferences.dart';

// Import halaman-halaman aplikasi
import 'package:jagamata/pages/treatment/acupressure_page.dart';
import 'package:jagamata/pages/PERCOBAAN/COBA.dart';
import 'package:jagamata/pages/artikel/artikel.dart';
import 'package:jagamata/pages/artikel/artikelnew.dart';
import 'package:jagamata/pages/artikel/isiartikel.dart';
import 'package:jagamata/pages/chatbot/chatbot.dart';
import 'package:jagamata/pages/deteksi/deteksi.dart';
import 'package:jagamata/pages/homepage.dart';
import 'package:jagamata/pages/loginpage.dart';
import 'package:jagamata/pages/profil/profile.dart';
import 'package:jagamata/pages/profil/setting.dart';
import 'package:jagamata/pages/registerpage.dart';
import 'package:jagamata/pages/notifikasi.dart';
import 'package:jagamata/pages/search_results_page.dart';
import 'package:jagamata/pages/rekomendasi/klinik.dart';
import 'package:jagamata/pages/rekomendasi/obat.dart';
import 'package:jagamata/pages/rekomendasi/rekomendasi.dart';
import 'package:jagamata/pages/treatment/eye_exercise_page.dart';
import 'package:jagamata/pages/treatment/senam_mata.dart';
import 'package:jagamata/pages/treatment/treatment.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:jagamata/pages/complete_profile_page.dart';
import 'package:jagamata/pages/profil/history_detection_page.dart';
import 'package:jagamata/pages/loading_page.dart';

// ==============================================================================
// 1. DEKLARASI GLOBAL (PENTING: Harus di luar void main)
// ==============================================================================
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ============================================================================
  // 2. INISIALISASI KAMERA (PENTING: Diisi sebelum aplikasi jalan)
  // ============================================================================
  
  // Mendapatkan daftar kamera yang tersedia
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error Camera: $e.code\nError Message: $e.message');
  }

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
      home: const SplashScreen(),
      routes: {
        '/loading': (context) => const LoadingPage(),
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
        '/senammata': (context) => SenamMata(),
        '/senameyes': (context) => EyeExercisePage(),
        '/obat' : (context) => Obat(),
        '/artikelnew' : (context) => Artikelnew(),
        '/isiartikel' : (context) => Isiartikel(),
        '/complete-profile': (context) => CompleteProfilePage(),
        '/history_detection': (context) => HistoryDetectionPage(),
        '/search_results': (context) => SearchResultsPage(
          searchQuery: ModalRoute.of(context)!.settings.arguments as String,
        ),
        
        // ======================================================================
        // 3. PEMANGGILAN ROUTE (Sekarang sudah tidak merah)
        // ======================================================================
        '/acupressure': (context) => AcupressurePage(cameras: cameras),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3)); 
    if (mounted) {
      // Mengarahkan ke Login (atau bisa diubah logicnya sesuai kebutuhan token)
      Navigator.pushReplacementNamed(context, '/login'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage(); 
  }
}