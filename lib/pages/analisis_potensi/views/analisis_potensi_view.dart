import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analisis_potensi_controller.dart';

class AnalisisPotensiView extends GetView<AnalisisPotensiController> {
  const AnalisisPotensiView({super.key});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color primaryBlue = Color(0xFF0866C9);
  static const Color titleBlue = Color(0xFF214A80);

  static const Color danger = Color(0xFFD92D20);
  static const Color dangerLight = Color(0xFFFFF4F3);
  static const Color dangerSoft = Color(0xFFFFE3E0);
  static const Color dangerBorder = Color(0xFFE7B5B0);

  static const Color textDark = Color(0xFF20232A);
  static const Color textSecondary = Color(0xFF665A54);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade600,

      body: Stack(
        children: [
          // ========================================================
          // HEADER DI BELAKANG BOTTOM SHEET
          // ========================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 32,
                      color: Color(0xFF4A77A1),
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
                      color:  Color.fromARGB(255, 21, 72, 120),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ========================================================
          // BOTTOM SHEET
          // ========================================================

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,

              // 90% layar, sisanya header tetap terlihat
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
                    // SCROLL CONTENT
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

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
                                  borderRadius:
                                      BorderRadius.circular(28),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        0.08,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),

                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(28),

                                  child: Image.asset(
                                    'assets/images/sample_eye.jpg',

                                    // Responsive terhadap width HP
                                    width: size.width * 0.40,
                                    height: size.width * 0.28,

                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                      return Container(
                                        width:
                                            size.width * 0.40,
                                        height:
                                            size.width * 0.28,

                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                            0xFFF1F3F5,
                                          ),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(28),
                                        ),

                                        child: const Icon(
                                          Icons
                                              .remove_red_eye_outlined,
                                          size: 65,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
                            // HASIL PENYAKIT
                            // ==================================================

                            _buildDiseaseCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // IMPORTANT CARD
                            // ==================================================

                            _buildImportantCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // ACTION CARD
                            // ==================================================

                            _buildActionCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // HOSPITAL CARD
                            // ==================================================

                            _buildHospitalCard(),

                            const SizedBox(height: 28),

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

  // ==============================================================
  // DISEASE CARD
  // ==============================================================

  Widget _buildDiseaseCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: dangerLight,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: dangerBorder,
          width: 1.5,
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ========================================================
          // WARNING ICON
          // ========================================================

          Container(
            width: 52,
            height: 52,

            decoration: const BoxDecoration(
              color: dangerSoft,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.warning_rounded,
              color: danger,
              size: 29,
            ),
          ),

          const SizedBox(width: 15),

          // ========================================================
          // TEXT
          // ========================================================

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Gejala Uveitis / Katarak',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: danger,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  '(Perlu Pemeriksaan Medis)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // IMPORTANT CARD
  // ==============================================================

  Widget _buildImportantCard() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ========================================================
          // TITLE
          // ========================================================

          Row(
            children: [
              Container(
                width: 22,
                height: 22,

                decoration: const BoxDecoration(
                  color: danger,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'PENTING UNTUK DIKETAHUI',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: danger,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // ========================================================
          // DESCRIPTION
          // ========================================================

          const Text(
            'Hasil ini skrining awal berbasis gejala. '
            'Gejala yang terdeteksi memerlukan pemeriksaan '
            'langsung menggunakan alat medis khusus. '
            'Kondisi ini TIDAK BISA disembuhkan dengan obat bebas.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // ACTION CARD
  // ==============================================================

  Widget _buildActionCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFD1D1D1),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Apa yang Sebaiknya Dilakukan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Segera konsultasikan kondisi mata Anda dengan '
            'dokter spesialis mata (Sp.M) untuk mendapatkan '
            'pemeriksaan, diagnosis, dan penanganan yang sesuai.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // HOSPITAL CARD
  // ==============================================================

  Widget _buildHospitalCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: dangerLight,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: dangerBorder,
          width: 1.5,
        ),
      ),

      child: Column(
        children: [
          // ========================================================
          // TOP
          // ========================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [
              // ======================================================
              // HOSPITAL ICON
              // ======================================================

              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: primaryBlue,
                  size: 42,
                ),
              ),

              const SizedBox(width: 14),

              // ======================================================
              // TEXT
              // ======================================================

              const Expanded(
                child: Text(
                  'Temukan rumah sakit mata terdekat '
                  'untuk pemeriksaan lebih lanjut.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ========================================================
          // BUTTON
          // ========================================================

          SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigasi ke halaman / fitur
                // pencarian rumah sakit
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: danger,
                foregroundColor: Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 19,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Cari Rumah Sakit Terdekat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // FOOTER
  // ==============================================================

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
            'Segera konsultasikan dengan spesialis mata.',
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