import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Artikel extends StatelessWidget {
  const Artikel({super.key});

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
      appBar: AppBar(
        title: Text(
          'Artikel',
          style: TextStyle(
            color: Color(0xFF4A77A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
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
                          style: TextStyle(color: Colors.black54, fontSize: 13),
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
    );
  }
}
