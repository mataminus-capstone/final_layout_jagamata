import 'package:flutter/material.dart';
import 'package:jagamata/pages/PERCOBAAN/card.dart';

class Rekomendasi extends StatelessWidget {
  const Rekomendasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Rekomendasi',
        //   style: TextStyle(
        //     color: Color(0xFF4A77A1),
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              //avatar
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: 79,
                  backgroundImage: AssetImage('images/rekomen.jpg'),
                ),
              ),
              SizedBox(height: 20),

              Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
              child: Text('Rekomendasi Klinik Mata dan Obat Mata',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),),),
              //Spancing
              SizedBox(height: 50),

              // Klinik Mata
              Padding(
                padding: const EdgeInsets.all(25),
                child: PressableCard(
                  icon: Icons.home_work_outlined,
                  title: 'Klinik Mata',
                  description: 'Temukan klinik mata terpercaya di sekitarmu.',
                  onTap: () {
                    Navigator.pushNamed(context, '/klinik');
                  },
                ),
              ),

              //Spancing
              SizedBox(height: 15),
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
              SizedBox(height: 15),
              //Spancing

              // Obat Mata
              Padding(
                padding: const EdgeInsets.all(25),
                child: PressableCard(
                  icon: Icons.medical_services_rounded,
                  title: 'Obat Mata',
                  description: 'Rekomendasi obat terkait permasalahan matamu.',
                  onTap: () {
                    Navigator.pushNamed(context, '/obat');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'Catatan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Jika keluhan berlanjut, disarankan untuk melakukan pemeriksaan langsung ke tenaga medis.',
                        style: TextStyle(fontSize: 13),textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
