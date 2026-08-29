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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /*
     * ==========================================================
     * FALLBACK DATA
     * ==========================================================
     *
     * Kalau controller somehow belum membawa data,
     * kita ambil langsung dari Get.arguments.
     *
     * Ini sengaja dibuat supaya UI tidak kembali
     * menjadi "Tidak Diketahui".
     */

    Map<String, dynamic> data = controller.data;

    final arguments = Get.arguments;

    if (data.isEmpty && arguments is Map) {
      data = Map<String, dynamic>.from(arguments);
    }

    // ==========================================================
    // DATA API
    // ==========================================================

    final String diagnosis =
        data['diagnosis']?.toString().trim().isNotEmpty == true
            ? data['diagnosis'].toString().trim()
            : 'Tidak Diketahui';

    final String imageUrl =
        data['image_url']?.toString().trim() ?? '';

    final String handling =
        data['handling']?.toString().trim() ??
        'Informasi penanganan belum tersedia.';

    final String solution =
        data['solution']?.toString().trim() ??
        'Informasi solusi belum tersedia.';

    double confidence = 0.0;

    final confidenceValue = data['confidence'];

    if (confidenceValue is num) {
      confidence = confidenceValue.toDouble();
    } else if (confidenceValue is String) {
      confidence = double.tryParse(confidenceValue) ?? 0.0;
    }

    // ==========================================================
    // DEBUG UI
    // ==========================================================

    print('========================================');
    print('[ANALISIS POTENSI VIEW]');
    print('DATA YANG DIPAKAI UI:');
    print('diagnosis: $diagnosis');
    print('confidence: $confidence');
    print('image_url: $imageUrl');
    print('handling: $handling');
    print('solution: $solution');
    print('========================================');

    return Scaffold(
      backgroundColor: Colors.grey.shade600,

      body: Stack(
        children: [

          // ======================================================
          // HEADER
          // ======================================================

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
                      color: Color(0xFF154878),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Text(
                      'Deteksi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF154878),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.history_rounded,
                      size: 28,
                      color: Color(0xFF154878),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // BOTTOM SHEET
          // ======================================================

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
                        color: Color(0xFFD8D8D8),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // CONTENT
                    // ==================================================

                    Expanded(
                      child: SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),

                        padding:
                            const EdgeInsets.fromLTRB(
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
                                textAlign:
                                    TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight.w700,
                                  letterSpacing: -0.4,
                                  color: titleBlue,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ==================================================
                            // IMAGE
                            // ==================================================

                            _buildImage(
                              size,
                              imageUrl,
                            ),

                            const SizedBox(height: 30),

                            // ==================================================
                            // DIVIDER
                            // ==================================================

                            Container(
                              height: 2,
                              width: double.infinity,
                              color: const Color(
                                0xFFE0E0E0,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // ==================================================
                            // DIAGNOSIS
                            // ==================================================

                            _buildDiseaseCard(
                              diagnosis,
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // CONFIDENCE
                            // ==================================================

                            _buildConfidenceCard(
                              confidence,
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // IMPORTANT
                            // ==================================================

                            _buildImportantCard(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // HANDLING
                            // ==================================================

                            _buildContentCard(
                              title: 'Penanganan',
                              icon: Icons.medical_services_outlined,
                              content: handling,
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // SOLUTION
                            // ==================================================

                            _buildContentCard(
                              title: 'Saran & Solusi',
                              icon: Icons.lightbulb_outline_rounded,
                              content: solution,
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // HOSPITAL
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
  // IMAGE
  // ==============================================================

  Widget _buildImage(
    Size size,
    String imageUrl,
  ) {
    if (imageUrl.isEmpty) {
      return _imagePlaceholder(size);
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(28),

          child: Image.network(
            imageUrl,

            width: size.width * 0.40,
            height: size.width * 0.28,

            fit: BoxFit.cover,

            loadingBuilder:
                (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                width: size.width * 0.40,
                height: size.width * 0.28,
                color: const Color(0xFFF1F3F5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },

            errorBuilder:
                (context, error, stackTrace) {
              return _imagePlaceholder(size);
            },
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(Size size) {
    return Container(
      width: size.width * 0.40,
      height: size.width * 0.28,

      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius:
            BorderRadius.circular(28),
      ),

      child: const Icon(
        Icons.remove_red_eye_outlined,
        size: 65,
        color: Colors.grey,
      ),
    );
  }

  // ==============================================================
  // DISEASE CARD
  // ==============================================================

  Widget _buildDiseaseCard(
    String diagnosis,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: dangerLight,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: dangerBorder,
          width: 1.5,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [

          // ========================================================
          // ICON
          // ========================================================

          Container(
            width: 52,
            height: 52,

            decoration:
                const BoxDecoration(
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
          // HASIL
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  'Potensi Kondisi Mata',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                    color: danger,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  diagnosis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                    color: danger,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Perlu pemeriksaan medis',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
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
  // CONFIDENCE
  // ==============================================================

  Widget _buildConfidenceCard(
    double confidence,
  ) {
    final confidencePercent =
        (confidence * 100)
            .clamp(0, 100)
            .toStringAsFixed(1);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1.3,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 44,
            height: 44,

            decoration:
                BoxDecoration(
              color:
                  primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.analytics_outlined,
              color: primaryBlue,
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  'Tingkat Keyakinan Model',
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$confidencePercent%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                    color: titleBlue,
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

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1.3,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 22,
                height: 22,

                decoration:
                    const BoxDecoration(
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
                    fontWeight:
                        FontWeight.w700,
                    color: danger,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          const Text(
            'Hasil ini merupakan skrining awal '
            'berbasis gambar dan bukan diagnosis '
            'medis final. Untuk memastikan kondisi '
            'mata, lakukan pemeriksaan langsung '
            'dengan dokter spesialis mata.',

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
  // CONTENT CARD
  // ==============================================================

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1.3,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color:
                      primaryBlue.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w700,
                  color: textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
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

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: dangerBorder,
          width: 1.5,
        ),
      ),

      child: Column(
        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [

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

              const Expanded(
                child: Text(
                  'Temukan rumah sakit mata '
                  'terdekat untuk pemeriksaan '
                  'lebih lanjut.',

                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight:
                        FontWeight.w500,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton(
              onPressed: () {
                // TODO:
                // Navigasi ke pencarian rumah sakit
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: danger,
                foregroundColor: Colors.white,
                elevation: 0,

                shape:
                    RoundedRectangleBorder(
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
                      fontWeight:
                          FontWeight.w700,
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
            '© 2025 JagaMata. Hasil ini bukan '
            'diagnosis medis final.',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF858585),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Segera konsultasikan dengan '
            'spesialis mata.',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF858585),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Syarat & Ketentuan   '
            'Kebijakan Privasi',

            textAlign:
                TextAlign.center,

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