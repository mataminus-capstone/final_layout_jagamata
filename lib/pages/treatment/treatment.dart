import 'package:flutter/material.dart';
import 'package:jagamata/main.dart' show cameras;
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/pages/treatment/acupressure_page.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:jagamata/utils/label_utils.dart';

class TreatmentPage extends StatefulWidget {
  const TreatmentPage({super.key});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);
  final Color kOrange = const Color(0xFFff7043);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Treatment Mata",
          style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Center Image
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                  border: Border.all(
                    color: kLightBlue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/tretmen.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        Icon(Icons.spa_outlined, size: 60, color: kLightBlue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title & Desc
            Text(
              "Pilihan Terapi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Pilih metode perawatan mata yang anda inginkan untuk membantu merilekskan mata.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Highlight Badge (Simple eye care)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: kLightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kLightBlue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: kLightBlue),
                  const SizedBox(width: 8),
                  Text(
                    "Simple eye care, everyday",
                    style: TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Selection Options
            _buildOptionCard(
              context,
              title: "Senam Mata",
              description:
                  "Latihan ringan untuk meregangkan otot mata yang lelah.",
              icon: Icons.remove_red_eye_rounded,
              color: kDarkBlue,
              onTap: () => Navigator.pushNamed(context, '/senameyes'),
            ),

            const SizedBox(height: 20),

            _buildOptionCard(
              context,
              title: "Teknik Akupresur",
              description:
                  "Pijatan lembut pada titik-titik di area sekitar mata berdasarkan hasil analisis potensi kelelahan terakhir.",
              icon: Icons.touch_app_rounded,
              color: kTosca,
              onTap: () => _navigateToAcupressure(context),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Fetch hasil deteksi kelelahan terakhir dan navigate ke halaman akupresur
  Future<void> _navigateToAcupressure(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: kTosca),
              const SizedBox(height: 16),
              Text(
                "Mengambil data kondisi mata...",
                style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Fetch drowsiness history
      final result = await ApiService.getDrowsinessHistory();

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      EyeCondition eyeCondition;
      String? lastDetectionInfo;

      if (result['success'] &&
          result['data'] != null &&
          (result['data'] as List).isNotEmpty) {
        // Get the most recent detection (first item)
        final lastDetection = result['data'][0];
        final String label = (lastDetection['label'] ?? '')
            .toString()
            .toLowerCase();
        final String createdAt = lastDetection['created_at'] ?? '';

        // Determine condition using same logic as detection page
        final bool isNotFatigued =
            label.contains('non') ||
            label.contains('not') ||
            label.contains('tidak') ||
            label.contains('awake') ||
            label.contains('normal') ||
            label.contains('segar') ||
            label.contains('alert');

        final bool hasFatigueKeyword =
            label.contains('drowsy') ||
            label.contains('fatigue') ||
            label.contains('tired') ||
            label.contains('kantuk') ||
            label.contains('lelah') ||
            label.contains('ngantuk');

        final bool isFatigued = hasFatigueKeyword && !isNotFatigued;
        eyeCondition = isFatigued ? EyeCondition.fatigued : EyeCondition.normal;

        // Format detection info
        lastDetectionInfo = _formatLastDetection(
          lastDetection['label'],
          createdAt,
        );
      } else {
        // No history found, show selection dialog
        if (!mounted) return;
        _showNoHistoryDialog(context);
        return;
      }

      // Show confirmation dialog with last detection info
      if (!mounted) return;
      _showAcupressureConfirmDialog(context, eyeCondition, lastDetectionInfo);
    } catch (e) {
      // Close loading dialog if still showing
      if (!mounted) return;
      Navigator.pop(context);

      // Show error and offer manual selection
      _showErrorDialog(context, e.toString());
    }
  }

  String _formatLastDetection(String label, String createdAt) {
    // Translate label to Indonesian
    final translatedLabel = translateDrowsinessLabel(label);

    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(date);

      String timeAgo;
      if (diff.inMinutes < 60) {
        timeAgo = "${diff.inMinutes} menit lalu";
      } else if (diff.inHours < 24) {
        timeAgo = "${diff.inHours} jam lalu";
      } else if (diff.inDays < 7) {
        timeAgo = "${diff.inDays} hari lalu";
      } else {
        timeAgo = "${date.day}/${date.month}/${date.year}";
      }

      return "$translatedLabel ($timeAgo)";
    } catch (e) {
      return translatedLabel;
    }
  }

  void _showAcupressureConfirmDialog(
    BuildContext context,
    EyeCondition condition,
    String? lastDetectionInfo,
  ) {
    final bool isFatigued = condition == EyeCondition.fatigued;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isFatigued
                    ? kOrange.withOpacity(0.1)
                    : kTosca.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFatigued ? Icons.warning_amber_rounded : Icons.check_circle,
                size: 40,
                color: isFatigued ? kOrange : kTosca,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isFatigued ? "Mode Indikasi Lelah" : "Mode Terapi Maintenance",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8),

            // Last detection info
            if (lastDetectionInfo != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      "Deteksi terakhir: $lastDetectionInfo",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Description
            Text(
              isFatigued
                  ? "Berdasarkan analisis terakhir, mata Anda menunjukkan indikasi kelelahan. Terapi akan menggunakan 6 titik akupresur dengan tekanan sedang-kuat."
                  : "Berdasarkan analisis terakhir, mata Anda menunjukkan kondisi baik. Terapi akan menggunakan 4 titik akupresur dengan tekanan ringan untuk maintenance.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Therapy info badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
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
                  label: isFatigued ? "Tekanan Sedang-Kuat" : "Tekanan Ringan",
                  color: isFatigued ? kOrange : kTosca,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showManualSelectionDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Pilih Manual",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AcupressurePage(
                            cameras: cameras,
                            eyeCondition: condition,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.spa, color: Colors.white),
                    label: const Text(
                      "Mulai Terapi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isFatigued ? kOrange : kTosca,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  void _showNoHistoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            Icon(Icons.info_outline, size: 50, color: kLightBlue),
            const SizedBox(height: 16),

            Text(
              "Belum Ada Riwayat Deteksi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Anda belum pernah melakukan analisis potensi kelelahan mata. Silakan pilih mode terapi secara manual atau lakukan deteksi terlebih dahulu.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pushNamed(context, '/deteksi');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: kLightBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Deteksi Dulu",
                      style: TextStyle(color: kLightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showManualSelectionDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: kTosca,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Pilih Manual",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  void _showManualSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Pilih Mode Terapi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Pilih mode terapi sesuai kondisi mata Anda saat ini.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Fatigued option
            _buildModeOption(
              ctx,
              title: "Indikasi Kelelahan",
              description:
                  "6 titik akupresur, 12 detik/titik, tekanan sedang-kuat",
              icon: Icons.warning_amber_rounded,
              color: kOrange,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AcupressurePage(
                      cameras: cameras,
                      eyeCondition: EyeCondition.fatigued,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Normal option
            _buildModeOption(
              ctx,
              title: "Mata Normal (Maintenance)",
              description: "4 titik akupresur, 6 detik/titik, tekanan ringan",
              icon: Icons.check_circle,
              color: kTosca,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AcupressurePage(
                      cameras: cameras,
                      eyeCondition: EyeCondition.normal,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: kOrange),
            const SizedBox(width: 8),
            const Text("Terjadi Kesalahan"),
          ],
        ),
        content: Text(
          "Gagal mengambil data riwayat analisis. Anda masih dapat memilih mode terapi secara manual.",
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showManualSelectionDialog(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kTosca),
            child: const Text(
              "Pilih Manual",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
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

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
