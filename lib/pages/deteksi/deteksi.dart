import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_page.dart';
import 'package:jagamata/services/image_picker.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/pages/treatment/acupressure_page.dart';
import 'package:jagamata/main.dart' show cameras;
import 'package:jagamata/utils/label_utils.dart';
import 'riwayat_deteksi.dart';
import 'riwayat_kelelahan.dart';

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
              _showHistoryChoice(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pilih Layanan Deteksi",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Silakan pilih jenis deteksi yang Anda butuhkan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 40),

              // Button 1: Deteksi Potensi Penyakit Mata
              _buildDetectionOption(
                context,
                title: "Deteksi Potensi Penyakit Mata",
                subtitle: "Katarak, Glaukoma, dll",
                icon: Icons.health_and_safety_outlined,
                color: Color(0xFF80AFCC),
                onTap: () => _showImageSourceDialog(context, isDisease: true),
              ),

              SizedBox(height: 20),

              // Button 2: Deteksi Potensi Kelelahan Mata
              _buildDetectionOption(
                context,
                title: "Deteksi Potensi Kelelahan Mata",
                subtitle: "Analisis Kantuk & Kelelahan",
                icon: Icons.remove_red_eye_outlined,
                color: Color(
                  0xFFA2C38E,
                ), // Greenish for variety or keep consistent
                onTap: () => _showImageSourceDialog(context, isDisease: false),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetectionOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: Colors.blue[900]),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showHistoryChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Lihat Riwayat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text("Riwayat Deteksi Potensi Penyakit"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RiwayatDeteksi()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.timelapse, color: Colors.green),
              title: Text("Riwayat Kelelahan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RiwayatKelelahan()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, {required bool isDisease}) {
    // Capture the parent context BEFORE showing the bottom sheet
    // This context will remain valid after the bottom sheet is closed
    final rootContext = context;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDisease ? "Scan Penyakit Mata" : "Scan Kelelahan Mata",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceButton(
                  bottomSheetContext,
                  icon: Icons.camera_alt,
                  label: "Kamera",
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    final imagePath = await Navigator.push(
                      rootContext, // Use root context for navigation
                      MaterialPageRoute(builder: (_) => const CameraPage()),
                    );
                    if (imagePath != null && mounted) {
                      _processImage(rootContext, XFile(imagePath), isDisease);
                    }
                  },
                ),
                _buildSourceButton(
                  bottomSheetContext,
                  icon: Icons.photo_library,
                  label: "Galeri",
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    final pickerService = ImagePickerService();
                    final image = await pickerService.pickFromGallery();
                    if (image != null && mounted) {
                      _processImage(rootContext, image, isDisease);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _processImage(
    BuildContext context,
    XFile imageFile,
    bool isDisease,
  ) async {
    // Check if widget is still mounted before showing dialog
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(child: CircularProgressIndicator()),
    );

    Map<String, dynamic> result;
    try {
      if (isDisease) {
        result = await ApiService.detectDisease(imageFile);
      } else {
        result = await ApiService.detectDrowsiness(imageFile);
      }
    } catch (e) {
      result = {'success': false, 'message': 'Error: ${e.toString()}'};
    }

    // Check if widget is still mounted before closing dialog
    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (result['success']) {
      final data = result['data'];
      if (!mounted) return;
      if (isDisease) {
        _showResultDialog(context, data);
      } else {
        _showDrowsinessResultDialog(context, data);
      }
    } else {
      if (!mounted) return;
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
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Hasil Analisis Potensi Penyakit",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
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
                  errorBuilder: (ctx, err, stack) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildResultItem(
              "Diagnosa",
              data['diagnosis'],
              Icons.health_and_safety,
              isTitle: true,
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildResultItem(
                      "Penanganan & Obat",
                      data['handling'],
                      Icons.medication,
                    ),
                    SizedBox(height: 15),
                    _buildResultItem(
                      "Solusi & Edukasi",
                      data['solution'],
                      Icons.healing,
                    ),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rekomendasi Obat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Fetch medicines based on diagnosis category
                    FutureBuilder<Map<String, dynamic>>(
                      future: ApiService.getMedicines(
                        category: data['diagnosis'],
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            !(snapshot.data!['success'] ?? false)) {
                          return Text("Tidak ada rekomendasi obat khusus.");
                        }

                        final medicines = snapshot.data!['data'] as List;
                        if (medicines.isEmpty) {
                          return Text(
                            "Tidak ada rekomendasi obat ditemukan untuk kondisi ini.",
                          );
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
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        med['image_url'] ?? '',
                                        height: 80,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 80,
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            med['name'] ?? 'Obat',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            med['price'] != null
                                                ? 'Rp ${med['price']}'
                                                : '',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.orange[800],
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Tutup",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDrowsinessResultDialog(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    // Determine if the user is fatigued based on the label
    final String label = (data['label'] ?? 'Unknown').toString().toLowerCase();

    // First check for NON-fatigued indicators (awake, non drowsy, etc.)
    final bool isNotFatigued =
        label.contains('non') ||
        label.contains('not') ||
        label.contains('tidak') ||
        label.contains('awake') ||
        label.contains('normal') ||
        label.contains('segar') ||
        label.contains('alert');

    // Only consider fatigued if NOT marked as non-fatigued
    final bool hasFatigueKeyword =
        label.contains('drowsy') ||
        label.contains('fatigue') ||
        label.contains('tired') ||
        label.contains('kantuk') ||
        label.contains('lelah') ||
        label.contains('ngantuk');

    // Final determination: fatigued only if has fatigue keyword AND not marked as non-fatigued
    final bool isFatigued = hasFatigueKeyword && !isNotFatigued;

    final Color kDarkBlue = const Color(0xFF11417f);
    final Color kTosca = const Color(0xFFa2c38e);
    final Color kOrange = const Color(0xFFff7043);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (bottomSheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Hasil Analisis Potensi Kelelahan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  data['image_url'],
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Result Display
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isFatigued
                    ? kOrange.withOpacity(0.1)
                    : kTosca.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isFatigued
                      ? kOrange.withOpacity(0.3)
                      : kTosca.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isFatigued
                          ? kOrange.withOpacity(0.2)
                          : kTosca.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFatigued
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle,
                      size: 30,
                      color: isFatigued ? kOrange : kTosca,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Indikasi Terdeteksi",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          translateDrowsinessLabel(data['label']),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isFatigued ? kOrange : kTosca,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      "${((data['confidence'] ?? 0) * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kDarkBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Acupressure Recommendation Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isFatigued
                      ? [kOrange.withOpacity(0.1), kOrange.withOpacity(0.05)]
                      : [kTosca.withOpacity(0.1), kTosca.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isFatigued
                      ? kOrange.withOpacity(0.2)
                      : kTosca.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.spa,
                        color: isFatigued ? kOrange : kTosca,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Rekomendasi Akupresur",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    isFatigued
                        ? "Mata Anda menunjukkan indikasi kelelahan. Kami merekomendasikan terapi akupresur dengan 6 titik khusus untuk membantu merilekskan mata."
                        : "Mata Anda menunjukkan kondisi baik! Anda dapat melakukan terapi akupresur maintenance untuk menjaga kesehatan mata.",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Info badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoBadge(
                        icon: Icons.touch_app,
                        label: isFatigued ? "6 Titik/Sisi" : "4 Titik/Sisi",
                        color: isFatigued ? kOrange : kTosca,
                      ),
                      _buildInfoBadge(
                        icon: Icons.timer,
                        label: isFatigued ? "12 Detik/Titik" : "6 Detik/Titik",
                        color: isFatigued ? kOrange : kTosca,
                      ),
                      _buildInfoBadge(
                        icon: Icons.compress,
                        label: isFatigued
                            ? "Tekanan Sedang-Kuat"
                            : "Tekanan Ringan",
                        color: isFatigued ? kOrange : kTosca,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      // Navigate to Acupressure page with the appropriate condition
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AcupressurePage(
                            cameras: cameras,
                            eyeCondition: isFatigued
                                ? EyeCondition.fatigued
                                : EyeCondition.normal,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.spa, color: Colors.white),
                    label: Text(
                      "Mulai Akupresur",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFatigued ? kOrange : kTosca,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
    String title,
    String content,
    IconData icon, {
    bool isTitle = false,
  }) {
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
