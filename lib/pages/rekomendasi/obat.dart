import 'package:flutter/material.dart';

class Obat extends StatefulWidget {
  const Obat({super.key});

  @override
  State<Obat> createState() => _ObatState();
}

class _ObatState extends State<Obat> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> obatMataList = [
    {
      'image': 'images/obat.jpg',
      'nama': 'Insto Regular',
      'fungsi': 'Meredakan mata merah & iritasi ringan',
      'aturanPakai': '1-2 tetes, 3x sehari',
      'harga': 'Rp15.000',
      'kategori': 'Obat Bebas',
    },
    {
      'image': 'images/obat.jpg',
      'nama': 'Insto XL',
      'fungsi': 'Meredakan mata merah & iritasi ringan',
      'aturanPakai': '1-2 tetes, 3x sehari',
      'harga': 'Rp15.000',
      'kategori': 'Obat Bebas',
    },
    {
      'image': 'images/obat.jpg',
      'nama': 'Insto M',
      'fungsi': 'Meredakan mata merah & iritasi ringan',
      'aturanPakai': '1-2 tetes, 3x sehari',
      'harga': 'Rp15.000',
      'kategori': 'Obat Bebas',
    },
    {
      'image': 'images/klinik.jpg',
      'nama': 'Cendo Xitrol',
      'fungsi': 'Infeksi mata akibat bakteri',
      'aturanPakai': '1 tetes, 3-4x sehari',
      'harga': 'Rp35.000',
      'kategori': 'Resep Dokter',
    },
    {
      'image': 'images/klinik.jpg',
      'nama': 'Eyemo',
      'fungsi': 'Iritasi ringan & mata lelah',
      'aturanPakai': '1-2 tetes, 3x sehari',
      'harga': 'Rp18.000',
      'kategori': 'Obat Bebas',
    },
    {
      'image': 'images/klinik.jpg',
      'nama': 'Cendo Lyteers',
      'fungsi': 'Mata kering & kurang air mata',
      'aturanPakai': '1-2 tetes sesuai kebutuhan',
      'harga': 'Rp40.000',
      'kategori': 'Obat Bebas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    String? _selectedItem;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Daftar Rekomendasi Obat Mata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),

            //search
            Container(
              width: 350,
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hint: Text(
                    'Cari Klinik Mata disini...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.filter_alt, color: Colors.grey),
                    onSelected: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'Terdekat',
                        child: InkWell(onTap: () {}, child: Text('Obat Bebas')),
                      ),
                      PopupMenuItem(
                        value: 'Terbaik',
                        child: InkWell(onTap: () {}, child: Text('Resep Dokter')),
                      ),
                    ]
                  ),
                  // Icon(Icons.filter_alt, color: Colors.grey)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            // tips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  SizedBox(width: 6),
                  Text(
                    'Tips Kesehatan Mata',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            Container(
              width: 350,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Hindari menyentuh mata dengan tangan kotor',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Jika iritasi berlanjut, segera konsultasi dokter',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: ListView.builder(
                  itemCount: obatMataList.length + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    // ================= FOOTER =================
                    if (index == obatMataList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              "Anda telah mencapai page akhir nih",
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
                    final obat = obatMataList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 8, // <-- INI
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Gambar Obat
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  obat['image']!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),

                              // Text Area
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nama Obat
                                    Text(
                                      obat['nama']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 4),

                                    // Fungsi
                                    Text(
                                      obat['fungsi']!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(height: 6),

                                    // Kategori
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: obat['kategori'] == 'Obat Bebas'
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        obat['kategori']!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              obat['kategori'] == 'Obat Bebas'
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //next
                              Row(
                                children: [
                                  Icon(
                                    Icons.navigate_next,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
