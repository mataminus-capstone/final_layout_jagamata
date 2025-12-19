import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'package:jagamata/services/image_picker.dart';

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
                  debugPrint("Foto diambil: $imagePath");
                  // nanti → kirim ke model
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
                  debugPrint("Gambar dipilih: ${image.path}");
                  // nanti → kirim ke model / halaman hasil
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
                  "Data Anda aman, tidak tersimpan",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
