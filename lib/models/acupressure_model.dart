// Lokasi: lib/models/acupressure_model.dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum EyeSide { left, right }

class AcupressurePoint {
  final String title;
  final String instruction;
  final FaceLandmarkType landmarkType; // Titik referensi (Mata Kiri / Kanan)
  final EyeSide side;
  final double offsetX; // Geser Horizontal (Negatif = Kiri Layar, Positif = Kanan Layar)
  final double offsetY; // Geser Vertikal (Negatif = Atas, Positif = Bawah)

  AcupressurePoint({
    required this.title,
    required this.instruction,
    required this.landmarkType,
    required this.side,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  });
}

// Data statis: Urutan 8 Titik Pijat (4 Kiri, 4 Kanan)
// Diasumsikan tampilan kamera adalah MIRROR (Cermin)
// Mata Kiri User ada di sisi KIRI Layar.
// Mata Kanan User ada di sisi KANAN Layar.

final List<AcupressurePoint> acupressureSequence = [
  // --- MATA KIRI ---
  
  // 1. Dekat Hidung (Jingming) - Mata Kiri
  AcupressurePoint(
    title: "Mata Kiri: Sudut Dalam",
    instruction: "Pijat bagian sudut mata kiri dekat hidung (Titik Jingming).",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 18.0, // Geser ke Kanan Layar (ke arah hidung)
    offsetY: 0.0,
  ),

  // 2. Atas Mata (Alis/Zan Zhu) - Mata Kiri
  AcupressurePoint(
    title: "Mata Kiri: Alis/Atas",
    instruction: "Pijat bagian pangkal alis atau kelopak atas mata kiri.",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 0.0,
    offsetY: -28.0, // Geser ke Atas
  ),

  // 3. Pelipis (Taiyang) - Mata Kiri
  AcupressurePoint(
    title: "Mata Kiri: Pelipis",
    instruction: "Pijat bagian ujung luar mata kiri (arah pelipis).",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -35.0, // Geser jauh ke Kiri Layar (ke arah kuping)
    offsetY: -5.0,
  ),

  // 4. Bawah Mata (Chengqi) - Mata Kiri
  AcupressurePoint(
    title: "Mata Kiri: Bawah Kelopak",
    instruction: "Pijat bagian tulang bawah kelopak mata kiri.",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 0.0,
    offsetY: 25.0, // Geser ke Bawah
  ),


  // --- MATA KANAN ---

  // 5. Dekat Hidung (Jingming) - Mata Kanan
  AcupressurePoint(
    title: "Mata Kanan: Sudut Dalam",
    instruction: "Pijat bagian sudut mata kanan dekat hidung.",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: -18.0, // Geser ke Kiri Layar (ke arah hidung)
    offsetY: 0.0,
  ),

  // 6. Atas Mata (Alis/Zan Zhu) - Mata Kanan
  AcupressurePoint(
    title: "Mata Kanan: Alis/Atas",
    instruction: "Pijat bagian pangkal alis atau kelopak atas mata kanan.",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 0.0,
    offsetY: -28.0, // Geser ke Atas
  ),

  // 7. Pelipis (Taiyang) - Mata Kanan
  AcupressurePoint(
    title: "Mata Kanan: Pelipis",
    instruction: "Pijat bagian ujung luar mata kanan (arah pelipis).",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 35.0, // Geser jauh ke Kanan Layar (ke arah kuping)
    offsetY: -5.0,
  ),

  // 8. Bawah Mata (Chengqi) - Mata Kanan
  AcupressurePoint(
    title: "Mata Kanan: Bawah Kelopak",
    instruction: "Pijat bagian tulang bawah kelopak mata kanan.",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 0.0,
    offsetY: 25.0, // Geser ke Bawah
  ),
];