import 'package:flutter/material.dart';
import '../PERCOBAAN/card.dart';

class TreatmentPage extends StatefulWidget {
  const TreatmentPage({super.key});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  /// Untuk animasi saat kotak ditekan
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Treatment',
          style: TextStyle(
            color: Color(0xFF4A77A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6F2FA), Color(0xFFFDFEFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                // Judul
                Text(
                  'Treatment Mata',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3E57),
                  ),
                ),
                SizedBox(height: 12),

                // Deskripsi
                Text(
                  'Pilih metode perawatan mata yang anda inginkan, untuk membantu merilekskan mata.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 40),
                // Kotak 1 - Senam Mata
                
                PressableCard(
                  icon: Icons.remove_red_eye_outlined,
                  title: "Senam Mata",
                  description:
                      "Rangkaian latihan gerakan untuk melatih otot di area mata.",
                  onTap: () {
                    Navigator.pushNamed(context, '/eyeExercise');
                  },
                ),
                
                SizedBox(height: 40),
               


                // Kotak 2 - Teknik Akupresur
                InkWell(
                  onTap: () {
                    // Aksi ketika kotak ditekan
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF80AFCC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 40,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Teknik Akupresur',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rangkaian pijatan lembut pada titik-titik tertentu di daerah sekitar mata.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
