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
        // title: Text(
        //   'Treatment',
        //   style: TextStyle(
        //     color: Color(0xFF4A77A1),
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        elevation: 0,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: 79,
                  backgroundImage: AssetImage('images/tretmen.jpg'),
                ),
              ),

              SizedBox(height: 20),

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

              // simple eyecare
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.light_mode_rounded,
                          size: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Simple eye care, everyday',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 60),

              // Kotak 1 - Senam Mata
              PressableCard(
                icon: Icons.remove_red_eye_outlined,
                title: "Senam Mata",
                description: "Latihan ringan untuk membantu merilekskan mata.",
                
                onTap: () {
                  Navigator.pushNamed(context, '/senameyes');
                },
              ),

              SizedBox(height: 40),
              // space
              Container(
                width: 250,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[400]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "atau",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Kotak 2 - Teknik Akupresur
              PressableCard(
                //icon pijat wajah
                icon: Icons.touch_app_rounded,
                title: 'Teknik Akupresur',
                description:
                    'Pijatan lembut pada titik-titik diarea sekitar mata.',
                onTap: () {},
              ),

              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}