import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'package:jagamata/services/image_picker.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'riwayat_deteksi.dart';

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
          style: TextStyle(
            color: Color(0xFF4A77A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Color(0xFF4A77A1)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiwayatDeteksi()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 100, color: Colors.blue[600]),
            SizedBox(height: 20),
            Text(
              "Pindai Kondisi Mata Anda",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Gunakan kamera atau unggah foto untuk memulai analisis mata.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 40),

            // Tombol Camera
            InkWell(
              onTap: () async {
                final imagePath = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraPage()),
                );

                if (imagePath != null) {
                   // camera page returns string path. Convert to XFile for consistent API
                   final file = XFile(imagePath);
                  _processImage(context, file);
                }
              },
              child: Container(
                width: 300,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Scan dengan Kamera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25),

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
            SizedBox(height: 25),

            // Tombol Unggah Foto
            InkWell(
              onTap: () async {
                final pickerService = ImagePickerService();
                final image = await pickerService.pickFromGallery();

                if (image != null) {
                  _processImage(context, image);
                }
              },
              child: Container(
                width: 300,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_search_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Unggah Gambar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // space
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 20, color: Colors.green[400]),
                SizedBox(width: 8),
                Text(
                  "Data Anda aman & Riwayat tersimpan",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _processImage(BuildContext context, XFile imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    final result = await ApiService.detectDisease(imageFile);
    Navigator.pop(context); // Close loading

    if (result['success']) {
      final data = result['data'];
      _showResultDialog(context, data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal memproses gambar')),
      );
    }
  }

  void _showResultDialog(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60, 
                height: 5, 
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Hasil Analisis",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  data['image_url'],
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildResultItem("Diagnosa", data['diagnosis'], Icons.health_and_safety, isTitle: true),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildResultItem("Penanganan & Obat", data['handling'], Icons.medication),
                    SizedBox(height: 15),
                    _buildResultItem("Solusi & Edukasi", data['solution'], Icons.healing),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rekomendasi Obat",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Fetch medicines based on diagnosis category
                    FutureBuilder<Map<String, dynamic>>(
                      future: ApiService.getMedicines(category: data['diagnosis']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()));
                        }
                        if (snapshot.hasError || !snapshot.hasData || !(snapshot.data!['success'] ?? false)) {
                          return Text("Tidak ada rekomendasi obat khusus.");
                        }

                        final medicines = snapshot.data!['data'] as List;
                        if (medicines.isEmpty) {
                          return Text("Tidak ada rekomendasi obat ditemukan untuk kondisi ini.");
                        }

                        return SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medicines.length,
                            itemBuilder: (context, index) {
                              final med = medicines[index];
                              return Container(
                                width: 120,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                      child: Image.network(
                                        med['image_url'] ?? '',
                                        height: 80,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(height: 80, color: Colors.grey[200], child: Icon(Icons.image_not_supported)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            med['name'] ?? 'Obat',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                          Text(
                                            med['price'] != null ? 'Rp ${med['price']}' : '',
                                            style: TextStyle(fontSize: 10, color: Colors.orange[800]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF80AFCC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text("Tutup", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String title, String content, IconData icon, {bool isTitle = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue[600]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.black87, 
                  fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                  height: 1.5
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
