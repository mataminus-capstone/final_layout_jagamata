import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Homopage extends StatelessWidget {
  const Homopage({super.key});

  // Data dummy fitur
  final List<Map<String, String>> fiturList = const [
    {
      'title': 'Deteksi',
      'desc': 'Cek kesehatan mata secara otomatis',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Rekomendasi',
      'desc': 'Gerakan relaksasi untuk menjaga kesehatan mata',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Treatment',
      'desc': 'Dapatkan tips menjaga mata tetap segar',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Chatbot',
      'desc': 'Ingatkan untuk istirahat dari layar',
      'img': 'images/maskot.png',
    },
  ];

  // List artikel (dummy data)
  final List<Map<String, String>> artikelList = const [
    {
      'judul': 'Menjaga Kesehatan Mata di Era Digital',
      'gambar': 'images/maskot.png',
      'ringkasan':
          'Pelajari cara menjaga mata tetap sehat meski sering menatap layar...',
      'url':
          'https://rsud.bulelengkab.go.id/informasi/detail/artikel/artikel-kesehatan-mata-penjelasan-lengkap-secara-umu-12',
    },
    {
      'judul': 'Tips Relaksasi Mata Setelah Bekerja Lama',
      'gambar': 'images/maskot.png',
      'ringkasan':
          'Beberapa teknik sederhana untuk merilekskan mata Anda setiap hari...',
      'url': 'https://example.com/artikel2',
    },
    {
      'judul': 'Pola Makan untuk Kesehatan Mata',
      'gambar': 'images/maskot.png',
      'ringkasan':
          'Nutrisi apa saja yang penting untuk menjaga penglihatan tetap tajam...',
      'url': 'https://example.com/artikel3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JagaMata',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A77A1),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notif');
                        },
                        child: Icon(Icons.notifications, color: Colors.black54),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil');
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Banner
              Container(
                height: 180,
                padding: EdgeInsets.all(16), // jarak dari tepi container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'images/maskot.png',
                      height: 150,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jaga Mata Kalian 👀',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A7AA3),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Aplikasi ini dapat membantu kalian merilekskan mata dan mendeteksi penyakit mata yang di derita.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Pencarian
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Grid kecil (2x2)
              GridView.builder(
                itemCount: fiturList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.9,
                ),
                itemBuilder: (context, index) {
                  final item = fiturList[index];
                  return GestureDetector(
                    onTap: () {
                      // ambil title-nya, dan arahkan ke route sesuai
                      switch (item['title']) {
                        case 'Deteksi':
                          Navigator.pushNamed(context, '/deteksi');
                          break;
                        case 'Rekomendasi':
                          Navigator.pushNamed(context, '/rekomendasi');
                          break;
                        case 'Treatment':
                          Navigator.pushNamed(context, '/treatment');
                          break;
                        case 'Chatbot':
                          Navigator.pushNamed(context, '/chatbot');
                          break;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF80AFCC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['desc']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            item['img']!,
                            height: 60,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),

              // Label Artikel
              Text(
                'Artikel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A77A1),
                ),
              ),
              SizedBox(height: 8),

              // Kotak artikel (2 kotak besar)
              Column(
                children: List.generate(
                  3, // hanya tampilkan 3 artikel pertama
                  (index) {
                    final artikel = artikelList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Gambar artikel
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              artikel['gambar']!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),

                          // Teks artikel
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artikel['judul']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  artikel['ringkasan']!,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    // buka url artikel
                                    launchUrl(Uri.parse(artikel['url']!));
                                  },
                                  child: Text(
                                    'Baca selengkapnya...',
                                    style: TextStyle(
                                      color: Color(0xFF2F6F7E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/artikel');
                  },
                  child: Text(
                    "Lihat selengkapnya",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
