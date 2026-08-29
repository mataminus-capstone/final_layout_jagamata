import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analisis_kelelahan_controller.dart';

class AnalisisKelelahanView extends GetView<AnalisisKelelahanController> {
  const AnalisisKelelahanView({super.key});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color primaryBlue = Color(0xFF0866C9);
  static const Color titleBlue = Color(0xFF214A80);

  static const Color blueLight = Color(0xFFF0F7FF);
  static const Color blueSoft = Color(0xFFDCEEFF);
  static const Color blueBorder = Color(0xFFBFD9F5);

  static const Color textDark = Color(0xFF20232A);
  static const Color textSecondary = Color(0xFF665A54);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: Stack(
        children: [
          // ============================================================
          // HEADER
          // ============================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color.fromARGB(255, 21, 72, 120),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Text(
                      'Deteksi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 21, 72, 120),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.history_rounded,
                      size: 28,
                      color: Color.fromARGB(255, 21, 72, 120),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // BOTTOM SHEET
          // ============================================================

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: size.height * 0.90,

              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(44),
                  topRight: Radius.circular(44),
                ),
              ),

              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // ==================================================
                    // HANDLE
                    // ==================================================

                    const SizedBox(height: 18),

                    Container(
                      width: 110,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8D8D8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // CONTENT
                    // ==================================================

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          0,
                          20,
                          30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==================================================
                            // TITLE
                            // ==================================================

                            const Center(
                              child: Text(
                                'Hasil Analisis',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.4,
                                  color: titleBlue,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ==================================================
                            // IMAGE
                            // ==================================================

                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Obx(() {
                                  final imageUrl = controller.imageUrl;

                                  debugPrint(
                                    'IMAGE URL DI VIEW: $imageUrl',
                                  );

                                  if (imageUrl.isEmpty) {
                                    return _buildPlaceholderImage(size);
                                  }

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.network(
                                      imageUrl,
                                      width: size.width * 0.40,
                                      height: size.width * 0.40,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }

                                            return Container(
                                              width: size.width * 0.40,
                                              height: size.width * 0.40,
                                              color: const Color(0xFFF1F3F5),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            debugPrint(
                                              'IMAGE NETWORK ERROR: $error',
                                            );

                                            return _buildPlaceholderImage(
                                              size,
                                            );
                                          },
                                    ),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // ==================================================
                            // DIVIDER
                            // ==================================================

                            Container(
                              height: 2,
                              width: double.infinity,
                              color: const Color(0xFFE0E0E0),
                            ),

                            const SizedBox(height: 26),

                            // ==================================================
                            // HASIL KELELAHAN
                            // ==================================================

                            _buildResultCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // DESCRIPTION
                            // ==================================================

                            _buildDescriptionCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // QUESTION
                            // ==================================================

                            _buildQuestionCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // RECOMMENDATION
                            // ==================================================

                            _buildRecommendationCard(),

                            const SizedBox(height: 22),

                            // ==================================================
                            // NOTE
                            // ==================================================

                            _buildFooterNote(),

                            const SizedBox(height: 28),

                            // ==================================================
                            // BUTTON
                            // ==================================================

                            _buildActionButton(),

                            const SizedBox(height: 20),

                            // ==================================================
                            // FOOTER
                            // ==================================================

                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLACEHOLDER IMAGE
  // ============================================================

  Widget _buildPlaceholderImage(Size size) {
    return Container(
      width: size.width * 0.40,
      height: size.width * 0.40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        size: 65,
        color: Colors.grey,
      ),
    );
  }

  // ============================================================
  // RESULT CARD
  // ============================================================

  Widget _buildResultCard() {
    return Obx(() {
      final label = controller.label;
      final confidence = controller.confidence;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: blueLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: blueBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ========================================================
            // ICON
            // ========================================================

            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: blueSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.visibility_outlined,
                color: primaryBlue,
                size: 29,
              ),
            ),

            const SizedBox(width: 15),

            // ========================================================
            // TEXT
            // ========================================================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Terdeteksi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _translateLabel(label),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: titleBlue,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Confidence ${(confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // TRANSLATE LABEL
  // ============================================================

  String _translateLabel(String label) {
    final normalized = label.toLowerCase().trim();

    if (normalized == 'non drowsy') {
      return 'Tidak Mengantuk';
    }

    if (normalized == 'drowsy') {
      return 'Mengantuk';
    }

    if (normalized.contains('fatigue')) {
      return 'Kelelahan';
    }

    if (normalized.contains('tired')) {
      return 'Lelah';
    }

    if (normalized.contains('lelah')) {
      return 'Lelah';
    }

    if (normalized.contains('ngantuk')) {
      return 'Mengantuk';
    }

    if (normalized.contains('kantuk')) {
      return 'Mengantuk';
    }

    if (normalized == 'unknown' || normalized.isEmpty) {
      return 'Tidak diketahui';
    }

    return label;
  }

  // ============================================================
  // DESCRIPTION CARD
  // ============================================================

  Widget _buildDescriptionCard() {
    return Obx(() {
      final fatigued = controller.isFatigued;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD8D8D8),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentang Hasil Analisis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              fatigued
                  ? 'Mata Anda menunjukkan tanda kelelahan '
                      'yang dapat disebabkan oleh penggunaan layar '
                      'berlebih atau kurang istirahat.'
                  : 'Hasil analisis tidak menunjukkan indikasi '
                      'kantuk atau kelelahan yang signifikan. '
                      'Tetap jaga waktu istirahat dan kesehatan mata.',
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: textSecondary,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apakah Anda merasakan pusing?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Jawaban Anda akan digunakan untuk menyesuaikan terapi.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          Obx(
            () => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: VisualDensity.compact,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: primaryBlue,
              value: controller.isPusing.value,
              onChanged: controller.togglePusing,
              title: const Text(
                'Ya, saya merasa pusing',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECOMMENDATION CARD
  // ============================================================

  Widget _buildRecommendationCard() {
    return Obx(() {
      final fatigued = controller.isFatigued;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: blueLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: blueBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fatigued
                  ? 'Rekomendasi Terapi Mandiri'
                  : 'Rekomendasi Menjaga Mata',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _infoChip(
                    Icons.touch_app_outlined,
                    fatigued ? '6 Titik / sisi' : '4 Titik / sisi',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _infoChip(
                    Icons.timer_outlined,
                    fatigued ? '12 Detik/Titik' : '6 Detik/Titik',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _infoChip(
              Icons.unfold_more_rounded,
              fatigued
                  ? 'Tekanan sedang-kuat'
                  : 'Tekanan ringan',
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // INFO CHIP
  // ============================================================

  Widget _infoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.touch_app_outlined,
            size: 21,
            color: primaryBlue,
          ),

          const SizedBox(width: 8),

          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER NOTE
  // ============================================================

  Widget _buildFooterNote() {
    return Text(
      'Catatan: Aplikasi ini hanya alat skrining awal '
      'berbasis gejala dan bukan pengganti diagnosis medis '
      'resmi dari dokter spesialis mata.',
      style: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: Colors.grey.shade600,
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _buildActionButton() {
    return Obx(
      () => Row(
        children: [
          // ========================================================
          // BATAL
          // ========================================================

          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: primaryBlue,
                    width: 1.8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // MULAI TERAPI
          // ========================================================

          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: controller.mulaiTerapi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  controller.isPusing.value
                      ? 'Mulai Terapi Khusus'
                      : 'Mulai Terapi',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Text(
            '© 2025 JagaMata. Hasil ini bukan diagnosis medis final.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF858585),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Gunakan terapi sesuai rekomendasi aplikasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF858585),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Syarat & Ketentuan   Kebijakan Privasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}