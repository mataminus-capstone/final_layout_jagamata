// Lokasi: lib/models/acupressure_model.dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum EyeSide { left, right }

class AcupressurePoint {
  final String title;
  final String instruction;
  final String description; // Tambahan untuk info detail
  final FaceLandmarkType landmarkType;
  final EyeSide side;
  final double offsetX; // Geser Horizontal
  final double offsetY; // Geser Vertikal

  AcupressurePoint({
    required this.title,
    required this.instruction,
    required this.description,
    required this.landmarkType,
    required this.side,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  });
}

// ==============================================================================
// 12 TITIK AKUPRESUR MATA (6 KIRI + 6 KANAN) - TERBARU & AKURAT
// ==============================================================================
// Berdasarkan standar akupresur TCM dan mapping MediaPipe FaceMesh landmarks

final List<AcupressurePoint> acupressureSequence = [
  // ════════════════════════════════════════════════════════════════════════════
  // MATA KIRI (6 Titik)
  // ════════════════════════════════════════════════════════════════════════════

  // 1. JINGMING (BL1) - Sudut mata dalam dekat hidung
  AcupressurePoint(
    title: "Mata Kiri: Jingming",
    instruction: "Pijat sudut mata kiri dekat hidung. Tahan 10 detik.",
    description: "Titik Jingming (BL1) - Menjernihkan mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 18.0, // Ke arah hidung
    offsetY: 0.0,
  ),

  // 2. ZANZHU (BL2) - Pangkal alis dekat hidung
  AcupressurePoint(
    title: "Mata Kiri: Zanzhu",
    instruction: "Pijat pangkal alis kiri dekat hidung.",
    description: "Titik Zanzhu (BL2) - Redakan sakit kepala",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 8.0, // Sedikit ke kanan dari sudut mata
    offsetY: -28.0, // Tepat di bawah alis
  ),

  // 3. YUYAO - Tengah alis
  AcupressurePoint(
    title: "Mata Kiri: Yuyao",
    instruction: "Pijat tengah alis kira. Tahan 10 detik.",
    description: "Titik Yuyao - Sehatkan mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -8.0, // Dari titik mata ke tengah
    offsetY: -32.0, // Lebih tinggi dari Zanzhu
  ),

  // 4. SIZHUKONG (SJ23) - Ujung alis
  AcupressurePoint(
    title: "Mata Kiri: Sizhukong",
    instruction: "Pijat ujung alis kiri menuju pelipis.",
    description: "Titik Sizhukong (SJ23) - Hilangkan kelelahan mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -35.0, // Jauh ke pelipis
    offsetY: -18.0, // Di bawah alis
  ),

  // 5. TONGZILIAO (GB1) - Sudut mata luar
  AcupressurePoint(
    title: "Mata Kiri: Tongziliao",
    instruction: "Pijat sudut mata kiri luar dekat pelipis.",
    description: "Titik Tongziliao (GB1) - Lindungi penglihatan",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -38.0, // Ke arah pelipis
    offsetY: 0.0,
  ),

  // 6. QIUHOU - Bawah mata tengah
  AcupressurePoint(
    title: "Mata Kiri: Qiuhou",
    instruction: "Pijat tulang bawah kelopak mata kiri tengah.",
    description: "Titik Qiuhou - Atasi mata kering",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 0.0,
    offsetY: 25.0, // Tepat di bawah pupil
  ),

  // ════════════════════════════════════════════════════════════════════════════
  // MATA KANAN (6 Titik)
  // ════════════════════════════════════════════════════════════════════════════

  // 7. JINGMING (BL1) - Sudut mata kanan dekat hidung
  AcupressurePoint(
    title: "Mata Kanan: Jingming",
    instruction: "Pijat sudut mata kanan dekat hidung. Tahan 10 detik.",
    description: "Titik Jingming (BL1) - Menjernihkan mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: -18.0, // Ke arah hidung
    offsetY: 0.0,
  ),

  // 8. ZANZHU (BL2) - Pangkal alis kanan dekat hidung
  AcupressurePoint(
    title: "Mata Kanan: Zanzhu",
    instruction: "Pijat pangkal alis kanan dekat hidung.",
    description: "Titik Zanzhu (BL2) - Redakan sakit kepala",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: -8.0,
    offsetY: -28.0,
  ),

  // 9. YUYAO - Tengah alis kanan
  AcupressurePoint(
    title: "Mata Kanan: Yuyao",
    instruction: "Pijat tengah alis kanan. Tahan 10 detik.",
    description: "Titik Yuyao - Sehatkan mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 8.0,
    offsetY: -32.0,
  ),

  // 10. SIZHUKONG (SJ23) - Ujung alis kanan
  AcupressurePoint(
    title: "Mata Kanan: Sizhukong",
    instruction: "Pijat ujung alis kanan menuju pelipis.",
    description: "Titik Sizhukong (SJ23) - Hilangkan kelelahan mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 35.0, // Ke arah pelipis
    offsetY: -18.0,
  ),

  // 11. TONGZILIAO (GB1) - Sudut mata kanan luar
  AcupressurePoint(
    title: "Mata Kanan: Tongziliao",
    instruction: "Pijat sudut mata kanan luar dekat pelipis.",
    description: "Titik Tongziliao (GB1) - Lindungi penglihatan",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 38.0, // Ke arah pelipis
    offsetY: 0.0,
  ),

  // 12. QIUHOU - Bawah mata kanan tengah
  AcupressurePoint(
    title: "Mata Kanan: Qiuhou",
    instruction: "Pijat tulang bawah kelopak mata kanan tengah.",
    description: "Titik Qiuhou - Atasi mata kering",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 0.0,
    offsetY: 25.0,
  ),
];
