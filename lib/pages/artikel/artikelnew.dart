import 'package:flutter/material.dart';

class Artikelnew extends StatefulWidget {
  const Artikelnew({super.key});

  @override
  State<Artikelnew> createState() => _ArtikelnewState();
}

class _ArtikelnewState extends State<Artikelnew> {
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> artikelList = [
    {
      'judul': '5 Buah yang Baik untuk Kesehatan Mata',
      'desc': 'Buah dengan vitamin A tinggi bantu jaga kesehatan mata.',
      'image': 'images/maskot.png',
      'kategori': 'Tips Mata',
      'waktu': '3 menit baca',
    },
    {
      'judul': 'Kenapa Mata Sering Lelah Saat Main HP?',
      'desc': 'Kebiasaan kecil ini bisa bikin mata cepat capek.',
      'image': 'images/maskot.png',
      'kategori': 'Edukasi',
      'waktu': '4 menit baca',
    },
    {
      'judul': 'Cara Sederhana Mencegah Mata Kering',
      'desc': 'Tips ringan yang bisa kamu lakuin setiap hari.',
      'image': 'images/maskot.png',
      'kategori': 'Perawatan',
      'waktu': '2 menit baca',
    },
    {
      'judul': 'Cara Sederhana Mencegah Mata Kering',
      'desc': 'Tips ringan yang bisa kamu lakuin setiap hari.',
      'image': 'images/maskot.png',
      'kategori': 'Perawatan',
      'waktu': '2 menit baca',
    },
    {
      'judul': 'Cara Sederhana Mencegah Mata Kering',
      'desc': 'Tips ringan yang bisa kamu lakuin setiap hari.',
      'image': 'images/maskot.png',
      'kategori': 'Perawatan',
      'waktu': '2 menit baca',
    },
    {
      'judul': 'Cara Sederhana Mencegah Mata Kering',
      'desc': 'Tips ringan yang bisa kamu lakuin setiap hari.',
      'image': 'images/maskot.png',
      'kategori': 'Perawatan',
      'waktu': '2 menit baca',
    },
    {
      'judul': 'Cara Sederhana Mencegah Mata Kering',
      'desc': 'Tips ringan yang bisa kamu lakuin setiap hari.',
      'image': 'images/maskot.png',
      'kategori': 'Perawatan',
      'waktu': '2 menit baca',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 20),
        child: Center(
          // ====================  SEARCH  NIH =====================
          child: Column(
            children: [
              Container(
                width: 350,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Text(
                      'Cari  Mata disini...',
                      style: TextStyle(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(Icons.filter_alt, color: Colors.grey),
                      onSelected: (value) {
                        setState(() {
                          var _selectedItem = value;
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Terdekat',
                          child: InkWell(onTap: () {}, child: Text('Terdekat')),
                        ),
                        PopupMenuItem(
                          value: 'Terbaik',
                          child: InkWell(onTap: () {}, child: Text('Terbaik')),
                        ),
                        PopupMenuItem(
                          value: 'Buka Sekarang',
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: Text('Buka Sekarang'),
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // ==================== LIST CARD NIH =========================
              Expanded(
                child: ListView.builder(
                  itemCount: artikelList.length + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    // ================= FOOTER =================
                    if (index == artikelList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              "Anda sudah melihat semua artikel",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                _scrollController.animateTo(
                                  0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ============== CARD ===================
                    final artikel = artikelList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(-4, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // IMAGE
                            ClipPath(
                              child: Image.asset(
                                artikel['image']!,
                                width: 80,
                                height: 80,

                                fit: BoxFit.cover,
                              ),
                            ),

                            // TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artikel['judul']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    artikel['desc']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          artikel['kategori']!,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        artikel['waktu']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/isiartikel');
                                  },
                                  child: Icon(
                                    Icons.navigate_next_rounded,
                                    size: 30,
                                    color: Colors.blue.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
