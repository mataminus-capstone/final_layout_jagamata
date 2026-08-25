import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/riwayat_deteksi_mata_controller.dart';

class RiwayatDeteksiMataView extends StatelessWidget {
  const RiwayatDeteksiMataView({super.key});

  static const Color primaryBlue = Color(0xFF194D89);
  static const Color background = Color(0xFFF7F7F7);

  static const Color textDark = Color(0xFF172B4D);
  static const Color textSecondary = Color(0xFF666666);

  static const Color green = Color(0xFF00B887);
  static const Color red = Color(0xFFD92D20);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RiwayatDeteksiMataController());

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),

                _buildTabs(controller),

                if (controller.selectedTab.value == 0)
                  _buildDiseaseHistory()
                else
                  _buildFatigueHistory(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: primaryBlue,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),

      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Riwayat Deteksi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 30),
        ],
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs(RiwayatDeteksiMataController controller) {
    final selected = controller.selectedTab.value;

    return Container(
      width: double.infinity,
      color: primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: 'Potensi Penyakit',
              icon: Icons.shield_outlined,
              selected: selected == 0,
              onTap: () {
                controller.changeTab(0);
              },
            ),
          ),

          Expanded(
            child: _buildTab(
              title: 'Kelelahan Mata',
              icon: Icons.remove_red_eye_outlined,
              selected: selected == 1,
              onTap: () {
                controller.changeTab(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? Colors.white : Colors.white.withOpacity(0.55),
            ),

            const SizedBox(width: 7),

            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(0.55),

                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DISEASE HISTORY
  // ============================================================

  Widget _buildDiseaseHistory() {
    return Column(
      children: [
        _buildInfoHeader(
          icon: Icons.shield_rounded,
          title: 'Riwayat Deteksi Penyakit Mata',
          description: 'Analisis penyakit dan kondisi mata',
          disease: true,
        ),

        const SizedBox(height: 18),

        _buildDiseaseCard(
          disease: 'Konjungtivitis',
          confidence: '92.8%',
          status: 'Perlu Perhatian',
          isNormal: false,
          time: '26-01-2026 | 07:16',
        ),

        const SizedBox(height: 14),

        _buildDiseaseCard(
          disease: 'Tidak Terdeteksi',
          confidence: '92.8%',
          status: 'Normal',
          isNormal: true,
          time: '26-01-2026 | 07:16',
        ),

        const SizedBox(height: 14),

        _buildDiseaseCard(
          disease: 'Tidak Terdeteksi',
          confidence: '92.8%',
          status: 'Normal',
          isNormal: true,
          time: '26-01-2026 | 07:16',
        ),
      ],
    );
  }

  // ============================================================
  // FATIGUE HISTORY
  // ============================================================

  Widget _buildFatigueHistory() {
    return Column(
      children: [
        _buildInfoHeader(
          icon: Icons.remove_red_eye_rounded,
          title: 'Riwayat Deteksi Kelelahan Mata',
          description: 'Analisis kantuk dan kelelahan mata',
          disease: false,
        ),

        const SizedBox(height: 18),

        _buildFatigueCard(
          status: 'Kelelahan',
          confidence: '94.5%',
          time: '26-01-2026 | 07:16',
          fatigue: true,
        ),

        const SizedBox(height: 14),

        _buildFatigueCard(
          status: 'Tidak Kelelahan',
          confidence: '94.5%',
          time: '26-01-2026 | 01:16',
          fatigue: false,
        ),

        const SizedBox(height: 14),

        _buildFatigueCard(
          status: 'Tidak Kelelahan',
          confidence: '94.5%',
          time: '26-01-2026 | 01:16',
          fatigue: false,
        ),
      ],
    );
  }

  // ============================================================
  // INFO HEADER
  // ============================================================

  Widget _buildInfoHeader({
    required IconData icon,
    required String title,
    required String description,
    required bool disease,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: disease
              ? const [Color(0xFFDDF8FA), Color(0xFFBDEDF1)]
              : const [Color(0xFFE5F7F3), Color(0xFFD5F0E8)],
        ),

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: disease
                  ? const Color(0xFFC8ECEF)
                  : const Color(0xFFD0EBE7),

              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: disease
                  ? const Color(0xFF126F70)
                  : const Color(0xFF165E5B),
              size: 26,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DISEASE CARD
  // ============================================================

  Widget _buildDiseaseCard({
    required String disease,
    required String confidence,
    required String status,
    required bool isNormal,
    required String time,
  }) {
    final color = isNormal ? green : red;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE5E5E5)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // ICON
    Icon(
      isNormal
          ? Icons.check_circle_outline
          : Icons.warning_amber_rounded,
      size: 22,
      color: isNormal
          ? green
          : const Color(0xFF66554D),
    ),

    const SizedBox(width: 8),

    // JUDUL
    Expanded(
      child: Text(
        'Potensi Penyakit',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
    ),

    const SizedBox(width: 12),

    // TANGGAL DI POJOK KANAN
    Text(
      time,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 12,
        color: textSecondary,
      ),
    ),
  ],
),
          const Divider(height: 24),

          // CONTENT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // IMAGE PLACEHOLDER
              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Icon(
                  Icons.remove_red_eye_rounded,
                  size: 48,
                  color: isNormal
                      ? const Color(0xFF7B858C)
                      : const Color(0xFF8A6B5C),
                ),
              ),

              const SizedBox(width: 14),

              // DETAIL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      disease,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Confidence $confidence',
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          isNormal
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,

                          size: 19,
                          color: color,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FATIGUE CARD
  // ============================================================

  Widget _buildFatigueCard({
    required String status,
    required String confidence,
    required String time,
    required bool fatigue,
  }) {
    final color = fatigue ? const Color(0xFFB06C3C) : green;

    final bgColor = fatigue ? const Color(0xFFFFEFE2) : const Color(0xFFE4F8F1);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE5E5E5)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          // ===========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ICON
              Icon(
                fatigue
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                size: 22,
                color: fatigue ? const Color(0xFF66554D) : green,
              ),

              const SizedBox(width: 8),

              // JUDUL
              Expanded(
                child: Text(
                  'Deteksi Kelelahan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // TANGGAL DI POJOK KANAN
              Text(
                time,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
          const Divider(height: 24),

          // BODY
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Icon(
                  Icons.person_rounded,
                  size: 52,
                  color: Color(0xFF89939B),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontSize: 14, color: textSecondary),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Confidence',
                            style: TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                        ),

                        Text(
                          confidence,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
