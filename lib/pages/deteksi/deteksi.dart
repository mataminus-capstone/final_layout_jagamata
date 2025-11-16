import 'package:flutter/material.dart';

class Deteksi extends StatefulWidget {
  const Deteksi({super.key});

  @override
  State<Deteksi> createState() => _DeteksiState();
}

class _DeteksiState extends State<Deteksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deteksi',
          style: TextStyle(color: Color(0xFF4A77A1), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [?Colors.blue[50], Colors.white],
        //     begin: AlignmentGeometry.topRight,
        //     end: AlignmentGeometry.bottomLeft
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, size: 100, color: Colors.blue[600]),
              SizedBox(height: 20),
              Text(
                "Pilih Mode Pemindaian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Gunakan kamera atau unggah foto dari galeri",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 40),
          
              // Tombol Camera
              Container(
                width: 220,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF80AFCC),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Kamera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 25),
          
              // Tombol Unggah Foto
              Container(
                width: 220,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF80AFCC),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_search_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Unggah Foto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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