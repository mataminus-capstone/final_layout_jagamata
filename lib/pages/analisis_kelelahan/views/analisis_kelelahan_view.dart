import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analisis_kelelahan_controller.dart';
final controller = Get.find<AnalisisKelelahanController>();

class AnalisisKelelahanView extends GetView<AnalisisKelelahanController> {
  const AnalisisKelelahanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // =========================
          // HEADER
          // =========================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF0866C9),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Deteksi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0866C9),
                      ),
                    ),
                  ),
                  const Icon(Icons.history, size: 30, color: Color(0xFF0866C9)),
                ],
              ),
            ),
          ),

          // =========================
          // WHITE SHEET
          // =========================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    // Handle
                    Container(
                      width: 110,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color(0xFFD8D8D8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =========================
                            // TITLE
                            // =========================
                            const Center(
                              child: Text(
                                'Hasil Analisis',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF214A80),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =========================
                            // IMAGE
                            // =========================
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.asset(
                                  'assets/images/sample_face.jpg',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 150,
                                      height: 150,
                                      color: const Color(0xFFEFEFEF),
                                      child: const Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // =========================
                            // DIVIDER
                            // =========================
                            Divider(
                              thickness: 1.5,
                              color: Colors.grey.shade300,
                            ),

                            const SizedBox(height: 20),

                            // =========================
                            // STATUS
                            // =========================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3FF),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xFFC6DCF7),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 65,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD4E9FC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.visibility_outlined,
                                      size: 38,
                                      color: Color(0xFF0866C9),
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status Terdeteksi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      const Text(
                                        'Kelelahan',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0866C9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // =========================
                            // DESCRIPTION
                            // =========================
                            const Text(
                              'Mata Anda menunjukan tanda kelelahan '
                              'akibat penggunaan layar berlebih atau '
                              'kurang istirahat.',
                              style: TextStyle(
                                fontSize: 17,
                                height: 1.3,
                                color: Color(0xFF20232A),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // =========================
                            // QUESTION
                            // =========================
                            const Text(
                              'Apakah Anda merasakan pusing?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF20232A),
                              ),
                            ),

                            const SizedBox(height: 3),

                            // =========================
                            // CHECKBOX
                            // =========================
                            Obx(
                              () => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: const Color(0xFF0866C9),
                                value: controller.isPusing.value,
                                onChanged: controller.togglePusing,
                                title: const Text(
                                  'Ya, saya merasa pusing',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =========================
                            // RECOMMENDATION
                            // =========================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3FF),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xFFC6DCF7),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Rekomendasi Terapi Mandiri',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0866C9),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  // Chips
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _infoChip(
                                          Icons.touch_app_outlined,
                                          '6 Titik / sisi',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _infoChip(
                                          Icons.timer_outlined,
                                          '12 Detik/Titik',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: _infoChip(
                                      Icons.unfold_more,
                                      'Tekanan sedang-kuat',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // =========================
                            // NOTE
                            // =========================
                            Text(
                              'Catatan: Aplikasi ini hanya alat skrining '
                              'awal berbasis gejala dan bukan pengganti '
                              'diagnosis medis resmi dari dokter spesialis mata.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.35,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // =========================
                            // BUTTON
                            // =========================
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF0866C9),
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Batal',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0866C9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: controller.mulaiTerapi,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0866C9,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: Obx(
                                        () => Text(
                                          controller.isPusing.value
                                              ? 'Mulai Terapi Khusus'
                                              : 'Mulai Terapi',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
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

  // =========================
  // INFO CHIP
  // =========================

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 23, color: const Color(0xFF0866C9)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
